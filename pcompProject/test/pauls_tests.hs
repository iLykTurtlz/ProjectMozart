module Main where

import Control.Concurrent
import Sound.PortMidi
import Midi
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

validateBoundedFloatInput::Float->Float->IO Float
validateBoundedFloatInput borneInf borneSup = do
  input <- getLine
  case (readMaybe input::Maybe Float) of 
    Just n -> 
      if (n < borneInf) || (n > borneSup) then
        putStrLn ("Il faut que la valeur soit entre "++(show borneInf)++" et "++(show borneSup)) >> validateBoundedFloatInput borneInf borneSup
      else
        return n
    Nothing -> putStrLn ("Il faut saisir un Float entre "++(show borneInf)++" et "++(show borneSup)) >> validateBoundedFloatInput borneInf borneSup


testPlay::MusObj->IO ()
testPlay mObj = do
  initialize
  result <- openOutput 2 1
  case result of
    Left err -> return ()
    Right stream ->
      do
        play mObj stream
        close stream
        return ()
  terminate
  return ()
