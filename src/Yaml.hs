module Yaml
    ( yaml
    )
where


import           Data.Text.Lazy                as T
import           Data.ByteString               as BS


yaml :: BS.ByteString
yaml = multiLineText
    [ "chapters:"
    , "  -"
    , "    key: 1"
    , "    content: >"
    , "      Welcome to the test book for this program"
    , "      You have 3 options."
    ]


multiLineText :: [BS.ByteString] -> BS.ByteString
multiLineText t = BS.concat (fmap (\x -> BS.append x "\n") t)


