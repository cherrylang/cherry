module Syntax.Position where


data Pos
  = Pos
  { srcFile :: FilePath
  , srcLine :: Int
  , srcCol  :: Int
  }
  deriving (Show, Eq, Ord)


emptyPos :: Pos
emptyPos =
  Pos
    { srcFile = ""
    , srcLine = 0
    , srcCol  = 0
    }
