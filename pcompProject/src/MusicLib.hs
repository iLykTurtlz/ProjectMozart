module MusicLib where

import Sound.PortMidi
import Control.Concurrent
import Data.List


--Ici les tests sont bons, les fonctions marchent.

-- Music interface
data MusObj = Note  Integer Integer Integer | 
              Chord Integer [MusObj] | 
              Measure [MusObj] deriving (Show) 

--Calcule la duree d'un accord
getOnset :: MusObj -> Integer
getOnset (Note p d v) = 0
getOnset (Chord onset elems) = onset
getOnset (Measure elems) = 0

--Calcule la durée d'un objet musical
getDur :: MusObj -> Integer
getDur (Note p d v) = d
getDur (Chord onset elems) = foldl max 0 (map getDur elems)
getDur (Measure elems) = foldl max 0 (map (\x -> (getDur x) + (getOnset x)) elems)

--Retourne le nombre de notes d’un objet musical. 
--TEST OK
noteCount :: MusObj -> Integer
noteCount (Note pd d v) = 1
noteCount (Chord onset elems) = foldl (\x y-> x + y) 0 (map noteCount elems)
noteCount (Measure elems) = foldl (\x y -> x + y) 0 (map noteCount elems)

--Retourne un nouvel objet musical dont la durée a été multipliée par un facteur flottant.
--TEST OK
stretch :: MusObj -> Float -> MusObj
stretch (Note pd d v) val = (Note pd (d * (round val)) v)
stretch (Chord onset elems) val = (Chord onset (map (\x -> (stretch x val)) elems))
stretch (Measure elems) val = (Measure (map (\x -> (stretch x val)) elems))

--Retourne un nouvel objet musical dont les hauteurs ont été additionées de n demitons.
--TEST OK
transposer :: MusObj -> Integer -> MusObj
transposer (Note pd d v) n = Note (pd + n) d v
transposer (Chord onset elems) n = Chord onset (map (\x -> (transposer x n )) elems )
transposer (Measure elems) n = Measure (map (\x -> (transposer x n ) ) elems  )

--Fait le miroir des toutes les hauteurs d’un objet musical autour d’une hauteur donnée.
--Le miroir d’une hauteur h autour d’une hauteur c est définie par c − (h − c).
--TEST OK
mirror :: MusObj -> Integer -> MusObj
mirror (Note pd d v)  h = (Note (pd - (h-pd)) d v)
mirror (Chord onset elems)  h = Chord onset (map (\x -> mirror x h) elems)
mirror (Measure elems)  h = Measure (map (\x -> mirror x h) elems)



---------------- COLLECT MIDI --------

collectMidiNote :: Integer->Integer->Integer->Integer->[(Integer,PMMsg)]
collectMidiNote p d v at  =
 let noteOn = PMMsg 0x90 (fromIntegral p) (fromIntegral v)
     noteOff = PMMsg 0x90 (fromIntegral p) 0 in
 [(at, noteOn),(at + d, noteOff)]


collectMidi :: MusObj -> Integer -> [(Integer, PMMsg)]
collectMidi (Note p d v) at = collectMidiNote p d v at
collectMidi (Chord onset elems) at = concat (map (\elem->collectMidi elem at)(elems))
collectMidi (Measure elems) at = concat (map (\elem->collectMidi elem at)(elems))

myPredicate :: Ord a => (a, b1) -> (a, b2) -> Ordering
myPredicate (a1, a2) (b1, b2) = compare a1 b1

sortMidi ::  [(Integer,PMMsg)] -> [(Integer,PMMsg)]
sortMidi = sortBy myPredicate

play :: MusObj -> PMStream -> IO ()
play obj stream = do
  startTime <- time
  let dur = getDur obj
  let midiEvents = sortMidi (collectMidi obj 0)
  let evts = map (\(t,msg) -> PMEvent {message = encodeMsg msg, 
    timestamp = fromIntegral t + startTime}) midiEvents
  writeEvents stream evts
  threadDelay (fromIntegral (dur*1000))
  return ()



-------------------------
--Valeurs nous permettant de tester les fonctions précédentes avec stack ghci directement depuis l'interface
mesure_test :: MusObj
mesure_test = Measure [
            (Chord 0 [(Note 42 610 86),(Note 54 594 81),(Note 81 315 96)]),
            (Chord 292 [(Note 78 370 78)]),
            (Chord 601 [(Note 76 300 91),(Note 43 585 83),(Note 55 588 98)]),
            (Chord 910 [(Note 79 335 96)]),
            (Chord 1189 [(Note 73 342 86),(Note 57 595 76),(Note 45 607 83)]),
            (Chord 1509 [(Note 76 280 93)])]
note_test:: MusObj
note_test = (Note 76 280 93)
chord_test :: MusObj
chord_test = (Chord 0 [(Note 42 610 86),(Note 54 594 81),(Note 81 315 96)])