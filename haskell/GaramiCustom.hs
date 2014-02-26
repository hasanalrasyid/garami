module GaramiCustom where  
  import System.Environment (getArgs)
  import Text.Regex.Posix -- untuk =~
  import System.Process (system,runProcess)
  import Control.Monad.Random (evalRandIO,getRandomR)
  import Data.Char (chr)
  import Data.List (intercalate)
  import Data.List.Split (splitOn)
  import GaramiData
  
  susunCustom j i t p = ""
  -- j: Antrian : jenis antrian
  -- i: String: namafile yang sudah tanpa g09
  -- t: String: random yang jadi penanda folder scratc
  susunCustomsge j i t =
    unlines [ 
      "#!/bin/bash", 
      "### Change to the current working directory:" ,
      "#$ -cwd" ,
      "### Job name:" ,
      "#$ -V -N \"Custom Apps\" " ,
      "#$ -pe mpich " ++ (nProc j) ,
      "MY_HOST=$(hostname)" ,
      "MY_DATE=$(date)" ,
      "echo \"Menjalankan Custom Apps di $MY_HOST pada $MY_DATE\"" ,
      "sleep " ++ (nJam j) ++ "h " 
    ]
