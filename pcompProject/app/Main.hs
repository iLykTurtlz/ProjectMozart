module Main where

import Control.Concurrent
import Sound.PortMidi
import Midi
import MusicLib
import System.Random
import IOMenu
import StateConfig

--Le main initialise pour obtenir le deviceID par défaut, puis appelle le menu avec une première configuration,
--qui par défaut utilise l'instrument 1, ne transpose pas, ne fait pas le miroir, ne stretch pas et prend 
--l'appareil de sortie par défaut s'il y en a un (sinon il essaie avec 0, s'il n'y en a aucun l'erreur n'est 
--pas fatale pour le programme, un message s'affichera)
main :: IO ()
main = do
  putStrLn "Bienvenue dans le Jeu de Mozart "
  initialize
  deviceId <- getDefaultOutputDeviceID
  case deviceId of
    Just id ->  menu (GameConfig 1 0 False 1.0 id 0)      --On entre dans le menu du jeu avec un id par défaut
    Nothing -> menu (GameConfig 1 0 False 1.0 0 0)         --On entre dans le menu sans id par défaut
  return ()

randomNumber :: (Int, Int) ->  IO Int
randomNumber (inf, sup) = (+inf) . (`mod` (sup - inf)) <$> randomIO
  

