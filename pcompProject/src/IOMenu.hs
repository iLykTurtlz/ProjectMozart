module IOMenu where

import Control.Concurrent
import Sound.PortMidi
import Midi
import StateConfig

--À COMPLÉTER

--Fonction menu, avec un paramètre de type GameConfig, fonction qui affiche un menu, et selon le choix,
--fait l'action souhaitée.
--On a besoin d'une configuration pour lancer un menu, au premier appel, ce sera la configuration de base.
menu :: GameConfig -> IO()          
menu config = do
    putStrLn "Le Jeu de Mozart\nQue voulez vous faire ?\n"
    putStrLn " 0 : Quitter\n 1 : Jouer un Menuet\n 2 : Changer la configuration\n"
    c <- getChar
    if c == 1 then --Cas où on joue le menuet

    else if c == 2 then --Cas où on va dans le menu de changement de configuration
    

    else --Cas où on arrête (si pas dans ce cas, appel récursif à Menu)

    terminate
    return()

--Fonction menuConfig, avec un paramètre de type GameConfig, 
--fonction qui affiche les choix et fait les changements de configuration correspondant, et retourne la nouvelle configuration
menuConfig :: GameConfig -> IO GameConfig
menuConfig config = do
    putStrLn "\tQuel changement de configuration apporter ?\n"
    putStrLn "\t 0 : Aucun\n\t 1 : Changer d'instrument\n\t 2 : Mode de transposition\n\t 3 : Mode mirroir ?\n\t 4 : Multiplier la durée du menuet\n\t 5 : Changer l'appareil de Sortie"
    --Traiter les différents cas en faisant appel aux fonctions de StateConfig
    --Si 1,2,3,4,5 en entrée, on fait un appel récursif à GameConfig avec la nouvelle 
    --configuration récupérée, sinon, on la retourne juste.



--Fonction jouerMenuet, avec la configuration en paramètres
jouerMenuet :: GameConfig -> IO()

--Il faut voir où mettre l'ouverture de stream, si on la met avant de jouer le menuet, on peut alors passer simplement
--Le stream en paramètres, on verra globalement ça avec la 4.4


