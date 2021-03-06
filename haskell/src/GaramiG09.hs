module GaramiG09 where  
  import System.Environment (getArgs)
  import Text.Regex.Posix -- untuk =~
  import System.Process (system,runProcess)
  import Control.Monad.Random (evalRandIO,getRandomR)
  import Data.Char (chr)
  import Data.List (intercalate)
  import Data.List.Split (splitOn)
  import GaramiData

  -- j : Antrian : jenis antrian yang aktif, mis. gatotkaca
  -- i : String : namafile yang sudah tanpa .g09
  -- t : String : random string yang jadi penanda folder
  -- p : String : isi file g09 yang perlu disesuaikan
  susunG09  j i t p = 
    unlines [
      "%NoSave ",  
      "%Chk=/state/partition1/tmp/g09/" ++ t  ++ "/" ++ i ++ ".chk" ,
      "%NProcShared=" ++ (nProc j ) ,
      "%Mem=" ++ (nMem j) ,
      unlines ( map gantiVar (lines p) )]
    where 
          gantiVar x = if (x =~ "%") 
                         then "" 
                         else x
  
  -- j: Antrian : jenis antrian
  -- i: String: namafile yang sudah tanpa g09
  -- t: String: random yang jadi penanda folder scratc
  susunG09sge j i t =
    unlines [ 
      "#!/bin/bash", 
      "### Change to the current working directory:" ,
      "#$ -cwd" ,
      "### Job name:" ,
      "#$ -V -N " ++ i ,
      "#$ -pe mpich " ++ (nProc j) ,
      "export g09root=/share/apps",
      "source $g09root/g09.profile",
      "export GAUSS_SCRDIR=/state/partition1/tmp/g09/" ++ t ,
      "rm -rf $GAUSS_SCRDIR" ,
      "mkdir -p $GAUSS_SCRDIR", 
      "chmod -R oug+rwx $GAUSS_SCRDIR", 
      "MY_HOST=$(hostname)" ,
      "MY_DATE=$(date)" ,
      "echo \"Menjalankan gaussian di $MY_HOST pada $MY_DATE\"" ,
      "/share/apps/g09runner " ++ i ++ " " ++ t  ,
      "rm -f " ++ i ++ ".scratch.zip" 
      , "zip -j " ++ i ++ ".scratch.zip /state/partition1/tmp/g09/" ++ t ++ "/*"
    ]
