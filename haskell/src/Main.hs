import System.Environment (getArgs,getEnv)
import Text.Regex.Posix -- untuk =~
import System.Process (system,runProcess,readProcess)
import System.Exit (exitWith,ExitCode(..))
import Control.Monad.Random (evalRandIO,getRandomR)
import Data.Char (chr)
import Data.List (intercalate)
import Data.List.Split (splitOn)
import GaramiData
import GaramiG09
import GaramiNW
import GaramiFF8
import GaramiCustom
import GaramiRebound
import GaramiNAMD 
import GaramiQE 
import GaramiSIESTA
import System.Directory (doesFileExist)
--  membaca inputFile sebagai variabel input 
--  lalu menuliskan hasil (jenisAntrian input) ke dalam namaFile.in
--  lalu menyusun jobscript .sge (jobscript jenisAntrian input)
--
interactWith :: String -> String -> IO () 
interactWith jenisAntrian inputFile = do
    tempFile <- susunRandom
    let hasilsge = (aplikasisge antrian namaFile tempFile)
    writeFile (tempFile ++ ".sge")  hasilsge -- menyusun File.sge
    case inputFile of 
      "custom" -> do
                  putStrLn "Custom Apps, maka tidak ada file yang disusun"
                  return ()
      _ -> do
           input <- readFile inputFile   -- baca inputFile as variabel input
           let hasilAplikasi' = (aplikasi antrian namaFile tempFile input)  -- menyusun File.in
           cekChk <- doesFileExist $ namaFile ++ ".chk"
           let hasilAplikasi = if cekChk 
                                 then unlines ["%OldChk=" ++ namaFile ++ ".chk",hasilAplikasi']
                                 else hasilAplikasi'
           writeFile (tempFile ++ ".grm.in") hasilAplikasi   -- menyusun File.in
    -- ? run jobscript.sge masuk antrian dengan sge
--    ExitStatus <- runProcess "echo + > kadalijo" [] []
    where namaFile = intercalate "." (init (splitOn "." inputFile ))
          antrian = case jenisAntrian of
                      "gatotkaca" -> gatotkaca
                      "antasena" -> antasena
                      "antareja" -> antareja
                      "srenggini" -> srenggini
                      "priv1" -> priv1
                      _ -> gatotkaca
          aplikasisge = case (last (splitOn "." inputFile)) of
                       "g09" -> susunG09sge
                       "nwi" -> susunNWsge
                       "ff8" -> susunFF8sge
                       "rbo" -> susunReboundsge
                       "namd" -> susunNAMDsge
                       "siesta" -> susunSIESTAsge
                       "qe" -> susunQEsge
                       _ -> susunCustomsge
          aplikasi = case (last (splitOn "." inputFile)) of
                       "g09" -> susunG09
                       "nwi" -> susunNW
                       "ff8" -> susunFF8
                       "qe" -> susunQE
                       _ -> susunCustom

susunRandom = do
    values <- evalRandIO (sequence (replicate 10 (getRandomR (97,122))))
    return $ map chr values


fallOverAndDie :: String -> IO a
fallOverAndDie err = do putStrLn err
                        exitWith (ExitFailure 1)

-- ini main function jangan diulik
-- ?lalu ngerun outputfile masuk antrian (dengan qsub yang sesuai dengan jenis antrian)
main = do 
          putStrLn "Ganesha Advanced Resource Management Interface (GARAMI) 2.0.0"
          putStrLn "============================================================="
          putStrLn ""
--          putStrLn fungsiHelp 
          args <- getArgs
          case args of
            ["list"] -> do
              system ("qstat -f -u '*' " ) 
              return ()
            ["list", antrian ] -> do
              system ("qstat -f -u '*' " ++  "-q " ++ antrian ++ ".q") 
              return ()
            [antrian,input] -> do 
              putStrLn "Penyusunan Jobscript"
              system "rm -f *.grm.in"
              system "rm -f *.sge"
              fKerja <- fmap init $ readProcess "pwd" [] []
              putStrLn $ "folder kerja adalah " ++ fKerja
              fHome <- getEnv "HOME"
              if (((=~) fKerja $ fHome ++ "$" ):: Bool) then fallOverAndDie $ 
                unlines [ "Anda harus bekerja dalam folder dibawah ~ (HOME), misalnya: " ++ fHome ++ "/kerja1"
                        ,"Cek folder tempat anda kerja saat ini dengan perintah"
                        ," pwd"
                        ," ---Selamat Berkarya" ]
                                                        else return ()
              system "chmod -fR g+rwx `pwd`"
              case (last (splitOn "." input)) of
                "ff8" -> do
                  interactWith antrian input
                  putStrLn ("Pengiriman kerja Firefly 8.0.1 ke dalam sistem antrian " ++ antrian)
                  system ("qsub -q " ++ antrian ++ ".q *.sge")
                  return ()
                "g09" -> do
                  interactWith antrian input
                  putStrLn ("Pengiriman kerja Gaussian09 ke dalam sistem antrian " ++ antrian)
                  system ("qsub -q " ++ antrian ++ ".q *.sge")
                  return ()
                "qe" -> do
                  interactWith antrian input
                  putStrLn ("Pengiriman kerja Quantum Espresso ke dalam sistem antrian " ++ antrian)
                  system ("qsub -q " ++ antrian ++ ".q *.sge")
                  return ()
                "nwi" -> do
                  interactWith antrian input
                  putStrLn ("Pengiriman kerja NwChem 6.3 ke dalam sistem antrian " ++ antrian)
                  system ("qsub -q " ++ antrian ++ ".q *.sge")
                  return ()
                "rbo" -> do
                  system ("touch " ++ input)
                  interactWith antrian input
                  putStrLn ("Pengiriman kerja Rebound ke dalam sistem antrian " ++ antrian)
                  system ("qsub -q " ++ antrian ++ ".q *.sge")
                  return ()
                "namd" -> do
                  system ("touch " ++ input)
                  interactWith antrian input
                  putStrLn ("Pengiriman kerja NAMD ke dalam sistem antrian " ++ antrian)
                  system ("qsub -q " ++ antrian ++ ".q *.sge")
                  return ()
                "siesta" -> do
                  system ("touch " ++ input)
                  interactWith antrian input
                  putStrLn ("Pengiriman kerja SIESTA ke dalam sistem antrian " ++ antrian)
                  system ("qsub -q " ++ antrian ++ ".q *.sge")
                  return ()
                "custom" -> do
                  interactWith antrian input
                  putStrLn ("Pengiriman kerja Custom Apps ke dalam sistem antrian " ++ antrian)
                  system ("qsub -q " ++ antrian ++ ".q *.sge")
                  return ()
                _ -> do
                  putStrLn "File input tidak dikenal"
                  return ()
            _ -> do
              putStrLn fungsiHelp

