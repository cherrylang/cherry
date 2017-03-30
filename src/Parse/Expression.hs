module Parse.Expression where

import           Text.Megaparsec      (try, (<|>))
import qualified Text.Megaparsec      as P
import qualified Text.Megaparsec.Expr as P

import qualified Parse.Lexer          as L
import           Parse.Parse
import qualified Syntax               as Ch


expr :: Parser Ch.Expr
expr = try app
   <|> try infixApp
   <|> try term


term :: Parser Ch.Expr
term = try $ L.parens expr
   <|> try lit
   <|> try prop
   <|> try var


prop :: Parser Ch.Expr
prop = do
  pos  <- L.pos
  prop <- L.prop
  return $ Ch.Prop pos prop


var :: Parser Ch.Expr
var = (Ch.Var <$> L.pos) <*> L.ident


infixApp :: Parser Ch.Expr
infixApp = P.makeExprParser (try app <|> term) table
  where
    infixP = do
      pos <- L.pos
      inf <- L.infixOp
      return $ \e e' -> Ch.App pos (Ch.App pos (Ch.Var pos inf) e) e'

    table =
      [[ P.InfixL infixP ]]


app :: Parser Ch.Expr
app = do
  pos  <- L.pos
  func <- term
  args <- P.some term
  return $ foldl (\app arg -> Ch.App pos app arg) func args


lit :: Parser Ch.Expr
lit = Ch.Lit <$> L.pos <*>
     (try string
  <|> try bool
  <|> try float
  <|> try int
  <|> try void)



-- LITERALS


string :: Parser Ch.Lit
string = Ch.String <$> L.doubleQuotes (P.many $ P.noneOf ['"'])


bool :: Parser Ch.Lit
bool = try (L.rWord "True" >> return (Ch.Bool True))
   <|> try (L.rWord "False" >> return (Ch.Bool False))


int :: Parser Ch.Lit
int = Ch.Int . fromIntegral <$> L.integer


float :: Parser Ch.Lit
float = Ch.Float <$> L.float


void :: Parser Ch.Lit
void = L.sym "()" >> return Ch.Void
