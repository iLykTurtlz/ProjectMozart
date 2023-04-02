module IOMenu where

import Control.Concurrent
import Control.Monad.State.Strict
import Sound.PortMidi
import Midi
import StateConfig
import MusicLib
import Text.Read 
import DataBase

--À COMPLÉTER

--Fonction menu, avec un paramètre de type GameConfig, fonction qui affiche un menu, et selon le choix,
--fait l'action souhaitée.
--On a besoin d'une configuration pour lancer un menu, au premier appel, ce sera la configuration de base.
menu :: GameConfig -> IO()          
menu config = do
  putStrLn "\n~Que voulez vous faire ?\n"
  putStrLn " 0 : Quitter\n 1 : Jouer un Menuet\n 2 : Changer la configuration\n"
  c <- getChar
  case c of
    '0' -> putStrLn "\n~Au revoir\n"
    '1' -> do
        putStrLn "\n~On joue le menuet\n"
        jouer config
        menu config
    '2' -> do
        newConfig <- menuConfig config
        menu newConfig
    _   -> do
      putStrLn "\n~Mauvaise commande !\n"
      menu config
  terminate
  return()

--Fonction menuConfig, avec un paramètre de type GameConfig, 
--fonction qui affiche les choix et fait les changements de configuration correspondant, et retourne la nouvelle configuration
menuConfig :: GameConfig -> IO GameConfig
menuConfig config = do
  putStrLn "\n\t~Quel changement de configuration apporter ?"
  putStrLn "\t0 : Aucun\n\t1 : Changer d'instrument\n\t2 : Mode de transposition\n\t3 : Mode mirroir ?\n\t4 : Multiplier la durée du menuet\n\t5 : Changer l'appareil de Sortie\n"
  c <- getChar
  case c of 
    '0' -> do 
        putStrLn "\n\t~À plus !\n"
        return config
    --------
    '1' -> do
        putStrLn "\n\t\t~Changement d'instrument"
        putStrLn "\t\t~Entrez un nombre entre 1 et 5"
        i <- (validateBoundedIntegralInput 1 5)
        let newConfig = execState (changeInstr i) config in 
            menuConfig newConfig
    ---------
    '2' -> do
        putStrLn "\n\t\t~Transposition"
        putStrLn "\t\t\t0 : pas de transposition\n\t\t\t1 : transposition de +12 demis tons\n\t\t\t2 : transpositon de -12 demis tons\n\t\t\t3 : transposition libre)"
        t <- getChar
        case t of
            '0' -> do
                let newConfig = execState (changeMode 0) config in
                    menuConfig newConfig
          ---------
            '1' -> do
                let newConfig = execState (changeMode 1) config in
                    menuConfig newConfig
          ---------
            '2' -> do
                let newConfig = execState (changeMode 2) config in
                    menuConfig newConfig
          ---------
            '3' -> do
                putStrLn "\n\t\t\t~De combien de demis tons transposer ?"
                nb <- validateIntegralInput
                let newConfigTons = execState (changeTranspoLibre nb) config in
                  let newConfig = execState (changeMode 3) newConfigTons in 
                    menuConfig newConfig
          ---------
            _ -> do 
                putStrLn "\n\t\t~Mauvaise Commande\n"
                menuConfig config
    ---------
    '3' -> do
        putStrLn "\n\t\t~Mode Miroir"
        putStrLn "\t\ty/n ?"
        m <- getChar
        case m of 
            'y'->do
                putStrLn "\t\t\tÀ partir de quelle hauteur de note souhaitez vous faire ce miroir\n\t\t\t*Attenttion : si la hauteur est trop faible ou trop élevée, vous risque de ne pas entendre toutes les notes...\n\t\t\t*Rappel : 60 est la hauteur du \"do du milieu\" sur un piano :)"
                h <- validateIntegralInput 
                let newConfigH = execState (changeHMirror h) config in 
                  let newConfig = execState (changeMirror True) newConfigH in
                      menuConfig newConfig
          ---------
            'n'->do
                let newConfig = execState (changeMirror False) config in
                    menuConfig newConfig
          ---------
            _ -> do
              putStrLn "\n\t\t~Mauvaise Commande!\n"
              menuConfig config
    ---------
    '4' -> do
        putStrLn "\n\t\t~Multiplier la durée"
        putStrLn "\t\tEntrez un nombre flottant positif pour multiplier la durée du menuet"
        d <- validateBoundedFloatInput 0
        let newConfig = execState (changeF d) config in
            menuConfig newConfig
    ---------
    '5' -> do
        putStrLn "\n\t\t~Changer l'appareil de sortie"
        putStrLn "\t\t~Entrez le numéro de l'appareil de sortie souhaité parmi ceux disponibles :\n"
        n <- countDevices
        midiDevicePrint (n-1)
        putStrLn "\n"
        device <- validateBoundedIntegralInput (0) (n-1) 
        let newConfig = execState (changeDevice device) config in
            menuConfig newConfig
    ---------
    _ -> do 
        putStrLn "\n\t\t~Mauvaise Commande!\n"
        menuConfig config
    

