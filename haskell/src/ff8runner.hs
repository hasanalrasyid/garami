import System.Environment (getArgs)
import System.Process (system,runProcess)
import System.Cmd
import System.Posix.User
import System.Posix.Process
import System.Environment
import Data.List.Split (splitOn)
-- ini main function jangan diulik
-- ?lalu ngerun outputfile masuk antrian (dengan qsub yang sesuai dengan jenis antrian)
main = do 
          putStrLn "Running Firefly 8.0.1"
          putStrLn "============================================================="
          putStrLn ""
          args <- getArgs
          case args of
            [namainput,np,temp] -> do
              totalEnv <- getEnvironment
              setUserID 519 -- userid ff8 adalah 519
              executeFile "mpirun" False ( splitOn " " ("-np " ++ np ++ " /share/apps/ff801/firefly801 -r -f -p -stdext -prealloc:50 -i " ++ temp ++ ".grm.in -o " ++ namainput ++ " -ex /share/apps/ff801 -t /state/partition1/tmp/ff8/" ++ temp )) (lingkungan totalEnv temp)
              return ()
            _ -> do
              putStrLn "FF8 run error, insufficient arguments from Garami" 
       where lingkungan t k = Just t  
--                                 ("GAUSS_EXEDIR","$gr/g09/bsd:$gr/g09/local:$gr/g09/extras:$gr/g09"),
--                                 ("GAUSS_LEXEDIR","$gr/g09/linda-exe"),
--                                 ("GAUSS_ARCHDIR","$gr/g09/arch"),
--                                 ("GAUSS_BSDDIR","$gr/g09/bsd"),
--                                 ("GV_DIR","$gr/gv"),
--                                 ("PATH","$GAUSS_EXEDIR:$PATH"),
--                                 ("_DSM_BARRIER","SHM"),
--                                 ("LD_LIBRARY64_PATH","$GAUSS_EXEDIR:$GV_DIR/lib:$LD_LIBRARY64_PATH"),
--                                 ("G09BASIS","$gr/g09/basis"),
--                                 ("PGI_TERM","trace,abort"),
--                                 ("",""),
--                                 ("",""),
--                                 ("",""),
--                                 ("",""),
--                               ]

