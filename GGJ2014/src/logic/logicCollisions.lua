local globalParams = require("src.data.dataGlobalParams")
local gui = require("src.ui.uiItems")
local audio = require("src.utils.utilsAudio")

local standardSkillTime = 5000

local class = {}

function class.collision(event)
    if ( event.phase == "began" ) then
        
        --print( "began: " .. event.object1.name .. " and " .. event.object2.name )
    
    -- candyman and drug
        if event.object1.name == "candyman" and event.object2.name == "drug" then
            class.collisionDrugCandyman(event.object2, event.object1)
        elseif event.object1.name == "drug" and event.object2.name == "candyman" then
            class.collisionDrugCandyman(event.object1, event.object2)
        end
        
    -- character and obstacle
        if event.object2.name == "character"  then
            class.collisionCharacterObstacle(event.object2, event.object1)
        elseif event.object1.name == "character" then
            class.collisionCharacterObstacle(event.object1, event.object2)
        end
        
        
    end
end

function class.collisionDrugCandyman(drug, candyman)
    drug:destroy()
    
    if globalParams.badMode then
        globalParams.points = globalParams.points + globalParams.pointsForBad*globalParams.pointsModif
        globalParams.badLevel = globalParams.badLevel + globalParams.badForBad
    else
        globalParams.points = globalParams.points + globalParams.pointsForGood*globalParams.pointsModif
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

function class.collisionCharacterObstacle(character, obstacle)
    
    if(obstacle.name == "bad_life" or obstacle.name == "good_life") then
        class.collisionLifeObstacle(character, obstacle)
    elseif(obstacle.name == "bad_$" or obstacle.name == "good_$") then
        class.collisionGoldObstacle(character, obstacle)
    elseif(obstacle.name == "bad_def" or obstacle.name == "good_def") then
        class.collisionDefObstacle(character, obstacle)
    elseif(obstacle.name == "bad_ster" or obstacle.name == "good_ster") then
        class.collisionSteringObstacle(character, obstacle)
    end
end

function class.collisionLifeObstacle(character, obstacle)
    class.tryRevertEffect(obstacle)
    
    print("1 " .. globalParams.life .. " " .. obstacle.name .. " " ..globalParams.dmgModif )
    if(obstacle.name == "bad_life") then
        globalParams.life = globalParams.life - (globalParams.dmgModif * globalParams.simpleDmg)
    else
        globalParams.life = globalParams.life + globalParams.simpleDmg/2
    end
    print("2 " .. globalParams.life)
    class.checkBoarderConditionLife()
end

function class.checkBoarderConditionLife()
    if(globalParams.life > 100) then
        globalParams.life = 100
    elseif(globalParams.life < 0) then
        globalParams.life = 0
    end
end

function class.collisionGoldObstacle(character, obstacle)
    class.tryRevertEffect(obstacle)
    
    if(obstacle.name == "bad_$") then
        if(globalParams.pointsModif == 2) then
            globalParams.pointsModif = 0.5
            globalParams.pointsModifTime = standardSkillTime
        else
            globalParams.pointsModif = 0.5
            globalParams.pointsModifTime = globalParams.pointsModifTime + standardSkillTime
        end
    else
        if(globalParams.pointsModif == 0.5) then
            globalParams.pointsModif = 2
            globalParams.pointsModifTime = standardSkillTime
        else
            globalParams.pointsModif = 2
            globalParams.pointsModifTime = globalParams.pointsModifTime + standardSkillTime
        end
    end
    
    obstacle:removeSelf()
    --class.checkBoarderConditionLife()
end

function class.collisionDefObstacle(character, obstacle)
    class.tryRevertEffect(obstacle)
    
    if(obstacle.name == "bad_def") then
        if(globalParams.dmgModif == 0.5) then
            globalParams.dmgModif = 2
            globalParams.dmgModifTime = standardSkillTime
        else
            globalParams.dmgModif = 2
            globalParams.dmgModifTime = globalParams.dmgModifTime + standardSkillTime
        end
    else
        if(globalParams.dmgModif == 2) then
            globalParams.dmgModif = 0.5
            globalParams.dmgModifTime = standardSkillTime
        else
            globalParams.dmgModif = 0.5
            globalParams.dmgModifTime = globalParams.dmgModifTime + standardSkillTime
        end
    end
    
    obstacle:removeSelf()
end

function class.collisionSteringObstacle(character, obstacle)
    class.tryRevertEffect(obstacle)
    
    if(obstacle.name == "bad_ster") then
        if(globalParams.steringModifType == 1) then
            globalParams.steringModifType = -1
            globalParams.steringModifTime = standardSkillTime
        else
            globalParams.steringModifType = -1
            globalParams.steringModifTime = globalParams.steringModifTime + standardSkillTime
        end
    else
        if(globalParams.steringModifType == -1) then
            globalParams.steringModifType = 1
            globalParams.steringModifTime = standardSkillTime
        else
            globalParams.steringModifType = 1
            globalParams.steringModifTime = globalParams.steringModifTime + standardSkillTime
        end
    end

    obstacle:removeSelf()
end

function class.tryRevertEffect(obstacle)
    if(obstacle.isBad == false and globalParams.badLevel < 0.5) then
        
        local rand = math.random()
        print("bad " .. rand .. " " .. (0.5 - globalParams.badLevel/2))
        
        if math.random() < (0.5 - globalParams.badLevel/2) then
            class.reverEffect(obstacle)
            gui.newFlotingText("You're BAD!!! REVERT :(", true)
        end
    elseif(obstacle.isBad and globalParams.badLevel > 0.5) then
        
        local rand = math.random()
        print("good " .. rand .. " " .. (globalParams.badLevel - 0.5)/2)
        
        if math.random() < (globalParams.badLevel - 0.5)/2 then
            class.reverEffect(obstacle)
            gui.newFlotingText("You're GOOD!!! REVERT :)", false)
        end
    end
    
end

function class.reverEffect(obstacle) 
    
    if(obstacle.name == "good_life") then
        obstacle.name = "bad_life"
    elseif(obstacle.name == "bad_life") then
        obstacle.name = "good_life"
        
    elseif(obstacle.name == "good_$") then
        obstacle.name = "good_$"
    elseif(obstacle.name == "good_$") then
        obstacle.name = "good_$"
        
    elseif(obstacle.name == "good_def") then
        obstacle.name = "bad_def"
    elseif(obstacle.name == "bad_def") then
        obstacle.name = "good_def"
        
    elseif(obstacle.name == "good_ster") then
        obstacle.name = "bad_ster"
    elseif(obstacle.name == "bad_ster") then
        obstacle.name = "good_ster"
        
    end
end

return class

