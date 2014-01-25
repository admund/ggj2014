local globalParams = require("src.data.dataGlobalParams")
local audio = require("src.utils.utilsAudio")

local class = {}

function class.collision(event)
    if ( event.phase == "began" ) then
        
        print( "began: " .. event.object1.name .. " and " .. event.object2.name )
    
    -- candyman and drug
        if event.object1.name == "candyman" and event.object2.name == "drug" then
            class.collisionDrugCandyman(event.object2, event.object1)
        elseif event.object1.name == "drug" and event.object2.name == "candyman" then
            class.collisionDrugCandyman(event.object1, event.object2)
        end
        
        
    end
end

function class.collisionDrugCandyman(drug, candyman)
    drug:destroy()
    
    if globalParams.badMode then
        globalParams.points = globalParams.points + globalParams.pointsForBad
        
        globalParams.badLevel = globalParams.badLevel + globalParams.badForBad
    else
        globalParams.points = globalParams.points + globalParams.pointsForGood
        
        globalParams.badLevel = globalParams.badLevel + globalParams.badForGood
    end
    
    
    class.checkBoarderConditionBadLevel()

    audio.playThankYou()
end

function class.checkBoarderConditionBadLevel()
    if(globalParams.badLevel > 1) then
        globalParams.badLevel = 1
    elseif(globalParams.badLevel < 0) then
        globalParams.badLevel = 0
    end
end

return class

