module Lib
    ( Y.mainTask
    , Y.bookFromFile
    )
where

import qualified Parse                         as Y

import           Data.Text.Lazy                as T
import           Control.Lens

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

structureBook :: Y.Book -> Book
structureBook y = Book { chapters = structureChapters (y ^. Y.chapters) }

structureChapters :: [Y.Chapter] -> [Chapter]
structureChapters = error ""
