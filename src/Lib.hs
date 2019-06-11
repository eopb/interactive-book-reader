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
import           Parse


