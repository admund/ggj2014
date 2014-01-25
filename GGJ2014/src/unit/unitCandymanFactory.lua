local globalParams = require("src.data.dataGlobalParams")
local gui = require("src.ui.uiItems")
local physics = require( "physics" )

local class = {}

function class.getRandomCandyman()
    local result = math.random()
    --if result > globalParams.candymanProbability then
        result = math.random()
        local Y = -240 - 240 * math.random()
        if result > 0.5 then
            return class.createCandyman(-1, {15, Y})
        else
            return class.createCandyman(1, {display.contentWidth - 15, Y})
        end
    --end
    
end

function class.createCandyman(direction, pos)
    local size = {30, 70}
    local candyman = nil
    if globalParams.badMode then
        if(direction == -1) then
            candyman = gui.newImageRect("gfx/candyman_1.jpg", pos, size)
        else
            candyman = gui.newImageRect("gfx/candyman_2.jpg", pos, size)
        end
    else
        if(direction == -1) then
            candyman = gui.newImageRect("gfx/grandma_1.jpg", pos, size)
        else
            candyman = gui.newImageRect("gfx/grandma_2.jpg", pos, size)
        end
    end
    candyman.name = "candyman"
    --print("candyman ") 
    --print(physics.addBody(candyman, "kinematic"))
    physics.addBody(candyman, "kinematic")
    
    transition.to(candyman, {time=globalParams.verticalSpeed * 2, y=pos[2]+480*2, 
            onComplete = candyman.removeSelf})
    
    return candyman
end

return class
