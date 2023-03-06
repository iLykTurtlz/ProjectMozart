module Main (main) where

import Lib

getChars1::IO ()
getChars1 = do
	c1 <- getChar
	c2 <- getChar
	putStrLn([c1,c2])

getChars2::IO ()
getChars2 = 
	getChar >>=(\x -> getChar >>= (\y -> putStrLn([x,y])))



main :: IO ()
main = getChars1




