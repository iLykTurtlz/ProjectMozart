module StateConfig where


data GameConfig = GameConfig{
    instrument :: Int,
    mode :: Int,
    mirroir :: Bool,
    f :: Float,
    device :: Int
}

changeDevice :: Int -> State GameConfig Int
changeDevice newDevice = do
    options <- get
    put $ options {device = newDevice}
    return (newDevice)


changeInstrument :: Int -> State GameConfig Int
changeDevice newInstrument = do 
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

