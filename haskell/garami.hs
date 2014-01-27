import System.Environment (getArgs)
import Text.Regex.Posix -- untuk =~
import System.Process (system,runProcess)
import Control.Monad.Random (evalRandIO,getRandomR)
import Data.Char (chr)
import Data.List (intercalate)
import Data.List.Split (splitOn)
import GaramiData
import GaramiG09

--  membaca inputFile sebagai variabel input 
--  lalu menuliskan hasil (jenisAntrian input) ke dalam namaFile.in
--  lalu menyusun jobscript .sge (jobscript jenisAntrian input)
--
interactWith jenisAntrian inputFile = do
    input <- readFile inputFile   -- baca inputFile as variabel input
    tempFile <- susunRandom
    writeFile (tempFile ++ ".grm.in") (aplikasi antrian namaFile tempFile input)  -- menyusun File.in
    writeFile (tempFile ++ ".sge") (susunSGE antrian namaFile tempFile)  -- menyusun File.sge
    -- ? run jobscript.sge masuk antrian dengan sge
--    ExitStatus <- runProcess "echo + > kadalijo" [] []
    where namaFile = intercalate "." (init (splitOn "." inputFile ))
          antrian = case jenisAntrian of
                      "gatotkaca" -> gatotkaca
                      _ -> gatotkaca
          aplikasi = case (last (splitOn "." inputFile)) of
                       "g09" -> susunG09
                       _ -> susunG09

susunRandom = do
    values <- evalRandIO (sequence (replicate 10 (getRandomR (97,122))))
    return $ map chr values



-- ini main function jangan diulik
-- ?lalu ngerun outputfile masuk antrian (dengan qsub yang sesuai dengan jenis antrian)
main = do 
          putStrLn "Ganesha Advanced Resource Management Interface (GARAMI) 2.0.0"
          putStrLn "============================================================="
          putStrLn ""
          args <- getArgs
          case args of
            ["list"] -> do
              system "qstat -f -u '*'"
              return ()
            [antrian,input] -> do 
              putStrLn "Penyusunan Jobscript"
              system "rm -f *.grm.in"
              system "rm -f *.sge"
              system "chmod -R g+rwx `pwd`"
              interactWith antrian input
              putStrLn ("Pengiriman ke dalam sistem antrian " ++ antrian)
              system ("qsub " ++ antrian ++ " *.sge")
              return ()
            _ -> do
              putStrLn fungsiHelp

