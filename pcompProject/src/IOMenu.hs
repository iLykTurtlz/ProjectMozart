module IOMenu where

import Control.Concurrent
import Control.Monad.State.Strict
import Sound.PortMidi
import Midi
import StateConfig
import Text.Read 

--À COMPLÉTER

--Fonction menu, avec un paramètre de type GameConfig, fonction qui affiche un menu, et selon le choix,
--fait l'action souhaitée.
--On a besoin d'une configuration pour lancer un menu, au premier appel, ce sera la configuration de base.
menu :: GameConfig -> IO()          
menu config = do
  putStrLn "Bienvenue dans ~Le Jeu de Mozart~\nQue voulez vous faire ?\n"
  putStrLn " 0 : Quitter\n 1 : Jouer un Menuet\n 2 : Changer la configuration\n"
  c <- getChar
  case c of
    '0' -> putStrLn "\n~Au revoir\n"
    '1' -> do
        putStrLn "\nOn joue\n"
        menu config
    '2' -> do
        newConfig <- menuConfig config
        menu newConfig
    _   -> do
      putStrLn "\nMauvaise commande\n"
      menu config
  terminate
  return()

--Fonction menuConfig, avec un paramètre de type GameConfig, 
--fonction qui affiche les choix et fait les changements de configuration correspondant, et retourne la nouvelle configuration
menuConfig :: GameConfig -> IO GameConfig
menuConfig config = do
  putStrLn "\tQuel changement de configuration apporter ?\n"
  putStrLn "\t 0 : Aucun\n\t 1 : Changer d'instrument\n\t 2 : Mode de transposition\n\t 3 : Mode mirroir ?\n\t 4 : Multiplier la durée du menuet\n\t 5 : Changer l'appareil de Sortie\n\n"
  --Traiter les différents cas en faisant appel aux fonctions de StateConfig
  --Si 1,2,3,4,5 en entrée, on fait un appel récursif à GameConfig avec la nouvelle 
  --configuration récupérée, sinon, on la retourne juste.
  c <- getChar
  case c of 
    '0' -> do 
        putStrLn "\n\t~À plus !\n"
        putStrLn "\nConfig à la fin de menuConfig\n"
        putStrLn (show config)
        putStrLn "\n"
        return config
    --------
    '1' -> do
        putStrLn "\n\t\tChangement d'instrument"
        putStrLn "\n\t\tEntrez un nombre entre 1 et 5\n"
        i <- (validateBoundedIntegralInput 1 5)
        let newConfig = execState (changeInstr i) config in 
            menuConfig newConfig
    ---------
    '2' -> do
        putStrLn "\n\t\tTransposition"
        putStrLn "\n\t\tEntrer un mode de transposition \n(0 : pas de transposition, 1: transposition de +12 demis tons, 2 : transpositon de -12 demis tons, 3 : transposition libre)\n"
        t <- getChar
        case t of
            '0' -> do
                let newConfig = execState (changeMode 0) config in
                    menuConfig newConfig
            '1' -> do
                let newConfig = execState (changeMode 1) config in
                    menuConfig newConfig
            '2' -> do
                let newConfig = execState (changeMode 2) config in
                    menuConfig newConfig
            '3' -> do
                putStrLn "En travaux"
                menuConfig config
            _ -> do 
                putStrLn "\n\t\tMauvaise Commande\n"
                menuConfig config
    ---------
    '3' -> do
        putStrLn "\n\t\tMode Miroir"
        putStrLn "\n\t\ty/n ?"
        m <- getChar
        case m of 
            'y'->do
                let newConfig = execState (changeMirror True) config in
                    menuConfig newConfig
            'n'->do
                let newConfig = execState (changeMirror False) config in
                    menuConfig newConfig
    ---------
    '4' -> do
        putStrLn "\n\t\tMultiplier la durée"
        putStrLn "\n\t\tEntrez un nombre flottant pour multiplier la durée du menuet\n"
        d <- validateBoundedFloatInput 0
        let newConfig = execState (changeF d) config in
            menuConfig newConfig
    ---------
    '5' -> do
        putStrLn "\n\t\tChanger l'appareil de sortie"
       
        putStrLn "\n\t\tEntrez le numéro de l'appareil de sortie souhaité\n"
        device <- validateIntegralInput 
        let newConfig = execState (changeDevice device) config in
            menuConfig newConfig
    ---------
    _ -> do 
        putStrLn "Mauvaise Commande!\n"
        menuConfig config
    





--Fonction jouerMenuet, avec la configuration en paramètres
--jouerMenuet :: GameConfig -> IO()

--Il faut voir où mettre l'ouverture de stream, si on la met avant de jouer le menuet, on peut alors passer simplement
--Le stream en paramètres, on verra globalement ça avec la 4.4



--Fonctions de validation
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
      if (n < borneInf)  then
        putStrLn ("Il faut que la valeur supérieure à " ++ (show borneInf)) >> validateBoundedFloatInput borneInf
      else
        return n
    Nothing -> putStrLn ("Il faut que la valeur supérieure à " ++ (show borneInf))  >> validateBoundedFloatInput borneInf

