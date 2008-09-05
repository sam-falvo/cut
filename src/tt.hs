module TestCutParser where
import CutLexer as L
import CutParser as P
import Data.ByteString.Char8 as S

main = do let z = [L.Bringup (S.pack "hello"), L.Test (S.pack "foo"), L.Test (S.pack "bar"), L.Setup (S.pack "world"), L.Test (S.pack "baz"), L.Test (S.pack "blort"), L.Takedown (S.pack "world"), L.Test (S.pack "wtf"), L.Takedown (S.pack "hello")]
          let y = P.parse z
          Prelude.putStrLn $ show y

