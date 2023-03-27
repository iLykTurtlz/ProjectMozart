module Main where

import Control.Concurrent
import Sound.PortMidi
import Midi

midiDevicePrint :: Int -> IO ()
midiDevicePrint 0 = getDeviceInfo 0 >>= print
midiDevicePrint n = do
  getDeviceInfo n >>= print
  midiDevicePrint (n - 1)

main :: IO ()
main = do
  putStrLn "Le Jeu de Mozart "
  initialize
  n <- countDevices
  midiDevicePrint (n - 1)
  deviceId <- getDefaultOutputDeviceI
  case deviceId of
     Nothing   -> putStrLn "Pas de port Midi par default"
     Just n ->
      do
       result <- openOutput 0 1
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
