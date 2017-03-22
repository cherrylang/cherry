module Parse.Declaration where

import           Text.Megaparsec  (try)
import qualified Text.Megaparsec  as P

import qualified Parse.Expression as P
import qualified Parse.Lexer      as L
import           Parse.Parse
import qualified Syntax           as Ch


decl :: Parser Ch.Declaration
decl = try func


func :: Parser Ch.Declaration
func = L.refIndent >> do
  name   <- L.ident
  params <- P.many L.ident
  L.equals *> L.scn
  exprs  <- P.some (L.indented *> P.expr <* L.scn)
  return $ Ch.Func (name, length params) params exprs
