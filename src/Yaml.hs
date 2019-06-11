module Yaml
    ( yaml
    )
where


import           Data.Text                     as T


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


