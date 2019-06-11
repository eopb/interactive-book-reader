module Lib
    ( mainTask
    )
where


import           Data.Text                     as T

mainTask :: IO ()
mainTask = putStrLnT yaml





yaml :: T.Text
yaml = multiLineText
    [ "book:"
    , "  -"
    , "    chapter: 1"
    , "    content: >"
    , "      Welcome to the test book for this program"
    , "      You have 3 options."
    ]

multiLineText :: [T.Text] -> T.Text
multiLineText t = T.concat (fmap (\x -> append x "\n") t)


putStrLnT :: T.Text -> IO ()
putStrLnT = putStrLn . T.unpack
