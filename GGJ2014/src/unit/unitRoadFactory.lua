local gui = require("src.ui.uiItems")

local class = {}


function class.createRoad(pos)
    local road = gui.newImageRect("gfx/road.jpg", pos, {320, 480})
    road.anchorX = 0
    road.anchorY = 0
    
    function road.resetTransition()
        road.y = road.y - 480
        transition.to(road, {time=1000, y=road.y+480, onComplete = road.resetTransition})
    end
    
    transition.to(road, {time=1000, y=pos[2]+480, onComplete = road.resetTransition})
    return road
end

return class

