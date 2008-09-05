{-
  CutParser.hs
  CUT/NG Release 2.6

  This file takes a list of CutTokens and produces a proper tree tests,
  bringups, and setups (and the appropriate takedowns when appropriate).
-}

module CutParser where

import qualified CutLexer              as L
import qualified Data.ByteString.Char8 as S
import Data.List

-- The parse nodes closely mirrors the set of tokens described in CutLexer.
-- The primary differences occur in the Bringup and Setup nodes, which properly
-- nest their children.

data CutParsed = Test     S.ByteString
               | Takedown S.ByteString
               | Bringup  S.ByteString [CutParsed]
               | Setup    S.ByteString [CutParsed]
               | Error    S.ByteString
               deriving(Show,Eq)

-- The parse function is used to convert a flat list of tokens into a proper
-- parse tree for subsequent pretty printing.  This will be an LR(0)
-- parser when it grows up.  NOTE: We reverse the list from parse0 (the
-- iterative component of parse) because it builds its top-level expression
-- tree backwards (due to how Haskell lists work).

parse :: [L.CutToken] -> [CutParsed]
parse ts = reverse $ parse0 [] ts

-- Parsing most tokens is done by simply pushing the parsed equivalent
-- onto the result list (which doubles as an LR-token stack).

parse0 :: [CutParsed] -> [L.CutToken] -> [CutParsed]
parse0 ps [] = ps
parse0 ps ((L.Test n):ts) = parse0 ((Test n):ps) ts
parse0 ps ((L.Bringup n):ts) = parse0 ((Bringup n []):ps) ts
parse0 ps ((L.Setup n):ts) = parse0 ((Setup n []):ps) ts

-- __CUT_TAKEDOWN__ tokens, however, require nesting to be dealt with,
-- since it closes out an open context.  Attaching the child nodes to
-- the appropriate parent is handled with the attach function.

parse0 ps ((L.Takedown n):ts) = parse0 (attach n ((Takedown n):ps)) ts

attach :: S.ByteString -> [CutParsed] -> [CutParsed]
attach name nodes = case nonchildren of
                     (Bringup n _):ns -> (Bringup n children):ns
                     (Setup n _):ns   -> (Setup n children):ns
                     []               -> [errorMsg]
                     _:ns             -> errorMsg:ns

  where parent          = head nonchildren
        children        = reverse $ left name nodes
        nonchildren     = right name nodes
        left name nodes = takeWhile (\n -> case n of
                                            (Bringup m _) | m == name -> False
                                            (Setup m _) | m == name   -> False
                                            _                         -> True) nodes
        right name nodes = drop (length children) nodes
        errorMsg         = Error $ S.pack "Takedown without matching Setup or Bringup"

-- Sometimes, we will need to reconstruct the identifier that generated a
-- given node.

idOf :: CutParsed -> S.ByteString

idOf (Test t)       = L.testIdFor t
idOf (Takedown t)   = L.takedownIdFor t
idOf (Bringup t _)  = L.bringupIdFor t
idOf (Setup t _)    = L.setupIdFor t

