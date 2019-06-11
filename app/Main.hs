module Main where

import           Lib
import           Text.Pretty.Simple             ( pPrint )

main :: IO ()
main = ((fmap . fmap) structureBook bookFromFile) >>= pPrint

