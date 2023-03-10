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

--Retourne le nombre de notes d’un objet musical.
noteCount :: MusObj -> Integer
noteCount (Note pd d v) = 1
noteCount (Chord onset elems) = foldl (\x y -> noteCount y) 0 elems
noteCount (Measure elems) = foldl (\x y -> noteCount y) 0 elems

--Retourne un nouvel objet musical dont la durée a été multipliée par un facteur flottant.
stretch :: MusObj -> Float -> MusObj
stretch (Note pd d v) val = (Note pd (d * (round val)) v)
stretch (Chord onset elems) val = (Chord onset (map (\x -> (stretch x val)) elems))
stretch (Measure elems) val = (Measure (map (\x -> (stretch x val)) elems))

--Retourne un nouvel objet musical dont les hauteurs ont été additionées de n demitons.
transpose :: MusObj -> Integer -> MusObj
transpose (Note pd d v) n = Note (pd + n) d v
transpose (Chord onset elems) n = Chord onset (map (\x -> (transpose x n )) elems )
transpose (Measure elems) n = Measure (map (\x -> (transpose x n ) ) elems  )


--Fait le miroir des toutes les hauteurs d’un objet musical autour d’une hauteur donnée.
--Le miroir d’une hauteur h autour d’une hauteur c est définie par c − (h − c).
mirror :: MusObj -> Integer -> MusObj
mirror (Note pd d v)  h = (Note (pd - (h-pd)) d v)
mirror (Chord onset elems)  h = Chord onset (map (\x -> mirror x h) elems)
mirror (Measure elems)  h = Measure (map (\x -> mirror x h) elems)
