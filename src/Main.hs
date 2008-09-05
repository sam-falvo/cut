module Main(main) where


import CutEmit
import CutLexer
import CutOptions
import CutParser
import IO
import qualified Data.ByteString.Char8      as S
import qualified Data.ByteString.Lazy.Char8 as B
import System.Environment


-- The program works, at the top-most level, by munching on arguments
-- an error is detected, a request for help is discovered, or until
-- all specified source files have been processed and the test runner
-- emitted.  At the risk of parroting, here is the top-level code.

main :: IO ()
main = do
  argv <- getArgs

  let (options, files, errors) = CutOptions.lists argv
  let commandName              = head argv
  let usageInformation         = CutOptions.usage commandName
  let productVersion           = CutOptions.version commandName
  let showHelp                 = CutOptions.HelpRequested `elem` options
  let showVersion              = CutOptions.VersionRequested `elem` options

  case () of
   _ | nonempty errors -> putErrors errors
     | showHelp        -> putStr usageInformation
     | showVersion     -> putStr productVersion
     | otherwise       -> produceTestRunner files


-- Sometimes you just plain need to create synonyms for common idioms
-- so that you can maintain source code legibility.  SICP calls this
-- "the power of wishful thinking."  Extreme programmers call this
-- "self-documenting code that tells what, not how."  Forth coders call
-- this "factor, factor, factor."

nonempty :: [a] -> Bool
nonempty list = not $ null list


-- Any errors that are produced need to be communicated to the user.

putErrors :: [String] -> IO ()
putErrors [] = return ()
putErrors (error:moreErrors) = do
  putStr error
  putErrors moreErrors


-- The test runner is a *single* C file, that is responsible for invoking
-- the various test functions in the correct order.  These functions may
-- be spanned across any number of files (however, bringup/setup contexts
-- must reside be enclosed by the file they're opened in), so we build a
-- single parse tree from *all* source files first.

produceTestRunner :: [String] -> IO ()
produceTestRunner files = do
  nodes <- process files

  let testRunner = CutEmit.testRunner nodes
  case () of
   _ | nonempty nodes -> dump (S.hPut IO.stdout) testRunner
     | otherwise      -> return ()

  where
    dump output (CutEmit.Chunk c) = output c
    dump output (CutEmit.Chunks cs) = mapM_ (dump output) cs

-- This seemingly convoluted piece of code takes a list of filenames, and
-- returns a single parse tree that covers all the test cases in all the
-- files, in the order they're discovered.

process :: [String] -> IO [CutParsed]
process [] = return []
process (name:names) = do
  body <- S.readFile name
  otherFiles <- process names
  let preReversed = CutLexer.parseString body
  let lexed = reverse preReversed
  let parsed = CutParser.parse lexed
  return $ concat $ parsed:[otherFiles]

