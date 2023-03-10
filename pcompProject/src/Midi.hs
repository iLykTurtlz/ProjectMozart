module Midi where

import Sound.PortMidi
import Control.Concurrent (forkIO, threadDelay)

--playAfterDelay :: Int -> IO (Either PMError PMSuccess) -> IO ()
playAfterDelay :: Int -> IO (Either PMError PMSuccess) ->  IO ()
playAfterDelay t f = forkIO (threadDelay t >> f >> return ()) >> return ()

--sendMidiNote :: Integer->Integer->Integer->Integer->PMStream->IO ThreadId
sendMidiNote :: Integer->Integer->Integer->Integer->PMStream->IO ()
sendMidiNote p d v at stream = do
 startTime <- time
 let noteOn = PMMsg 0x90 (fromIntegral $ p) (fromIntegral $ v)
     evt1   = PMEvent (encodeMsg noteOn) startTime
     noteOff = PMMsg 0x90 (fromIntegral $ p) (fromIntegral $ 0)
     evt2   = PMEvent (encodeMsg noteOff) startTime
 playAfterDelay (fromIntegral $ (at * 1000)) (writeShort stream evt1)
 playAfterDelay (fromIntegral $ ((at + d) * 1000)) (writeShort stream evt2)

changeInstrument :: Integer->PMStream->IO ()
changeInstrument  num stream = do
 startTime <- time
 let pgmchange = PMMsg 0x1C (fromIntegral $ num) (fromIntegral $ 0)
     evt1   = PMEvent (encodeMsg pgmchange) startTime
 writeShort stream evt1
 return ()