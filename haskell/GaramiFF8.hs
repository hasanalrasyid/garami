module GaramiFF8 where  
  import System.Environment (getArgs)
  import Text.Regex.Posix -- untuk =~
  import System.Process (system,runProcess)
  import Control.Monad.Random (evalRandIO,getRandomR)
  import Data.Char (chr)
  import Data.Text (strip,pack,unpack)
  import Data.List (intercalate)
  import Data.List.Split (splitOn)
  import GaramiData

  -- j : Antrian : jenis antrian yang aktif, mis. gatotkaca
  -- i : String : namafile yang sudah tanpa .nwi
  -- t : String : random string yang jadi penanda folder
  -- p : String : isi file g09 yang perlu disesuaikan
  susunFF8  j i t p = 
      unlines ( map gantiVar (lines p) )
    where gantiVar x =
            if ( x =~ "\\$SYSTEM" ) then 
                                    if (( x =~ "MWORDS" )||( x =~ "MEMORY" )) then intercalate " " ( map gantiMem ( splitOn " "  k ))
                                                                              else ( ( intercalate " "  ( init ( splitOn " " k ))) ++ " MWORDS=50 $END"  )  
            else x
            where k = unpack (strip (pack x))  
                  gantiMem y = 
                    if (( y =~ "MWORDS" )||( y =~ "MEMORY" )) then "MWORDS=50"
                                                              else y

  
  -- j: Antrian : jenis antrian
  -- i: String: namafile yang sudah tanpa nwi 
  -- t: String: random yang jadi penanda folder scratc
  susunFF8sge j i t =
    unlines [ 
      "#!/bin/bash", 
      "### Change to the current working directory:" ,
      "#$ -cwd" ,
      "### Job name:" ,
      "#$ -V -N " ++ i ,
      "#$ -pe mpich " ++ (nProc j) ,
      "DAFTAR=$(hostname)",
      "export PATH=/share/apps/devel/rocks/32bit/opt/mpich2/gnu/bin:$PATH",
      "export LD_LIBRARY_PATH=/share/apps/devel/rocks/32bit/lib:/share/apps/devel/rocks/32bit/usr/lib:/share/apps/devel/rocks/32bit/opt/mpich2/gnu/lib:$LD_LIBRARY_PATH",
      "rm -rf /state/partition1/tmp/ff8/" ++ t  ++ "/", 
      "mkdir -p /state/partition1/tmp/ff8/" ++ t  ++ "/", 
      "MY_HOST=$(hostname)" ,
      "MY_DATE=$(date)" ,
      "echo \"Menjalankan Firefly 8.0.1 di $MY_HOST pada $MY_DATE\"" ,
      "mpirun -np " ++ (nProc j) ++ "/share/apps/ff801/firefly801 -r -f -p -stdext -prealloc:50 -i " ++ t ++ ".grm.in -o " ++ i ++ ".log -ex /share/apps/ff801 -t /state/partition1/tmp/ff8/" ++ t  ,
      "tar -cjf " ++ i ++ ".scratch.tbz /state/partition1/tmp/ff8/" ++ t
    ]
