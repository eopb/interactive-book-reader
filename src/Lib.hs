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

data ChapterType = BChoices [BChoice] | Redirect Int | End deriving (Show)

data BChoice = BChoice
    { choiceContent :: T.Text
    , goesTo        :: Int
    } deriving (Show)

structureBook :: YBook -> Book
structureBook y = Book { chapters = error "" }

