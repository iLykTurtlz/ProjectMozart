# Project Mozart


Le but de ce projet était de coder une petite application qui joue des Menuets selon le jeu que Mozart, qui permet de composer de manière aléatoire des menuets à partir de deux dés, de deux tableaux de 88 nombres, correspondant à 176 mesures.

# Lancer le jeu

Après avoir utilisé dans ce répertoire stack ghci dans un terminal, tous les modules de code sont compilés, il suffit d'écrire `main` dans la console.

## Premier Menu

De là, se déroule un petit menu qui propose soit de 
    * Quitter le jeu
    * Jouer un menuet
    * Changer la configuration
  
Si vous jouez un menuet sans avoir changé la configuration, il se fera avec les paramètres par défaut, si aucun son ne sort, il faudra configurer manuellement les appareils de sortie.


## Menu de configuration

Ce Menu permet de changer la configuration de jeu d'un menuet.
    * Quitter le menu de configuration
    * Changer l'instrument (dans nos tests, cela ne marchait pas, nous pensons que c'est à cause de la fonction fournie, ou bien de notre fluidsynth)
    * Changer le mode de transposition
      * 0. Aucune transposition
      * 1. Transposer de +12 demi tons
      * 2. Transposer de -12 demi tons
      * 3. Transposer d'un nombre libre de tons (à saisir)
    * Mode mirroir ?
    * Multiplier la durée
    * Changer l'appareil de sortie


# Organisation du code`

## Le répertoire `pcompProject/app`

Il contient le code du module Main dans `Main.hs`, qui va servir à lancer le menu une première fois avec la configuration par défaut. Il essaie de récupérer l'appareil de sortie par défaut, et s'il n'y parvient pas, il lance le menu avec 0 (il faudra configurer manuellement).

## Le répertoire `pcompProject/src`

Il contient le code des fonctionnalités sur lesquelles repose le main :

  * `DataBase.hs` contient la liste des mesures que nous utiliserons et les fonctions qui permettent d'en récupérer une pour notre jeu,
  * `IOMenu.hs` contient les fonctions qui permettent de gérer les Entrées/Sorties, le Menu, et le jeu d'un Menuet
  * `Midi.hs` (fourni entièrement) contient les fonctions qui permettent de gérer la sortie Midi,
  * `MusicLib.hs` contient toutes les fonctions utiles pour transformer et jouer les mesures représentées par des ;`MusObj`,
  * `StateConfig.hs` contient la définition d'un type de données qui contient tous les champs de paramètres d'une configuration, ainsi que les fonctions pour les changer (utilisées par le menu).

# Choix par rapport au sujet

Nous avons choisi d'étendre le sujet en permettant une transposition plus libre grâce à un champ supplémentaire dans `GameConfig` qui contient le nombre de demis tons de la transposition libre, parce qu'il nous semblait utile de permettre des changements de tonalité.