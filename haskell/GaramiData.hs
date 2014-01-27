module GaramiData where
  import System.Environment (getArgs)
  import Text.Regex.Posix -- untuk =~
  import System.Process (system,runProcess)
  import Control.Monad.Random (evalRandIO,getRandomR)
  import Data.Char (chr)
  import Data.List (intercalate)
  import Data.List.Split (splitOn)
  
  
  data Antrian =
        Antrian {
                nama :: String ,
                nProc :: String ,
                nMem :: String 
                }
  
  
  gatotkaca = Antrian "gatotkaca" "12" "14" 
  

  fungsiHelp = 
    "Jalankan program ini dengan perintah:" ++ "\n" ++
    "garami jenisAntrian inputfile" ++ "\n" ++
    "contoh:" ++ "\n" ++
    "garami gatotkaca filesaya.g09" ++ "\n" ++
    "GARAMI 2.0.0 \n" ++
    "Daftar Aplikasi : .g09\n" ++
    "Daftar Antrian : Gatotkaca \n"
