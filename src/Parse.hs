module Parse
    ( mainTask
    , bookFromFile
    , YBook
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
     { _choiceContent :: Maybe T.Text
     , _goesTo        :: Int
     } deriving (Show, Generic)
instance FromJSON YChoice where
    parseJSON (Object v) = Choice <$> v .:? "content" <*> v .: "goes-to"
    parseJSON e          = error $ show e

data YChapter = Chapter
     { _key        :: Int
     , _content    :: Maybe T.Text
     , _choices    :: Maybe [YChoice]
     , _redirectTo :: Maybe Int
     , _end        :: Maybe Bool
     } deriving (Show, Generic)
instance FromJSON YChapter where
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

data YBook = Book
     { _chapters     :: [YChapter]
     } deriving (Show, Generic)
instance FromJSON YBook where
    parseJSON (Object v) = Book <$> v .: "chapters"
    parseJSON e          = error $ show e
makeLenses ''YBook

mainTask :: IO ()
mainTask = print (decodeBook yaml)

decodeBook :: BS.ByteString -> Either ParseException YBook
decodeBook = decodeEither'

putStrLnT :: T.Text -> IO ()
putStrLnT = P.putStrLn . T.unpack


bookFromFile :: IO (Either ParseException YBook)
bookFromFile = do
    handle   <- openFile "book.yaml" ReadMode
    contents <- BS.hGetContents handle
    pure $ decodeBook contents

