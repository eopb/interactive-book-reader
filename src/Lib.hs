module Lib
    ( mainTask
    , bookFromFile
    )
where

import           Parse

import           Data.Text.Lazy                as T

data Book = Book { chapters :: [Chapter] } deriving (Show)


data Chapter = Chapter
    { key         :: Int
    , content     :: Maybe T.Text
    , chapterType :: ChapterType
    } deriving (Show)

data ChapterType = Choices [Choice] | Redirect Int | End deriving (Show)

data Choice = Choice
    { choiceContent :: T.Text
    , goesTo        :: Int
    } deriving (Show)

