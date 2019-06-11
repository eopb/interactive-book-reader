module Structure
    ( bookFromFile
    )
where

import qualified Parse                         as Y

import qualified Data.Text.Lazy                as T
import           Control.Lens
import           Data.Maybe
import qualified Data.Map.Strict               as M

newtype Book = Book { chapters :: M.Map Int Chapter } deriving (Show)


data Chapter = Chapter
    { content     :: Maybe T.Text
    , chapterType :: ChapterType
    } deriving (Show)

data ChapterType = BChoices [BChoice] | Redirect Int | End deriving (Show)

data BChoice = BChoice
    { choiceContent :: T.Text
    , goesTo        :: Int
    } deriving (Show)

structureBook :: Y.Book -> Book
structureBook y = Book { chapters = structureChapters (y ^. Y.chapters) }

structureChapters :: [Y.Chapter] -> M.Map Int Chapter
structureChapters = M.fromList . fmap structureChapter

structureChapter :: Y.Chapter -> (Int, Chapter)
structureChapter y =
    ( y ^. Y.key
    , Chapter { content = y ^. Y.content, chapterType = getChapterType y }
    )

getChapterType :: Y.Chapter -> ChapterType
getChapterType y = firstJust
    [ do
        end <- y ^. Y.end
        if end then pure End else Nothing
    , Redirect <$> (y ^. Y.redirectTo)
    , structureChoices <$> (y ^. Y.choices)
    ]
firstJust :: [Maybe c] -> c
firstJust = head . catMaybes

structureChoices :: [Y.YChoice] -> ChapterType
structureChoices = BChoices . map structureChoice

structureChoice :: Y.YChoice -> BChoice
structureChoice y =
    BChoice { choiceContent = y ^. Y.choiceContent, goesTo = y ^. Y.goesTo }

bookFromFile :: IO (Either Y.ParseException Book)
bookFromFile = (fmap . fmap) structureBook Y.bookFromFile




