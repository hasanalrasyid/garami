import System.Environment (getArgs)
import System.Process (system,readProcess)
--import System.Cmd
import System.Posix.User
import System.Posix.Process
import System.Environment

import GaramiData
import GaramiG09
import Control.Monad.Random (evalRandIO,getRandomR)
import Data.Char (chr)

susunRandom = do
    values <- evalRandIO (sequence (replicate 10 (getRandomR (97,122))))
    return $ map chr values

ishmar = Antrian "ishmar" "12" "30GB" "719"
 
-- ini main function jangan diulik
-- ?lalu ngerun outputfile masuk antrian (dengan qsub yang sesuai dengan jenis antrian)
main = do 
          putStrLn "Ganesha Advanced Resource Management Interface (GARAMI) 2.0.0"
          putStrLn "=============================================================="
          putStrLn ""
          args <- getArgs
          tempFile <- susunRandom 
          case args of
            [namainput] -> do
              isiinput <- readFile (namainput ++ ".g09")
              writeFile (tempFile ++ ".grm.in") $ susunG09 ishmar namainput tempFile isiinput
              _ <- system $ "mkdir -p /state/partition1/tmp/g09/" ++ tempFile 
--              dir <- readProcess "pwd" [] ""
--              kk <- readProcess "chmod" ["oug+rwx",init dir] ""
--              setEnv "g09root" "/share/apps"
--              setEnv "gr" "/share/apps"
--              setEnv "GAUSS_EXEDIR" "$gr/g09/bsd:$gr/g09/local:$gr/g09/extras:$gr/g09"
--              k1 <- readProcess "/share/apps/g09.profile" [] ""
              totalEnv <- getEnvironment
              setUserID 504
              executeFile "/share/apps/g09/g09" False [(namainput ++ ".g09"),namainput ++ ".log"] (lingkungan totalEnv tempFile)
              return ()
            _ -> do
              putStrLn "G09 run error, insufficient arguments from Garami" 
       where lingkungan t k = Just ( t ++ [ ( "g09root" , "/share/apps" )
--                                   , ( "gr" , "/share/apps" )
                                     , ( "GAUSS_SCRDIR", "/state/partition1/tmp/g09/" ++ k )
--                                   , ("GAUSS_EXEDIR","$gr/g09/bsd:$gr/g09/local:$gr/g09/extras:$gr/g09")
--                                   , ("GAUSS_LEXEDIR","$gr/g09/linda-exe")
--                                   , ("GAUSS_ARCHDIR","$gr/g09/arch")
--                                 ("GAUSS_BSDDIR","$gr/g09/bsd"),
--                                 ("GV_DIR","$gr/gv"),
--                                   , ("PATH","$GAUSS_EXEDIR:$PATH")
--                                 ("_DSM_BARRIER","SHM"),
--                                   , ("LD_LIBRARY64_PATH","$GAUSS_EXEDIR:$GV_DIR/lib:$LD_LIBRARY64_PATH")
--                                   , ("LD_LIBRARY_PATH","$GAUSS_EXEDIR:$GV_DIR/lib:$LD_LIBRARY_PATH")
--                                   , ("G09BASIS","$gr/g09/basis")
--                                 ("PGI_TERM","trace,abort"),
--                                 ("",""),
--                                 ("",""),
--                                 ("",""),
--                                 ("",""),
                                          ])

