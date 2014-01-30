-----------------------------------------------------------
--
--	NAZWA PLIKU (WERSJA)
--	PRZEZNACZENIE PLIKU
--	AUTOR, WŁASNOŚĆ, DATA MODYFIKACJI
--
-----------------------------------------------------------

-- REQUIRE
local phsyics = require("physics")

-- DEFINICJE
local TClass = {}

-- PRYWATNE
local prywatnaZmienna = 10

local prywatnaListaObiektow = { 1, 2, 3, 4, 5 }

local function contruktorPrywatny()

end	

-- PUBLICZNE STATYCZNE
TClass.publicznaZmiennaStatyczna = 10
TClass.publicznaStrukturaDanych =
{
Tomek = 10,
wiek = 20,
Iza = 20,
wielkaAnia = { wiek = true, wskaznik = nil },
}

---------------------------------------
--
-- @return @class Typ
function TClass.construktorPubliczny()

---@classDef Typ
local T = {}

-- PRYWATNE
local prywatnePoleObiektu = 10
local function prywatnaMetodaObiektu()	

end

-- PUBLICZNE
T.publicznePoleObiektu = 10
function T:publicznaMetodaObiektu()

end

--WYWOŁANIE METODY PRYWATNEJ
prywatnaMetodaObiektu()

--WYWOŁANIE METODY OBIEKTU
T:publicznaMetodaObiektu()

--WYWOŁANIE METODY KLASY TEGO OBIEKTU
TClass.construktorPubliczny()

return T

end	

return TClass

