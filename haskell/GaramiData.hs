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
                nMem :: String , 
                nJam :: String 
                }
  
  
  gatotkaca = Antrian "gatotkaca" "24" "12GB" "719" 
  antasena = Antrian "antasena" "12" "7GB" "167"
  antareja = Antrian "antareja" "6" "3GB" "23"
  srenggini = Antrian "srenggini" "4" "2GB" "4"
  
  k1d3 (x,_,_) = x
  k2d3 (_,x,_) = x
  k3d3 (_,_,x) = x

  fungsiHelp = 
    unlines [ 
      "Jalankan program ini dengan perintah:", 
      "   garami jenisAntrian inputfile" ,
      "contoh:" ,
      "   garami gatotkaca filesaya.g09", 
      "\nDaftar Aplikasi  ",
      "   Gaussian09                : .g09",
      "   NwChem 6.3                : .nwi",
      "   Firefly 8.0.1             : .ff8",
      "   Rebound                   : .rbo (khusus user tertentu)",
      "   NAMD 2014-06-02           : .namd ",
      "   Quantum Espresso 5.0.99   : .qe",
      "\nDaftar Antrian : ",
      "   nama  gatotkaca antasena antareja srenggini",
      "   core      24      12        6         4",
      "   mem       12G     6G        3G        2G",
      "   limit     1mo     1w        1d        4h"
    ]
