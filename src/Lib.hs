module Lib
    ( bookFromFile
    , run
    )
where

import           Structure

import qualified Data.Text.Lazy                as T
import           Control.Lens
import           Data.Map.Strict
import           Data.Foldable

run :: Book -> IO ()
run book = do
    run' book (firstChapter book)
    return ()

firstChapter :: Book -> Chapter
firstChapter b = (b ^. chapters) ! 1


run' :: Book -> Chapter -> IO ()
run' b c = do
    forM_ (c ^. content) print
    case c ^. chapterType of
        End        -> return ()
        Redirect n -> run' b ((b ^. chapters) ! n)
        BChoices c -> displayChoices c


displayChoices :: [BChoice] -> IO ()
displayChoices c = do
    putStrLn $ mconcat ["You have ", show $ length c, " choices."]
    putStrLn $ listChoices c 0

listChoices :: [BChoice] -> Int -> String
listChoices c i = mconcat
    [ show $ i + 1
    , ") "
    , T.unpack $ head c ^. choiceContent
    , "\n"
    , if length c == 1 then "" else listChoices (tail c) (i + 1)
    ]
