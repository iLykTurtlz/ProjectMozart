module StateConfig where
import Control.Monad.State.Strict

--Structure qui contient toutes les informations nécessaires pour configurer la manière dont
--sera joué le menuet.
data GameConfig = GameConfig{
    instrument :: Int,
    mode :: Int,
    mirror :: Bool,
    f :: Float,
    device :: Int,
    transpoLibre :: Int
} deriving (Show)


--Fonctions qui permettent de changer les différentes informations des GameConfig grâce à la monade State

changeDevice :: Int -> State GameConfig Int
changeDevice newDevice = do
    options <- get
    put $ options {device = newDevice}
    return (newDevice)

changeInstr :: Int -> State GameConfig Int
changeInstr newInstrument = do 
    options <- get
    put $ options {instrument = newInstrument}
    return (newInstrument)

changeMode :: Int -> State GameConfig Int
changeMode newMode = do
    options <- get
    put $ options {mode = newMode}
    return (newMode)

changeTranspoLibre :: Int -> State GameConfig Int
changeTranspoLibre newTranspoLibre = do
    options <- get
    put $ options {transpoLibre = newTranspoLibre}
    return (newTranspoLibre)

changeMirror :: Bool -> State GameConfig Bool
changeMirror newMirror = do
    options <- get
    put $ options {mirror = newMirror}
    return (newMirror)

changeF :: Float -> State GameConfig Float
changeF newF = do
    options <- get
    put $ options {f = newF}
    return (newF)

