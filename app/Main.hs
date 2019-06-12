module Main where

import           Lib
import           Text.Pretty.Simple             ( pPrint )

main :: IO ()
main = do
    book <- bookFromFile
    pPrint book
    case book of
        Right b -> run b

