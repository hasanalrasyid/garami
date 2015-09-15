-- file: garami.hs
--myDrop n xs = 
--  if n <= 0 || null xs
--    then xs
--    else myDrop (n - 1) (tail xs)

-- bentuk baru
--myDrop :: Int -> [a] -> [a]
myDrop n xs 
  | n <= 0 = xs 
  | xs ==[] = xs
--myDrop   _ [] = [] 
myDrop n (_:xs) = myDrop (n - 1) xs

data BookInfo = 
  Book Int String [String]
  deriving (Show)
  
data MagazineInfo = 
  Magazine Int String [String]
  deriving (Show)

data BookReview = 
  BookReview BookInfo CustomerID String

data BetterReview = 
  BetterReview BookInfo CustomerID ReviewBody
  deriving (Show)

type CustomerID = Int
type ReviewBody = String
type BookRecord = (BookInfo,BetterReview)
  
myInfo = Book 203123 "Aku" ["Chairil Anwar","teman-temannya"]
myReview = BetterReview myInfo 14 "Bagus sekali"

bookTitle (Book id title authors) = title
bookTitle2 (Book a b c) = b


data Roygbiv =
  Red
  | Orange
  | Yellow
  | Green
  | Blue
  | Indigo
  | Violet
  deriving (Eq, Show)

myNot True = False --pertama
myNot False = True --kedua

x = False

sumList (x:parax) = x + sumList parax
--sumList [] = 0
sumList _ = 0 --lebih baik

data Pohon a = Node a (Pohon a) (Pohon a)
  | Empty
  deriving (Show)

pohonSederhana = Node "utama" (Node "kiri" Empty Empty) (Node "kanan" Empty Empty)

safeSecond :: [a] -> Maybe a
safeSecond [] = Nothing
safeSecond xs = if null (tail xs)
  then Nothing
  else Just (head (tail xs))

reserve = 3999
lend amount balance = 
  let 
    reserve = 100
    newBalance = balance - amount
  in 
    if balance < reserve
    then Nothing
    else Just newBalance

bar = let x = 1
  in ((let x = "foo" in x), x)

quux a = let a = "foo"
  in a ++ "eek!"

lend2 amount balance = 
    if balance < reserve
    then Nothing 
    else Just newBalance
  where
    reserve = 100
    newBalance = balance - amount
    
pluralise word counts = map plural counts
  where 
    plural 0 = "no " ++ word ++ "s"
    plural 1 = "one " ++ word
    plural n = show n ++ " " ++ word ++ "s"

data Fruit = Apple | Melon
  deriving (Show) 
apple = "apple"
melon = "melon"
whichFruit :: String -> Fruit
whichFruit f = 
  case f of
    "apple" -> Apple
    "melon" -> Melon
 
                              
