import System.Environment (getArgs)
import Text.Regex.Posix -- untuk =~
import System.Process (system,runProcess)
import Control.Monad.Random (evalRandIO,getRandomR)
import Data.Char (chr)
import Data.List (intercalate)
import Data.List.Split (splitOn)

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

data Antrian =
      Antrian {
              nama :: String ,
              nProc :: String ,
              nMem :: String 
              }


gatotkaca = Antrian "gatotkaca" "12" "14" 

-- j : Antrian : jenis antrian yang aktif, mis. gatotkaca
-- i : String : namafile yang sudah tanpa .g09
-- t : String : random string yang jadi penanda folder
-- p : String : isi file g09 yang perlu disesuaikan
susunG09  j i t p = 
  "%NoSave \n" ++ 
  "%Chk=/state/partition1/tmp/g09/" ++ t  ++ "/" ++ i ++ ".chk\n" ++
  "%NProcShared=" ++ (nProc j ) ++ " \n" ++
  "%Mem=" ++ (nMem j) ++ " \n" ++ 
  unlines ( map gantiVar (lines p) ) 
  where gantiVar x = 
          if ( x =~ "%" ) then ""
                          else x

-- j: Antrian : jenis antrian
-- i: String: namafile yang sudah tanpa g09
-- t: String: random yang jadi penanda folder scratc
susunSGE j i t =
  "#!/bin/bash" ++ "\n" ++
  "### Change to the current working directory:" ++ "\n" ++
  "#$ -cwd" ++ "\n" ++
  "### Job name:" ++ "\n" ++
  "#$ -V -N " ++ i ++ "\n" ++
  "#$ -pe mpich " ++ (nProc j) ++ "\n" ++
  "export g09root=/share/apps" ++ "\n" ++
  "source $g09root/g09/bsd/g09.profile" ++ "\n" ++
  "export GAUSS_SCRDIR=/state/partition1/g09/" ++ t ++ "\n" ++
  "rm -rf $GAUSS_SCRDIR" ++ "\n" ++
  "mkdir -p $GAUSS_SCRDIR" ++ "\n" ++
  "MY_HOST=$(hostname)" ++ "\n" ++
  "MY_DATE=$(date)" ++ "\n" ++
  "echo \"Menjalankan gaussian di $MY_HOST pada $MY_DATE\"" ++ "\n" ++
  "g09 " ++ t ++ ".grm.in " ++ i ++ ".log" ++ "\n" ++
  "formchk -3 /state/partition1/tmp/g09/" ++ t ++ "/" ++ i ++ ".chk /state/partition1/tmp/g09/" ++ t ++ "/" ++ i ++ ".fchk" ++ "\n" ++
  "rm -f " ++ i ++ ".scratch.tbz" ++ "\n" ++
  "tar -cjf " ++ i ++ ".scratch.tbz /state/partition1/tmp/g09/" ++ t

-- ini main function jangan diulik
-- ?lalu ngerun outputfile masuk antrian (dengan qsub yang sesuai dengan jenis antrian)
main = do 
          putStrLn "Ganesha Advanced Resource Management Interface (GARAMI) 2.0.0"
          putStrLn "============================================================="
          putStrLn ""
          system "rm -f *.grm.in"
          system "rm -f *.sge"
          system "chmod -R g+rwx `pwd`"
          args <- getArgs
          case args of
            [antrian,input] -> do 
              putStrLn "Penyusunan Jobscript"
              interactWith antrian input
              putStrLn ("Pengiriman ke dalam sistem antrian " ++ antrian)
              system "qsub *.sge"
              return ()
            _ -> do
              putStrLn fungsiHelp

fungsiHelp = 
    "Jalankan program ini dengan perintah:" ++ "\n" ++
    "garami jenisAntrian inputfile" ++ "\n" ++
    "contoh:" ++ "\n" ++
    "garami gatotkaca filesaya.g09" ++ "\n" ++
    "GARAMI 2.0.0 \n" ++
    "Daftar Aplikasi : .g09\n" ++
    "Daftar Antrian : Gatotkaca \n"