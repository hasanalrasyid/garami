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
  -- i : String : namafile yang sudah tanpa .nwi
  -- t : String : random string yang jadi penanda folder
  -- p : String : isi file g09 yang perlu disesuaikan
  susunNW  j i t p = 
    unlines [
      "memory total 500 mb", 
      "scratch_dir /state/partition1/tmp/nwchem/" ++ t  ++ "/", 
      unlines ( map gantiVar (lines p) )]
    where gantiVar x =
            if ( ( x =~ "memory " ) || (x =~ "scratch_dir ") ) then ""
            else x
  
  -- j: Antrian : jenis antrian
  -- i: String: namafile yang sudah tanpa nwi 
  -- t: String: random yang jadi penanda folder scratc
  susunNWsge j i t =
    unlines [ 
      "#!/bin/bash", 
      "### Change to the current working directory:" ,
      "#$ -cwd" ,
      "### Job name:" ,
      "#$ -V -N " ++ i ,
      "#$ -pe mpich " ++ (nProc j) ,
      "DAFTAR=$(hostname)",
      "export LD_LIBRARY_PATH=/opt/mpich2/gnu/lib:$LD_LIBRARY_PATH",
      "export NWCHEM_TOP=/share/apps/nwchem-6.3",
      "export NWCHEM_BASIS_LIBRARY=/share/apps/nwchem-6.3/src/basis/libraries/",
      "rm -rf /state/partition1/tmp/nwchem/" ++ t  ++ "/", 
      "mkdir -p /state/partition1/tmp/nwchem/" ++ t  ++ "/", 
      "MY_HOST=$(hostname)" ,
      "MY_DATE=$(date)" ,
      "echo \"Menjalankan NwChem di $MY_HOST pada $MY_DATE\"" ,
      "/opt/mpich2/gnu/bin/mpirun -np " ++ (nProc j) ++ " -host $DAFTAR /share/apps/nwchem-6.3/bin/LINUX64/nwchem " ++ t ++ ".grm.in  &> " ++ i ++ ".log",
      "tar -cjf " ++ i ++ ".scratch.tbz /state/partition1/tmp/nwchem/" ++ t
    ]
