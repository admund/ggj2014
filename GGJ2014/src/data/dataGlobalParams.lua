local class = {}

class.verticalStep = 10
class.horizontalStep = display.contentWidth/8

class.throwSpeed = 450

class.maxLife = 100

-- move
class.verticalSpeed = 2000 -- czas w milisec potrzebny do pokanania calej mapy Vertical
class.horizontalSpeed = 0.2 -- czas w milisec potrzebny do pokanania calej mapy Horizontal
class.distance = 0

-- CA$H
class.points = 0
class.pointsForBad = 100
class.pointsForGood = 10

class.pointsModif = 1
class.pointsModifTime = 0

-- STERING
class.steringModifType = 0
class.steringModifTime = 0

-- BAD MODE
class.badLevel = 0.5 -- od 0 do 1
class.badForBad = -0.05
class.badForGood = 0.02

-- life
class.life = 100
class.dmgModif = 1
class.dmgModifTime = 0
class.simpleDmg = 30
class.simpleHeal = 10

-- level
class.currentLevel = 1

-- prawdopodobienstaw
class.candymanProbability = {0.4, 0.45, 0.5, 0.55, 0.6, 0.5, 0.4, 0.4, 0.4, 0.3}
function class.getCandymanProbability()
    if(class.currentLevel > 10) then
        return class.obstacleProbability[10]
    else
        return class.candymanProbability[class.currentLevel]
    end
end

class.obstacleProbability = {0.3, 0.3, 0.4, 0.4, 0.5, 0.5, 0.55, 0.55, 0.6, 0.7}
function class.getObstacleProbability()
    if(class.currentLevel > 10) then
        return class.obstacleProbability[10]
    else
        return class.obstacleProbability[class.currentLevel]
    end
end

function class.reset()
    -- move
    class.verticalSpeed = 2000
    class.distance = 0

    -- CA$H
    class.points = 0
    class.pointsForBad = 100
    class.pointsForGood = 10

    class.pointsModif = 1
    class.pointsModifTime = 0

    -- STERING
    class.steringModifType = 0
    class.steringModifTime = 0

    -- BAD MODE
    class.badLevel = 0.5 -- od 0 do 1

    -- life
    class.life = 100
    class.dmgModif = 1
    class.dmgModifTime = 0

    -- level
    class.currentLevel = 1
end

class.lastUpdateTime = 0
function class.updateSkillTime(updateTime)
    local deltaTime = updateTime - class.lastUpdateTime
    class.lastUpdateTime = updateTime
    
    if(class.pointsModifTime > 0) then
        class.pointsModifTime = class.pointsModifTime - deltaTime
        if(class.pointsModifTime < 0) then
            class.pointsModif = 1
        end
    end
    
    if(class.steringModifTime > 0) then
        class.steringModifTime = class.steringModifTime - deltaTime
        if(class.steringModifTime < 0) then
            class.steringModifType = 0
        end
    end
    
    if(class.dmgModifTime > 0) then
        class.dmgModifTime = class.dmgModifTime - deltaTime
        if(class.dmgModifTime < 0) then
            class.dmgModif = 1
        end
    end
    
end
return class

