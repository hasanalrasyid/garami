import System.Environment (getArgs)
import System.Process (system,runProcess)

-- ini main function jangan diulik
-- ?lalu ngerun outputfile masuk antrian (dengan qsub yang sesuai dengan jenis antrian)
main = do 
          putStrLn "Ganesha Advanced Resource Management Interface (GARAMI) 2.0.0"
          putStrLn "============================================================="
          putStrLn ""
          args <- getArgs
          case args of
            [namainput,temp] -> do 
              system("export g09root=/share/apps;source $g09root/g09/bsd/g09.profile; export GAUSS_SCRDIR=/state/partition1/g09/" ++ temp ++ " ; g09 " ++ temp ++ ".grm.in " ++ namainput ++ ".log; formchk -3 /state/partition1/tmp/g09/" ++ temp ++ "/" ++ namainput ++ ".chk /state/partition1/tmp/g09/" ++ temp ++ "/" ++ namainput ++ ".fchk ") 
              return ()
            _ -> do
              putStrLn "G09 run error, insufficient arguments from Garami" 

