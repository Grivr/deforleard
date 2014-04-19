module Main where

import System.Exit
import System.Environment
import System.Console.GetOpt
import Control.Monad.Error
import qualified Data.ByteString.Lazy as Bs
import Data.List
import Data.Word (Word8)
import Control.Arrow


type RleCode = (Int, Word8)

toTuples :: [Word8] -> [RleCode]
toTuples [] = []
toTuples (0xFF:byte:count:bytes)
  | count == 0 = [] --FFFF00 endOfSteam signature
  | otherwise  = (fromIntegral count, byte) : toTuples bytes
toTuples (byte: bytes) = (1, byte) : toTuples bytes

fromTuples :: [RleCode] -> [Word8]
fromTuples [] = []
fromTuples ((count, byte):tuples)
  | count > 0xFF = 0xFF:byte:0xFF: fromTuples ((count-0xFF, byte):tuples)-- length is FF at max, stored in byte
  | byte == 0xFF = 0xFF:byte:fromIntegral count: fromTuples tuples--FF byte coinse with RLE control code, do not emit as raw symbol
  | count < 3    = replicate count byte ++ fromTuples tuples--optimisation:  XX XX is shorter than FF XX 02 
  | otherwise    = 0xFF:byte:fromIntegral count: fromTuples tuples--emit RLE code


encodeRle:: [Word8] -> [RleCode]
encodeRle  = map (length &&& head).group

decodeRle :: [RleCode] -> [Word8]
decodeRle = concatMap (uncurry replicate)

----------------------------------------Command line parse part----------------------------------

data Action = Decode | Encode | NoAction deriving (Show, Eq)
data Options = Options
              {optHelp :: Bool
              ,optVersion :: Bool
              ,optAction :: Action
              }
              deriving (Show)
defaultOptions :: Options
defaultOptions = Options
                  {optHelp = False
                  ,optVersion = False
                  ,optAction = NoAction
                  }

usage :: String
usage = usageInfo "Usage: deforleard [-d | -e] file_name [offset]" options

options :: [OptDescr (Options -> Options)]
options =
	[ Option "d"     ["decode"]  (NoArg (\opts -> opts {optAction = Decode}))  "decode from ROM. -d <file_name offset>"
	, Option "e"     ["encode"]  (NoArg (\opts -> opts {optAction = Encode}))  "encode from raw binary. -e <file_name>"
        , Option "h?" ["help"]    (NoArg (\ opts -> opts { optHelp = True }))   "show help."
        , Option "v" ["version"]     (NoArg (\ opts -> opts { optVersion = True })) "show version number."
	]


deforOpts :: [String] -> IO (Options, [String])
deforOpts argv = 
  case getOpt Permute options argv of
    (o,n,[]  ) -> return (foldl (flip id) defaultOptions o, n)
    (_,_,errs) -> ioError (userError (concat errs ++ usage))

----------------------------------------------Main------------------------------------------------------

main :: IO()
main = do
  argv <- getArgs
  (opts, nonOpts) <- deforOpts argv
  when (optVersion opts) $ do
    putStrLn "Deforleard. NES Superman RLE utility. Version 0.1"
    exitSuccess
  when (optHelp opts) $ do
    putStrLn usage
    exitSuccess
  let action = optAction opts
  when (action == NoAction) $ do
    putStrLn "Supply action flag"
    putStrLn usage
    exitFailure 
  if action == Decode
    then do
      when (length nonOpts /= 2) $ do
        putStrLn "Supply exactly one file name and one offset for decoding"
        putStrLn usage
        exitFailure
      let [fileName, sOffset] = nonOpts
      input <- Bs.readFile fileName
      let inputU8 =  drop (read sOffset) $ Bs.unpack input
          decoded = decodeRle.toTuples $ inputU8
      Bs.writeFile "decoded.bin" (Bs.pack decoded)
    else do --encoding
      when (length nonOpts /= 1) $ do
        putStrLn "Supply exactly one file name for encoding"
        putStrLn usage
        exitFailure
      let [fileName] = nonOpts
      input <- Bs.readFile fileName
      let inputU8 = Bs.unpack input
          encoded = fromTuples.encodeRle $ inputU8  ++ [0xFF, 0xFF, 0]--append with endOfStream
      Bs.writeFile "encoded.bin" (Bs.pack encoded)
