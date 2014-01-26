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
  
