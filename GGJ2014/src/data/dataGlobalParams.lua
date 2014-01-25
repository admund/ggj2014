local class = {}

class.verticalSpeed = 3000 -- czas w milisec potrzebny do pokanania calej mapy Vertical
class.horizontalSpeed = 0.2 -- czas w milisec potrzebny do pokanania calej mapy Horizontal

class.verticalStep = 10
class.horizontalStep = display.contentWidth/8

class.throwSpeed = 450

class.maxLife = 100

-- game
class.life = 100
class.distance = 0
class.badLevel = 0.5 -- od 0 do 1
class.badMode = false

-- CA$H
class.points = 0
class.pointsForBad = 100
class.pointsForGood = 10

-- BAD MODE
class.badLevel = 0.5 -- od 0 do 1
class.badMode = false
class.badForBad = -0.05
class.badForGood = 0.02

-- prawdopodobienstaw
class.candymanProbability = 0.4

return class

