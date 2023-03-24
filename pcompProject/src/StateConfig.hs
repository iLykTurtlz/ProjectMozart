data GameConfig = GameConfig{
    instrument :: Int
    mode :: Int
    mirroir :: Bool
    f :: Float
    device :: Int
}

--Configure l'instrument à la valeur voulue
confInst :: State GameConfig Int
confInst = do
    config <- get 
