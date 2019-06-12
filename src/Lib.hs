module Lib
    ( bookFromFile
    )
where

import           Structure
import           Control.Lens
import           Data.Map.Strict

run :: IO ()
run = do
    book <- bookFromFile
    case book of
        Right book -> run' book (firstChapter book)
    return ()

firstChapter :: Book -> Chapter
firstChapter b = (b ^. chapters) ! 1


run' :: Book -> Chapter -> IO ()
run' b c = do
    case (c ^. content) of
        Just content -> print content
        Nothing      -> return ()
    case (c ^. chapterType) of
        End        -> return ()
        Redirect n -> run' b ((b ^. chapters) ! n)
        BChoices c -> print $ mconcat ["You have ", " choices."]



