module Main where

import Control.Concurrent
import Sound.PortMidi
import Midi
import MusicLib

import IOMenu
import StateConfig


main :: IO ()
main = do
  putStrLn "~Bienvenue dans le Jeu de Mozart"
  initialize
  deviceId <- getDefaultOutputDeviceID
  case deviceId of
    Just id ->  menu (GameConfig 1 0 False 1.0 id 0 60)      --On entre dans le menu du jeu avec un id par défaut
    Nothing -> menu (GameConfig 1 0 False 1.0 0 0 60)         --On entre dans le menu sans id par défaut
  return ()

