module Lib
    ( mainTask
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

data Book = Book
    { chapters     :: [Chapter]
    } deriving (Show, Generic)
instance FromJSON Book where
    parseJSON (Object v) = Book <$> v .: "chapters"
    parseJSON e          = error $ show e

data Chapter = Chapter
    { key     :: Int
    , content :: T.Text
    } deriving (Show, Generic)
instance FromJSON Chapter where
    parseJSON (Object v) = Chapter <$> v .: "key" <*> v .: "content"
    parseJSON e          = error $ show e


mainTask :: IO ()
mainTask = print decodeBook

decodeBook :: Either ParseException Book
decodeBook = decodeEither' yaml

putStrLnT :: T.Text -> IO ()
putStrLnT = P.putStrLn . T.unpack

