module Main where

import Control.Concurrent
import Sound.PortMidi
import Midi
import MusicLib
import System.Random
import IOMenu
import StateConfig


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
  

chooseMeasure::[MusObj]->Int->MusObj
chooseMeasure database measureNumber = do
  --measureNumber dans [1,16]
  --dans les "let..in" on transforme les variables ludiques en variables informatiques
  alea <- randomNumber (2,12)
  let row = if measureNumber > 8 then alea-2+11 else alea-2 in
    let column = (measureNumber-1) `mod` 8 in
      let index = row * 8 + column in
        database!!index
