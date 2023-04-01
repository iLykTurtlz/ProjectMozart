

test::IO ()
test = putStrLn "hello, world"


concatInput::IO ()
concatInput = do
  putStrLn "Enter a number"
  input <- getLine
  case readMaybe input of
    Just a -> putStrLn ("You entered "++(show a))
    Nothing -> putStrLn "Invalid number entered" 
