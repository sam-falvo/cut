{-# OPTIONS -fglasgow-exts -fbang-patterns -funbox-strict-fields #-}
{-
  CutLexer.hs
  CUT Release 2.6-Experimental
  Copyright (c) 2007 Samuel A. Falvo II, William D. Tanksley Jr.
  See LICENSE for details.

  2007-Mar-10 Samuel A. Falvo II

  The parser module is used to take a list of strings, each representing
  a single line in a source code file, and produce either an error
  message or a list of CutNodes, in turn corresponding to the overall
  structure of the unit tests and their environments contained in the
  file.
-}

module CutLexer where

import Data.Char
import Data.Maybe

-- Strict bytestrings, O(1) substrings
import qualified Data.ByteString.Char8      as S
import qualified Data.ByteString.Base       as S

-- A CutToken describes one of the many types of constructs found in a
-- typical unit test source file.  There are five "productions:"

data CutToken  = Test       S.ByteString   -- Normal unit test
               | Bringup    S.ByteString   -- A BRINGUP environment
               | Setup      S.ByteString   -- A SETUP environment
               | Takedown   S.ByteString   -- An environment TAKEDOWN
               | Error      S.ByteString   -- A detected error of some kind
               deriving(Show)

-- To parse a string, we need a fold operation that allows us to work with
-- substrings as if they were single entities.  The normal S.foldl function
-- assumes we want our processing function to be invoked for all bytes in the
-- string.  When dealing with tokens as a whole, this is insufficient.  However,
-- there is no built-in function to perform this task in the ByteString libraries.
-- Therefore, we produce a variant of foldl below, allowing us to "skip over"
-- parts of the string that we don't want to deal with.

foldlS :: (a -> S.ByteString -> (a, S.ByteString)) -> a -> S.ByteString -> a
foldlS f i s =
  let (i', s') = f i s
  in  if S.null s' then i' else foldlS f i' s'

-- We now have the tools needed to parse an arbitrary string containing source
-- code.  Note that we need to express the _entire_ source code of a file in a
-- single string.

parseString :: S.ByteString -> [CutToken]
parseString s = foldlS parseTokens [] s

-- Given a string that starts with some token (__CUT_...), we need to find the
-- token's name, plus return the remainder of the string.

parseOut :: Int -> S.ByteString -> (S.ByteString, S.ByteString)
parseOut tokenLength str =
  let str'   = S.drop tokenLength str
      name   = S.takeWhile (\x -> x `S.elem` nameSpecChars) str'
      rest   = S.drop (S.length name) str'
  in  (name, rest)

nameSpecChars  = S.pack $ '_' : ['a'..'z'] ++ ['A'..'Z'] ++ ['0'..'9']

-- Our tokens all are identified via a standard set of prefixes.

testPrefix              = "__CUT__"
takedownPrefix          = "__CUT_TAKEDOWN__"
bringupPrefix           = "__CUT_BRINGUP__"
setupPrefix             = "__CUT_SETUP__"

-- Because we are going to be needing them in both packed and unpacked
-- forms, we will define their packed equivalents too.

packedTestPrefixS       = S.pack testPrefix
packedTakedownPrefixS   = S.pack takedownPrefix
packedBringupPrefixS    = S.pack bringupPrefix
packedSetupPrefixS      = S.pack setupPrefix

-- Parsing tokens is done via prefix matching.

parseTokens :: [CutToken] -> S.ByteString -> ([CutToken], S.ByteString)
parseTokens state input =
  let isTest     = packedTestPrefixS `S.isPrefixOf` input
      isBringup  = packedBringupPrefixS `S.isPrefixOf` input
      isSetup    = packedSetupPrefixS `S.isPrefixOf` input
      isTakedown = packedTakedownPrefixS `S.isPrefixOf` input

      testTokenLength     = S.length packedTestPrefixS
      bringupTokenLength  = S.length packedBringupPrefixS
      setupTokenLength    = S.length packedSetupPrefixS
      takedownTokenLength = S.length packedTakedownPrefixS

      testFor nodes str =
        let (n,str') = parseOut testTokenLength str
        in  ((Test n:nodes), str')

      bringupFor nodes str =
        let (n,str') = parseOut bringupTokenLength str
        in (((Bringup n):nodes), str')

      setupFor nodes str =
        let (n,str') = parseOut setupTokenLength str
        in (((Setup n):nodes), str')

      takedownFor nodes str =
        let (n,str') = parseOut takedownTokenLength str
        in  ((Takedown n:nodes), str')

  in  case () of
       _ | isTest     -> testFor state input
         | isBringup  -> bringupFor state input
         | isSetup    -> setupFor state input
         | isTakedown -> takedownFor state input
         | otherwise  -> (state, S.tail input)

-- Sometimes, we will need to reconstruct the identifier that generated a given
-- node.

testIdFor, takedownIdFor, bringupIdFor, setupIdFor ::
    S.ByteString -> S.ByteString

testIdFor s     = S.concat $ packedTestPrefixS:[s]
takedownIdFor s = S.concat $ packedTakedownPrefixS:[s]
bringupIdFor s  = S.concat $ packedBringupPrefixS:[s]
setupIdFor s    = S.concat $ packedSetupPrefixS:[s]

