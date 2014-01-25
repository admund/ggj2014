local globalParams = require("src.data.dataGlobalParams")
local drugsFactory = require("src.unit.unitDrugsFactory")
local gui = require("src.ui.uiItems")
local physics = require("physics")

local character = display.newGroup()

local startPos = {display.contentCenterX, display.contentHeight - 70*2}

-- wyswietlanie
local dispalyObject = gui.newImageRect("gfx/character.jpg", startPos, {40, 70})
print("character ")
print(physics.addBody(dispalyObject, "kinematic"))
character:insert(dispalyObject)

-- rzucanie
character.canThrow = true

-- poruszanie
character.canMove = true
character.position = 0
character.moveDirection = 0
character.lastMoveTime = 0

-- functions
function character.realeseMove()
    character.canMove = true
end

function character.realeseThrow()
    character.canThrow = true
end

function character:setMove(direction)
    character.moveDirection = direction
end

--function character:moveLeft()
--    if(character.canMove and character.position > -3) then
--        character.canMove = false
--        character.position = character.position - 1
--        transition.to( character, { time=globalParams.horizontalSpeed, 
--                x=character.x - globalParams.horizontalStep, onComplete=character.realeseMove} )
--    end
--end
--
--function character:moveRight()
--    if(character.canMove and character.position < 3) then
--        character.canMove = false
--        character.position = character.position + 1
--        transition.to( character, { time=globalParams.horizontalSpeed, 
--                x=character.x + globalParams.horizontalStep, onComplete=character.realeseMove} )
--    end
--end

function character:move(lastTime)
    local deltaTime = lastTime - character.lastMoveTime
    character.lastMoveTime = lastTime
    local dist = character.moveDirection * globalParams.horizontalSpeed * deltaTime
    local dest = startPos[1] + character.x + dist
    
    if(dest < display.contentWidth*0.2) then
        dest = display.contentWidth*0.2
    elseif(dest > display.contentWidth*0.8) then
        dest = display.contentWidth*0.8
    end
    
    character.x = dest - startPos[1]
    --transition.to( character, { time=1, x=dest})--, onComplete=character.realeseMove} )
    
    -- add distance
    globalParams.distance = globalParams.distance + globalParams.verticalSpeed * deltaTime/5000000
end

function character:throw(direction, screenGroup)
    if(character.canThrow) then
        character.canThrow = false
        local drug = drugsFactory.createDrug(direction, {startPos[1]+character.x, startPos[2]+character.y})
        screenGroup:insert(drug)
        timer.performWithDelay(globalParams.throwSpeed, character.realeseThrow)
    end
end

--character

return character

