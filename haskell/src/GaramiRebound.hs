module GaramiRebound where  
  import System.Environment (getArgs)
  import Text.Regex.Posix -- untuk =~
  import System.Process (system,runProcess)
  import Control.Monad.Random (evalRandIO,getRandomR)
  import Data.Char (chr)
  import Data.List (intercalate)
  import Data.List.Split (splitOn)
  import GaramiData

  -- j: Antrian : jenis antrian
  -- i: String: namafile yang sudah tanpa g09
  -- t: String: random yang jadi penanda folder scratc
  susunReboundsge j i t =
    unlines [ 
      "#!/bin/bash", 
      "### Change to the current working directory:" ,
      "#$ -cwd" ,
      "### Job name:" ,
      "#$ -V -N " ++ i ,
      "#$ -pe mpich " ++ (nProc j) ,
      "export OMP_NUM_THREADS=" ++ (nProc j),
      "MY_HOST=$(hostname)" ,
      "MY_DATE=$(date)" ,
      "echo \"Menjalankan Rebound di $MY_HOST pada $MY_DATE\"" ,
      "/home/itbsks212ridlo/rebound-master/kerja/nbody " 
      --"rm -f " ++ i ++ ".scratch.tbz" 
      -- , "tar -cjf " ++ i ++ ".scratch.tbz /state/partition1/tmp/g09/" ++ t
    ]
