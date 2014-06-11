module GaramiQE where  
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
  susunQE  j i t p = unlines ( map gantiVar (lines p) )
    where gantiVar x = if ( x =~ "&control" ) then 
                               unlines [ "&control",
                                       "   pseudo_dir = '/share/apps/espresso-5.0.99/pseudo/',",
                                       "   outdir='/state/partition1/tmp/qe/" ++ t ++ "/',"
                                       ] 
                                       else if (x =~ "outdir") then []
                                                               else if (x =~ "pseudo_dir") then []
                                                                                           else x   

-- j: Antrian : jenis antrian
-- i: String: namafile yang sudah tanpa g09
-- t: String: random yang jadi penanda folder scratc
  susunQEsge j i t = 
    unlines [ 
            "#!/bin/bash", 
            "### Change to the current working directory:" ,
            "#$ -cwd" ,
            "### Job name:" ,
            "#$ -V -N " ++ i ,
            "#$ -pe mpich " ++ (nProc j) ,
            "export LD_LIBRARY_PATH=/opt/mpich2/gnu/lib:$LD_LIBRARY_PATH",
            "export PATH=/opt/mpich2/gnu/bin:$PATH",
            "MY_HOST=$(hostname)" ,
            "MY_DATE=$(date)" ,
            "mkdir -p /state/partition1/tmp/qe/" ++ t ++ "/",
            "echo \"Menjalankan Quantum Espresso 5.0.99 di $MY_HOST pada $MY_DATE\"" ,
            "#mpirun -n " ++ (nProc j) ++ " /share/apps/espresso-5.0.99/bin/pw.x < " ++ i ++ ".pwi > " ++ i ++ ".out " ,
            "rm -f " ++ i ++ ".scratch.tbz", 
            "tar -cjf " ++ i ++ ".scratch.tbz /state/partition1/tmp/qe/" ++ t ,
            "rm -rf /state/partition1/tmp/qe/" ++ t ++ "/",
            ""
            ]
