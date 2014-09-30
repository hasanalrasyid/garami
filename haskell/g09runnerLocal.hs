import System.Environment (getArgs)
import System.Process (system,readProcess)
--import System.Cmd
import System.Posix.User
import System.Posix.Process
import System.Environment
-- ini main function jangan diulik
-- ?lalu ngerun outputfile masuk antrian (dengan qsub yang sesuai dengan jenis antrian)
main = do 
          putStrLn "Ganesha Advanced Resource Management Interface (GARAMI) 2.0.0"
          putStrLn "=============================================================="
          putStrLn ""
          args <- getArgs
          case args of
            [namainput] -> do
              dir <- readProcess "pwd" [] ""
              kk <- readProcess "chmod" ["oug+rwx",init dir] ""
              totalEnv <- getEnvironment
              setUserID 504
              setEnv "g09root" "/share/apps"
              setEnv "gr" "/share/apps"
              setEnv "GAUSS_EXEDIR" "$gr/g09/bsd:$gr/g09/local:$gr/g09/extras:$gr/g09"
              k1 <- readProcess "source" ["$gr/g09.profile"] ""
              executeFile "/share/apps/g09/g09" False [(namainput ++ ".g09"),namainput ++ ".log"] (lingkungan totalEnv)
              return ()
            _ -> do
              putStrLn "G09 run error, insufficient arguments from Garami" 
       where lingkungan t = Just ( t ++ [ ( "g09root" , "/share/apps" )
                                   , ( "gr" , "/share/apps" )
--                                 ( "GAUSS_SCRDIR", "/state/partition1/tmp/g09/" ++ k )])
                                   , ("GAUSS_EXEDIR","$gr/g09/bsd:$gr/g09/local:$gr/g09/extras:$gr/g09")
                                   , ("GAUSS_LEXEDIR","$gr/g09/linda-exe")
                                   , ("GAUSS_ARCHDIR","$gr/g09/arch")
--                                 ("GAUSS_BSDDIR","$gr/g09/bsd"),
--                                 ("GV_DIR","$gr/gv"),
                                   , ("PATH","$GAUSS_EXEDIR:$PATH")
--                                 ("_DSM_BARRIER","SHM"),
                                   , ("LD_LIBRARY64_PATH","$GAUSS_EXEDIR:$GV_DIR/lib:$LD_LIBRARY64_PATH")
                                   , ("G09BASIS","$gr/g09/basis")
--                                 ("PGI_TERM","trace,abort"),
--                                 ("",""),
--                                 ("",""),
--                                 ("",""),
--                                 ("",""),
                                          ])

