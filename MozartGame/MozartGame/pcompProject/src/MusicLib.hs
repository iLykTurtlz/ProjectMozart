module MusicLib where


-- Music interface

data MusObj = Note  Integer Integer Integer | 
              Chord Integer [MusObj] | 
              Measure [MusObj] deriving (Show) 

--Calcule la duree d'un objet musical
getOnset :: MusObj -> Integer
getOnset (Note p d v) = 0
getOnset (Chord onset elems) = onset
getOnset (Measure elems) = 0

getDur :: MusObj -> Integer
getDur (Note p d v) = d
getDur (Chord onset elems) = foldl max 0 (map getDur elems)
getDur (Measure elems) = foldl max 0 (map (\x -> (getDur x) + (getOnset x)) elems)
