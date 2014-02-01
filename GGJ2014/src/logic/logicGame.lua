local globalParams = require("src.data.dataGlobalParams")
local storyboard = require("storyboard")

local class = {}

function class.checkLooseCondition(onLoose, onRestart)
    if(globalParams.life == 0) then
        globalParams.life = -1
        if(onLoose) then
            pcall( onLoose )
        end
        
        class.loose(onRestart)
    end
end

function class.nextLevel(obstacleList)
    if(globalParams.distance > 10*globalParams.currentLevel) then
        globalParams.currentLevel = globalParams.currentLevel + 1
        globalParams.verticalSpeed = globalParams.verticalSpeed + 500
        
        globalParams.physicVerticalSpeed = globalParams.physicVerticalSpeed + 50
        
        for i = 1, #obstacleList do 
            local tmp = obstacleList[i]
            if(tmp ~= nil and tmp.y ~= nil) then
                tmp:setLinearVelocity(0, globalParams.physicVerticalSpeed)
            end
        end
    end
end

function class.loose(onRestart) 
    local scene = storyboard.getScene("src.scene.sceneLooseDialog")
    scene.onRestart = onRestart
    storyboard.showOverlay("src.scene.sceneLooseDialog", { effect = "fromBottom", time = 150, isModal = true } )
end

return class

