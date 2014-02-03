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
  susunNW  j i t p = 
    unlines [
      "%NoSave ",  
      "%Chk=/state/partition1/tmp/g09/" ++ t  ++ "/" ++ i ++ ".chk" ,
      "%NProcShared=" ++ (nProc j ) ,
      "%Mem=" ++ (nMem j) ,
      unlines ( map gantiVar (lines p) )]
    where gantiVar x = 
            if ( x =~ "%" ) then ""
                            else x
  
  -- j: Antrian : jenis antrian
  -- i: String: namafile yang sudah tanpa g09
  -- t: String: random yang jadi penanda folder scratc
  susunNWsge j i t =
    unlines [ 
      "#!/bin/bash", 
      "### Change to the current working directory:" ,
      "#$ -cwd" ,
      "### Job name:" ,
      "#$ -V -N " ++ i ,
      "#$ -pe mpich " ++ (nProc j) ,
      "export g09root=/share/apps" ,
      "source $g09root/g09/bsd/g09.profile",
      "export GAUSS_SCRDIR=/state/partition1/tmp/g09/" ++ t ,
      "rm -rf $GAUSS_SCRDIR" ,
      "mkdir -p $GAUSS_SCRDIR", 
      "MY_HOST=$(hostname)" ,
      "MY_DATE=$(date)" ,
      "echo \"Menjalankan gaussian di $MY_HOST pada $MY_DATE\"" ,
      "g09 " ++ t ++ ".grm.in " ++ i ++ ".log" ,
      "formchk -3 /state/partition1/tmp/g09/" ++ t ++ "/" ++ i ++ ".chk /state/partition1/tmp/g09/" ++ t ++ "/" ++ i ++ ".fchk" ,
      "rm -f " ++ i ++ ".scratch.tbz" ,
      "tar -cjf " ++ i ++ ".scratch.tbz /state/partition1/tmp/g09/" ++ t
    ]
