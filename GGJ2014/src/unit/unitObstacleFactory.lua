local globalParams = require("src.data.dataGlobalParams")
local gui = require("src.ui.uiItems")
local physics = require("physics")
local class = {}

class.goodLifeObstacleList = {
    {"gfx/good_life_obst_1.png", 40, 40},
    {"gfx/good_life_obst_1.png", 40, 40},
    {"gfx/good_life_obst_1.png", 40, 40}
}

class.badLifeObstacleList = {
    {"gfx/bad_life_obst_1.jpg", 40, 40},
    {"gfx/bad_life_obst_2.jpg", 60, 40},
    {"gfx/bad_life_obst_3.jpg", 80, 40}
}

function class.getRandomObstacle()
    local result = math.random()
    --if result < globalParams.getObstacleProbability() then
        local obstacle = class.createObstacle()
        class.getRandomPos(obstacle)
        physics.addBody(obstacle, "kinematic", {filter={ categoryBits = 4, maskBits = 8 }})
        
        function obstacle.destroy()
            if obstacle then 
                obstacle:removeSelf()
            end
        end
        --transition.to(obstacle, {time=globalParams.verticalSpeed*3, y=obstacle.y + 480*3, onComplet=obstacle.destroy})
        return obstacle
    --end
end

function class.createObstacle()
    local result = math.random()
    if(result < 0.6) then -- 0.4 zycie
       return class.createLifeObstacle()
    elseif(result < 0.7) then -- 0.1 punkty
        return class.createGoldObstacle()
    elseif(result < 0.9) then -- 0.2 obrona
        return class.createDefenseObstacle()
    else -- 0.1 sterowanie
        return class.createSteringObstacle()
   end
end

function class.getRandomPos(obstacle)
    local width = display.contentWidth * 0.6 - obstacle.contentWidth
    local x = display.contentWidth * 0.2 + obstacle.contentWidth/2 + width * math.random()
    local y = -240 - 480 * math.random()
    obstacle.x = x
    obstacle.y = y
end

function class.createLifeObstacle()
    local tab = nil
    local name = nil
    local isBad = false
    local result = math.random()
    if(result < 0.2) then
        tab = class.goodLifeObstacleList
        name = "good_life"
        isBad = false
    else
        tab = class.badLifeObstacleList
        name = "bad_life"
        isBad = true
    end
    
    result = math.random()
    local tabRow = nil
    if(result < 0.33) then
        tabRow = tab[1]
    elseif(result < 0.66) then
        tabRow = tab[2]
    else
        tabRow = tab[3]
    end
    
    local life = gui.newImageRect(tabRow[1], {0,0}, {tabRow[2], tabRow[3]})
    life.name = name
    life.isBad = isBad
    return life
end

function class.createGoldObstacle()
    return class.createSimpleObstacle({"gfx/good_$.jpg", "good_$"}, {"gfx/bad_$.jpg", "bad_$"})
end

function class.createDefenseObstacle()
    return class.createSimpleObstacle({"gfx/good_def.jpg", "good_def"}, {"gfx/bad_def.jpg", "bad_def"})
end

function class.createSteringObstacle()
    return class.createSimpleObstacle({"gfx/good_ster.jpg", "good_ster"}, {"gfx/bad_ster.jpg", "bad_ster"})
end

function class.createSimpleObstacle(good, bad)
    local name = nil
    local gfx = nil
    local isBad = false
    local result = math.random()
    if(result < 0.4) then
        gfx = good[1]
        name = good[2]
        isBad = false
    else
        gfx = bad[1]
        name = bad[2]
        isBad = true
    end
    
    local gold = gui.newImageRect(gfx, {0,0}, {40, 40})
    gold.name = name
    gold.isBad = isBad
    return gold
end

return class

