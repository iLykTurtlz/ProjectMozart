module Main where

import Control.Concurrent
import Sound.PortMidi
import Midi
import MusicLib
import System.Random

midiDevicePrint :: Int -> IO ()
midiDevicePrint 0 = do 
  putStrLn "\nAppareil n°0"
  getDeviceInfo 0 >>= print
midiDevicePrint n = do
  putStrLn ("\nAppareil n°" ++ (show n))
  getDeviceInfo n >>= print
  midiDevicePrint (n - 1)

main :: IO ()
main = do
  putStrLn "Le Jeu de Mozart "
  initialize
  n <- countDevices
  midiDevicePrint (n-1)
  deviceId <- getDefaultOutputDeviceID
  case deviceId of
     Nothing   -> putStrLn "Pas de port Midi par default"
     Just n ->
      do
       result <- openOutput 2 1
       case result of
        Left err   -> return ()
        Right stream ->
         do
          sendMidiNote 60 1000 100 0 stream
          threadDelay (2000 * 1000)
          close stream
          return ()
  terminate
  return ()

randomNumber :: (Int, Int) ->  IO Int
randomNumber (inf, sup) = (+inf) . (`mod` (sup - inf)) <$> randomIO
  

testPlay::MusObj->IO ()
testPlay mObj = do
  initialize
  result <- openOutput 2 1
  case result of
    Left err -> return ()
    Right stream ->
      do
        play mObj stream
        close stream
        return ()
  terminate
  return ()