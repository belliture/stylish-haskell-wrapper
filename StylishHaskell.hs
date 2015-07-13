module Main where

import System.Environment (getArgs)
import System.Exit        (ExitCode (..), exitWith)
import System.IO
import System.Process     (CreateProcess (..), StdStream (..), createProcess, proc, waitForProcess)

main :: IO ()
main = do
    args <- getArgs
    (_, Just oh, _, ph) <-  createProcess (proc "stack" $ ["exec", "stylish-haskell", "--"] ++ args){ std_out = CreatePipe }
    ec <- waitForProcess ph
    case ec of
        ExitSuccess -> do
            hSetNewlineMode oh $ NewlineMode nativeNewline LF
            hSetNewlineMode stdout noNewlineTranslation
            putStr =<< hGetContents oh
        _ -> exitWith ec
