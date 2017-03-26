module Typecheck where

import qualified Syntax                as Ch
import           Typecheck.Environment (emptyEnv)
import           Typecheck.Error
import           Typecheck.Infer       (infer)
import           Typecheck.Solve       (solve)


typecheck :: Ch.Module -> Either Error Ch.Module
typecheck m =
  case infer emptyEnv m of
    Left err -> Left err
    Right s@(_, constraints) -> case solve constraints of
      Left err -> Left err
      Right _  -> Right m
