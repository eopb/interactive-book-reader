module Parse
    ( mainTask
    , bookFromFile
    , chapters
    , Book
    , Chapter
    , YChoice
    , key
    , content
    , end
    , redirectTo
    , choices
    , choiceContent
    , goesTo
    )
where

import           Data.Text.Lazy                as T
import           Yaml
import           Data.Yaml                     as Y
import           GHC.Generics
import           Data.ByteString               as BS
import           Prelude                       as P
import           System.IO                     as S
import           Control.Lens



data YChoice = Choice
     { _choiceContent :: T.Text
     , _goesTo        :: Int
     } deriving (Show, Generic)
instance FromJSON YChoice where
    parseJSON (Object v) = Choice <$> v .: "content" <*> v .: "goes-to"
    parseJSON e          = error $ show e
makeLenses ''YChoice

data Chapter = Chapter
     { _key        :: Int
     , _content    :: Maybe T.Text
     , _choices    :: Maybe [YChoice]
     , _redirectTo :: Maybe Int
     , _end        :: Maybe Bool
     } deriving (Show, Generic)
instance FromJSON Chapter where
    parseJSON (Object v) =
        Chapter
            <$> v
            .:  "key"
            <*> v
            .:? "content"
            <*> v
            .:? "choices"
            <*> v
            .:? "redirect-to"
            <*> v
            .:? "end"
    parseJSON e = error $ show e
makeLenses ''Chapter

data Book = Book
     { _chapters     :: [Chapter]
     } deriving (Show, Generic)
instance FromJSON Book where
    parseJSON (Object v) = Book <$> v .: "chapters"
    parseJSON e          = error $ show e
makeLenses ''Book

mainTask :: IO ()
mainTask = print (decodeBook yaml)

decodeBook :: BS.ByteString -> Either ParseException Book
decodeBook = decodeEither'

putStrLnT :: T.Text -> IO ()
putStrLnT = P.putStrLn . T.unpack


bookFromFile :: IO (Either ParseException Book)
bookFromFile = do
    handle   <- openFile "book.yaml" ReadMode
    contents <- BS.hGetContents handle
    pure $ decodeBook contents

