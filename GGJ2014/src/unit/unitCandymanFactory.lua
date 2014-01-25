local globalParams = require("src.data.dataGlobalParams")
local gui = require("src.ui.uiItems")
local physics = require( "physics" )

local class = {}

function class.getRandomCandyman()
    local result = math.random()
    print(result .. " " .. globalParams.getCandymanProbability())
    if result < globalParams.getCandymanProbability() then
        result = math.random()
        local Y = -240 - 240 * math.random()
        local candyman = nil
        if result > 0.5 then
            candyman = class.createCandyman(-1, {15, Y})
        else
            candyman = class.createCandyman(1, {display.contentWidth - 15, Y})
        end
        
        function candyman.destroy()
            if candyman then 
                candyman:removeSelf()
            end
        end
        
        transition.to(candyman, {time=globalParams.verticalSpeed*3, y=candyman.y + 480*3, onComplet=candyman.destroy})
        return candyman
    end
    
end

function class.createCandyman(direction, pos)
    local size = {30, 70}
    local candyman = nil
    
    local result = math.random()
    if result < 0.5 then
        if(direction == -1) then
            candyman = gui.newImageRect("gfx/candyman_1.jpg", pos, size)
        else
            candyman = gui.newImageRect("gfx/candyman_2.jpg", pos, size)
        end
        candyman.isBad = true
    else
        if(direction == -1) then
            candyman = gui.newImageRect("gfx/grandma_1.jpg", pos, size)
        else
            candyman = gui.newImageRect("gfx/grandma_2.jpg", pos, size)
        end
        candyman.isBad = false
    end
    candyman.name = "candyman"
    --print("candyman ") 
    --print(physics.addBody(candyman, "kinematic"))
    physics.addBody(candyman, "kinematic", {filter={ categoryBits = 2, maskBits = 1 }})
    
    return candyman
end

return class
