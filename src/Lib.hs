module Lib
    ( mainTask
    , bookFromFile
    )
where

import           Data.Text.Lazy                as T
import           Yaml
import           Data.Yaml                     as Y
import           GHC.Generics
import           Data.ByteString               as BS
import           Data.Text.Lazy.Encoding       as TLE
import           Prelude                       as P
import           Data.Yaml.Builder
import           System.IO                     as S
import           Text.Pretty.Simple             ( pPrint )

data Book = Book
    { chapters     :: [Chapter]
    } deriving (Show, Generic)
instance FromJSON Book where
    parseJSON (Object v) = Book <$> v .: "chapters"
    parseJSON e          = error $ show e

data Chapter = Chapter
    { key        :: Int
    , content    :: Maybe T.Text
    , choices    :: Maybe [Choice]
    , redirectTo :: Maybe Int
    , end        :: Maybe Bool
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

data Choice = Choice
    { choiceContent :: Maybe T.Text
    , goesTo        :: Maybe Int
    } deriving (Show, Generic)
instance FromJSON Choice where
    parseJSON (Object v) = Choice <$> v .:? "content" <*> v .:? "goes-to"
    parseJSON e          = error $ show e


mainTask :: IO ()
mainTask = print (decodeBook yaml)

decodeBook :: BS.ByteString -> Either ParseException Book
decodeBook = decodeEither'

putStrLnT :: T.Text -> IO ()
putStrLnT = P.putStrLn . T.unpack



bookFromFile = do
    handle   <- openFile "book.yaml" ReadMode
    contents <- BS.hGetContents handle
    pPrint (decodeBook contents)
    hClose handle
