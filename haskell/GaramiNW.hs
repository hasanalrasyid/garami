module GaramiNW where  
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
    "%NoSave \n" ++ 
    "%Chk=/state/partition1/tmp/g09/" ++ t  ++ "/" ++ i ++ ".chk\n" ++
    "%NProcShared=" ++ (nProc j ) ++ " \n" ++
    "%Mem=" ++ (nMem j) ++ " \n" ++ 
    unlines ( map gantiVar (lines p) ) 
    where gantiVar x = 
            if ( x =~ "%" ) then ""
                            else x
  
  -- j: Antrian : jenis antrian
  -- i: String: namafile yang sudah tanpa g09
  -- t: String: random yang jadi penanda folder scratc
  susunSGE j i t =
    "#!/bin/bash" ++ "\n" ++
    "### Change to the current working directory:" ++ "\n" ++
    "#$ -cwd" ++ "\n" ++
    "### Job name:" ++ "\n" ++
    "#$ -V -N " ++ i ++ "\n" ++
    "#$ -pe mpich " ++ (nProc j) ++ "\n" ++
      "export g09root=/share/apps" ++ "\n" ++
      "source $g09root/g09/bsd/g09.profile" ++ "\n" ++
      "export GAUSS_SCRDIR=/state/partition1/g09/" ++ t ++ "\n" ++
      "rm -rf $GAUSS_SCRDIR" ++ "\n" ++
      "mkdir -p $GAUSS_SCRDIR" ++ "\n" ++
      "MY_HOST=$(hostname)" ++ "\n" ++
      "MY_DATE=$(date)" ++ "\n" ++
      "echo \"Menjalankan gaussian di $MY_HOST pada $MY_DATE\"" ++ "\n" ++
      "g09 " ++ t ++ ".grm.in " ++ i ++ ".log" ++ "\n" ++
      "formchk -3 /state/partition1/tmp/g09/" ++ t ++ "/" ++ i ++ ".chk /state/partition1/tmp/g09/" ++ t ++ "/" ++ i ++ ".fchk" ++ "\n" ++
      "rm -f " ++ i ++ ".scratch.tbz" ++ "\n" ++
      "tar -cjf " ++ i ++ ".scratch.tbz /state/partition1/tmp/g09/" ++ t
