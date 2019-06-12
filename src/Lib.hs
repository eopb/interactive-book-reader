module Lib
    ( bookFromFile
    , run
    )
where

import           Structure

import qualified Data.Text.Lazy                as T
import           Control.Lens
import           Data.Map.Strict

run :: Book -> IO ()
run book = do
    run' book (firstChapter book)
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
        BChoices c -> displayChoices c


displayChoices :: [BChoice] -> IO ()
displayChoices c = do
    print $ mconcat ["You have ", show (length c), " choices."]
    head
        (fmap
            (\(c, index) ->
                print
                    (mconcat [show index, ") ", T.unpack (c ^. choiceContent)])
            )
            (zip c [0 ..])
        )
