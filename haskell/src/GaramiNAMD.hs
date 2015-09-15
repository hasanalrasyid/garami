module GaramiNAMD where  
  import System.Environment (getArgs)
  import Text.Regex.Posix -- untuk =~
  import System.Process (system,runProcess)
  import Control.Monad.Random (evalRandIO,getRandomR)
  import Data.Char (chr)
  import Data.List (intercalate)
  import Data.List.Split (splitOn)
  import GaramiData
  
  -- j: Antrian : jenis antrian
  -- i: String: namafile yang sudah tanpa .namd
  -- t: String: random yang jadi penanda folder scratch, ingat bahwa NAMD
  -- harus running di dalam folder scratch, tapi outputnya dilempar ke
  -- folder kerja asal.
  susunNAMDsge j i t =
    unlines [ 
      "#!/bin/bash", 
      "### Change to the current working directory:" ,
      "#$ -cwd" ,
      "### Job name:" ,
      "#$ -V -N " ++ i ,
      "#$ -pe mpich " ++ (nProc j) ,
      "MYSELF=$(whoami)",
      "KERJADIR=$(pwd)",
      "NAMD_SCRDIR=/state/partition1/tmp/namd/${MYSELF}/" ++ t ,
      "MY_HOST=$(hostname)" ,
      "MY_DATE=$(date)" ,
      "echo \"Menjalankan NAMD di $MY_HOST pada $MY_DATE\"" ,
      "mkdir -p $NAMD_SCRDIR",
      "cp -r * $NAMD_SCRDIR",
      "cd $NAMD_SCRDIR",
      "/share/apps/namd/namd2 +p" ++ (nProc j) ++ " " ++ i ++ ".namd > ${KERJADIR}/" ++ i ++ ".log",
      "tar -cjf " ++ i ++ ".scratch.tbz *",
      "cp " ++ i ++ ".scratch.tbz ${KERJADIR}",
      "cd $KERJADIR",
      "rm -rf $NAMD_SCRDIR"
    ]
