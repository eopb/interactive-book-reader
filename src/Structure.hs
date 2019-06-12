module Structure
    ( bookFromFile
    , Book
    , Chapter
    , BChoice
    , ChapterType(End, Redirect, BChoices)
    , chapters
    , content
    , chapterType
    )
where

import qualified Parse                         as Y

import qualified Data.Text.Lazy                as T
import           Control.Lens
import           Data.Maybe
import qualified Data.Map.Strict               as M


data BChoice = BChoice
    { _choiceContent :: T.Text
    , _goesTo        :: Int
    } deriving (Show)

data ChapterType = BChoices [BChoice] | Redirect Int | End deriving (Show)

data Chapter = Chapter
    { _content     :: Maybe T.Text
    , _chapterType :: ChapterType
    } deriving (Show)
makeLenses ''Chapter

newtype Book = Book { _chapters :: M.Map Int Chapter } deriving (Show)
makeLenses ''Book




structureBook :: Y.Book -> Book
structureBook y = Book { _chapters = structureChapters (y ^. Y.chapters) }

structureChapters :: [Y.Chapter] -> M.Map Int Chapter
structureChapters = M.fromList . fmap structureChapter

structureChapter :: Y.Chapter -> (Int, Chapter)
structureChapter y =
    ( y ^. Y.key
    , Chapter { _content = y ^. Y.content, _chapterType = getChapterType y }
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
    BChoice { _choiceContent = y ^. Y.choiceContent, _goesTo = y ^. Y.goesTo }

bookFromFile :: IO (Either Y.ParseException Book)
bookFromFile = (fmap . fmap) structureBook Y.bookFromFile




