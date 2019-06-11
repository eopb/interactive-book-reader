module Lib
    ( Y.mainTask
    , Y.bookFromFile
    , structureBook
    )
where

import qualified Parse                         as Y

import qualified Data.Text.Lazy                as T
import           Control.Lens
import           Data.Maybe

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
structureChapters = fmap structureChapter

structureChapter :: Y.Chapter -> Chapter
structureChapter y = Chapter { key         = y ^. Y.key
                             , content     = y ^. Y.content
                             , chapterType = getChapterType y
                             }

getChapterType :: Y.Chapter -> ChapterType
getChapterType y = firstJust
    [ do
        end <- y ^. Y.end
        if end then pure End else Nothing
    , Redirect <$> (y ^. Y.redirectTo)
    , structureChoices <$> (y ^. Y.choices)
    ]
firstJust = head . catMaybes

structureChoices :: [Y.YChoice] -> ChapterType
structureChoices = BChoices . map structureChoice

structureChoice :: Y.YChoice -> BChoice
structureChoice y =
    BChoice { choiceContent = y ^. Y.choiceContent, goesTo = y ^. Y.goesTo }
