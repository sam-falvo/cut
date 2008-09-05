{-
  CutOptions.hs
  CUT Release 2.6-Experimental
  Copyright (c) 2007 Samuel A. Falvo II, William D. Tanksley Jr.
  See LICENSE for details.

  2007-Mar-17 Samuel A. Falvo II

  Collects command-line arguments and parses them into usable information.
-}

module CutOptions where

import IO
import System.Console.GetOpt


data CmdFlag = HelpRequested
             | VersionRequested
             | OutputFile String
             | IncludeSpec String
             deriving(Show,Eq)


options :: [OptDescr CmdFlag]
options = [
  Option ['h','?'] ["help"]         (NoArg HelpRequested)       "Displays this help reference.",
  Option ['V']     ["version"]      (NoArg VersionRequested)    "Displays version, then exits.",
  Option ['o']     ["output"]       (ReqArg OutputFile "FILE")  "Sets output FILE.  If unspecified, defaults to stdout.",
  Option ['i']     ["include-spec"] (ReqArg IncludeSpec "SPEC") "Sets the CUT include specification; defaults to \"<cut/3/cut.h>\"."
  ]

lists :: [String] -> ([CmdFlag], [String], [String])
lists = getOpt Permute options

usage :: String -> String
usage commandName = (version commandName) ++ (usageInfo commandName options) ++ "  file [file [...]]  Input file(s)\n"

version :: String -> String
version commandName = "CUT Release 2.6 (invoked as " ++ commandName ++ ")\n\n"

outputFileHandle :: [CmdFlag] -> IO Handle
outputFileHandle flags = fileHandleFrom flags IO.stdout
  where fileHandleFrom [] defaultHandle = do return defaultHandle
        fileHandleFrom (f:flags) defaultHandle = do
          case f of
            (OutputFile s) -> openFile s WriteMode
            otherwise      -> fileHandleFrom flags defaultHandle

headerSpec :: [CmdFlag] -> String
headerSpec flags = chooseHeaderSpec flags "<cut/3/cut.h>"
  where chooseHeaderSpec [] defaultSpec = defaultSpec
        chooseHeaderSpec (f:flags) defaultSpec =
          case f of
            (IncludeSpec spec) -> spec
            otherwise          -> chooseHeaderSpec flags defaultSpec

