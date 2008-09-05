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
             deriving(Show,Eq)


options :: [OptDescr CmdFlag]
options = [
  Option ['h','?'] ["help"] (NoArg HelpRequested) "Displays this help reference",
  Option ['V'] ["version"] (NoArg VersionRequested) "Displays version, then exits"
  ]

lists :: [String] -> ([CmdFlag], [String], [String])
lists = getOpt Permute options

usage :: String -> String
usage commandName = (version commandName) ++ (usageInfo commandName options) ++ "  file [file [...]]  Input file(s)\n"

version :: String -> String
version commandName = "CUT/NG Release 2.6/X (invoked as " ++ commandName ++ ")\n\n"

