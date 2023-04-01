module StateConfig where

import Control.Monad.State.Strict
data GameConfig = GameConfig{
    instrument :: Int,
    mode :: Int,
    mirroir :: Bool,
    f :: Float,
    device :: Int
} deriving (Show)

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

changeMirror :: Bool -> State GameConfig Bool
changeMirror newMirroir = do
    options <- get
    put $ options {mirroir = newMirroir}
    return (newMirroir)

changeF :: Float -> State GameConfig Float
changeF newF = do
    options <- get
    put $ options {f = newF}
    return (newF)

