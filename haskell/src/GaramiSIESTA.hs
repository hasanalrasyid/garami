module GaramiSIESTA where  
  import System.Environment (getArgs)
  import Text.Regex.Posix -- untuk =~
  import System.Process (system,runProcess)
  import Control.Monad.Random (evalRandIO,getRandomR)
  import Data.Char (chr)
  import Data.List (intercalate)
  import Data.List.Split (splitOn)
  import GaramiData
  
  -- j: Antrian : jenis antrian
  -- i: String: namafile yang sudah tanpa .siesta
  -- t: String: random yang jadi penanda folder scratch, ingat bahwa SIESTA
  -- harus running di dalam folder scratch, tapi outputnya dilempar ke
  -- folder kerja asal.
  susunSIESTAsge j i t =
    unlines [ 
      "#!/bin/bash", 
      "### Change to the current working directory:" ,
      "#$ -cwd" ,
      "### Job name:" ,
      "#$ -V -N " ++ i ,
      "#$ -pe mpich " ++ (nProc j) ,
      "MYSELF=$(whoami)",
      "KERJADIR=$(pwd)",
      "SIESTA_SCRDIR=/state/partition1/tmp/siesta/${MYSELF}/" ++ t ,
      "MY_HOST=$(hostname)" ,
      "MY_DATE=$(date)" ,
      "echo \"Menjalankan SIESTA-3.2-pl-5 di $MY_HOST pada $MY_DATE\"" ,
      "mkdir -p $SIESTA_SCRDIR",
      "cp -r * $SIESTA_SCRDIR",
      "cd $SIESTA_SCRDIR",
      "/share/apps/siesta/siesta < " ++ i ++ ".siesta > ${KERJADIR}/" ++ i ++ ".log",
      "tar -cjf " ++ i ++ ".scratch.tbz *",
      "cp -f " ++ i ++ ".scratch.tbz ${KERJADIR}",
      "cd $KERJADIR",
      "rm -rf $SIESTA_SCRDIR"
    ]