--Fonction MidiDevicePrint
midiDevicePrint :: Int -> IO ()
midiDevicePrint 0 = do 
  putStrLn "\nAppareil n°0"
  getDeviceInfo 0 >>= print
midiDevicePrint n = do
  putStrLn ("\nAppareil n°" ++ (show n))
  getDeviceInfo n >>= print
  midiDevicePrint (n - 1)


--Fonction jouerMenuet, avec la configuration en paramètres, ouvre le stream bon, 
--met le bon instrument, appelle perform measure, puis ferme le stream.
jouer::GameConfig->IO ()
jouer config = do
  putStrLn (show config)      --À supprimer quand on aura fini
  initialize
  result <- openOutput (device config) 1
  case result of
    Left err -> putStrLn "Erreur d'ouverture du stream"
    Right stream ->
      do
        (changeInstrument (toInteger (instrument config)) stream)
        performMeasure config stream 16
        close stream
        return ()
  terminate
  return ()


--Fonction récursive qui joue les mesures du menuet selon les transformations demandées par la config
--et sur le stream passé en paramètres
performMeasure::GameConfig->PMStream->Int->IO ()
performMeasure config stream 0 = return ()
performMeasure config stream i = do
  mesure <- chooseMeasure measures indices (17-i) 
  let mesureMir = if (mirror config) then (fmirror mesure (toInteger (hMirror config)))      
                  else mesure
    in 
      let mesureTranspose = case (mode config) of
                              0 -> mesureMir
                              1 -> (transposer mesureMir 12)
                              2 -> (transposer mesureMir (-12))
                              3 -> (transposer mesureMir (toInteger(transpoLibre config)))
                              _ -> mesureMir
        in 
          let mesureStretch = (stretch mesureTranspose (f config))
            in do 
              putStrLn ("\nOn joue la mesure " ++ (show mesureStretch))     --AFFICHAGE POUR TESTS 
              play mesureStretch stream
  performMeasure config stream (i-1)
    


--Fonctions de saisie d'informations depuis le terminal
validateIntegralInput::IO Int
validateIntegralInput = do
  input <- getLine
  case (readMaybe input::Maybe Int) of
    Just n -> return n
    Nothing -> putStrLn "Il faut saisir un entier" >> validateIntegralInput

validateBoundedIntegralInput::Int->Int->IO Int
validateBoundedIntegralInput borneInf borneSup = do
  input <- getLine
  case (readMaybe input::Maybe Int) of 
    Just n -> 
      if (n < borneInf) || (n > borneSup) then
        putStrLn ("Il faut que la valeur soit entre "++(show borneInf)++" et "++(show borneSup)) >> validateBoundedIntegralInput borneInf borneSup
      else
        return n
    Nothing -> putStrLn ("Il faut saisir un entier entre "++(show borneInf)++" et "++(show borneSup)) >> validateBoundedIntegralInput borneInf borneSup

validateFloatInput::IO Float
validateFloatInput = do
  input <- getLine
  case (readMaybe input::Maybe Float) of
    Just n -> return n
    Nothing -> do
      putStrLn "Il faut saisir un Float"
      validateFloatInput

validateBoundedFloatInput::Float->IO Float
validateBoundedFloatInput borneInf = do
  input <- getLine
  case (readMaybe input::Maybe Float) of 
    Just n -> 
      if (n <= borneInf)  then
        putStrLn ("Il faut que la valeur soit supérieure à " ++ (show borneInf)) >> validateBoundedFloatInput borneInf
      else
        return n
    Nothing -> putStrLn ("Il faut que la valeur soit un flottant supérieur à " ++ (show borneInf))  >> validateBoundedFloatInput borneInf

