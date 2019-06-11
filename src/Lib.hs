module Lib
    ( mainTask
    , bookFromFile
    )
where

import           Parse

data Book = Book { chapters :: [Chapter] } deriving (Show)


data Chapter = Chapter
    { key        :: Int
    } deriving (Show)
