local globalParams = require("src.data.dataGlobalParams")
local gui = require("src.ui.uiItems")

local class = {}

--function class.createRoad(pos)
--    local road = gui.newImageRect("gfx/road.jpg", pos, {320, 720})
--    road.anchorX = 0
--    road.anchorY = 0
--    
--    function road.resetTransition()
--        road.y = road.y - 480
--        transition.to(road, {time=globalParams.verticalSpeed, y=road.y+480, onComplete = road.resetTransition})
--    end
--    
--    transition.to(road, {time=globalParams.verticalSpeed, y=pos[2]+480, onComplete = road.resetTransition})
--    return road
--end

function class.createRoad()
    local road1 = gui.newImageRect("gfx/road.jpg", {0, -240}, {320, 960})
    road1.anchorX = 0
    road1.anchorY = 0
    
--    function road1:resetTransition()
--        if(road1 ~= nil) then
--            --print("r1 " .. road1.x .. " " .. road1.y  )
--            road1.y = road1.y - 6*240
--            transition.to(road1, {time=globalParams.verticalSpeed*3, y=road1.y+6*240, onComplete = road1.resetTransition})
--        end
--    end
--    transition.to(road1, {time=globalParams.verticalSpeed*1.5, y=road1.y+720, onComplete = road1.resetTransition})
    
    local road2 = gui.newImageRect("gfx/road.jpg", {0, -960}, {320, 960})
    road2.anchorX = 0
    road2.anchorY = 0
    
--    function road2:resetTransition()
--        if(self ~= nil) then
--            --print("r2 " .. self.x .. " " .. self.y  )
--            self.y = self.y - 6*240
--            transition.to(self, {time=globalParams.verticalSpeed*3, y=self.y+6*240, onComplete = road2.resetTransition})
--        end
--    end
--    
--    transition.to(road2, {time=globalParams.verticalSpeed*3, y=road2.y+6*240, onComplete = road2.resetTransition})
    return road1, road2
end

return class
