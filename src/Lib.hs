module Lib
    ( mainTask
    )
where

import           Data.Text                     as T
import           Yaml

mainTask :: IO ()
mainTask = putStrLnT yaml

putStrLnT :: T.Text -> IO ()
putStrLnT = putStrLn . T.unpack

