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
  
  
  gatotkaca = Antrian "gatotkaca" "24" "12GB" 
  antasena = Antrian "antasena" "12" "6GB" 
  antareja = Antrian "antareja" "6" "3GB" 
  srenggini = Antrian "srenggini" "4" "2GB" 
  
  k1d3 (x,_,_) = x
  k2d3 (_,x,_) = x
  k3d3 (_,_,x) = x

  fungsiHelp = 
    unlines [ 
      "Jalankan program ini dengan perintah:", 
      "garami jenisAntrian inputfile" ,
      "contoh:" ,
      "garami gatotkaca filesaya.g09", 
      "GARAMI 2.0.0" ,
      "Daftar Aplikasi : .g09",
      "Daftar Antrian : gatotkaca antasena antareja srenggini"
    ]
