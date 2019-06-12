module Lib
    ( bookFromFile
    )
where

import           Structure
import           Control.Lens
import           Data.Map.Strict

run :: IO ()
run = do
    bookFromFile
    return ()

firstChapter :: Book -> Chapter
firstChapter x = (x ^. chapters) ! 1
