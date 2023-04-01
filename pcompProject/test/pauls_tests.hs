
import Text.Read 

test::IO ()
test = putStrLn "hello, world"


concatInput::IO ()
concatInput = do
  putStrLn "Enter a number"
  input <- getLine
  case (readMaybe input::Maybe Int) of
    Just a -> putStrLn ("You entered "++(show a))
    Nothing -> putStrLn "Invalid number entered" >> concatInput 

validateIntegralInput::IO Int
validateIntegralInput = do
  input <- getLine
  case (readMaybe input::Maybe Int) of
    Just n -> return n
    Nothing -> validateIntegralInput
{-
validateBoundedIntegralInput::Int->Int->Int
validateBoundedIntegralInput borneInf borneSup = do
  input <- getLine
  case (readMaybe input::Maybe Int) of 
    Just n -> 
      if (n < borneInf) || (n > borneSup) then do
        putStrLn ("Il faut que la valeur soit entre "++(show borneInf)++" et "++(show borneSup))
        validateBoundedIntegralInput borneInf borneSup
      else
        n
    Nothing -> putStrLn ("Il faut saisir un entier entre "++(show borneInf)++" et "++(show borneSup))
-}