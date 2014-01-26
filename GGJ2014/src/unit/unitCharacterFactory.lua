local globalParams = require("src.data.dataGlobalParams")
local drugsFactory = require("src.unit.unitDrugsFactory")
local gui = require("src.ui.uiItems")
local physics = require("physics")

local startPos = {display.contentCenterX, display.contentHeight - 70*2}

local class = {}
function class.new()
    local character = display.newGroup()
    -- wyswietlanie
    local displayObject = gui.newImageRect("gfx/potato_char.png", startPos, {40, 70})
    displayObject.name = "character"
    physics.addBody(displayObject, "dynamic", {filter={ categoryBits = 8, maskBits = 4 }})
    displayObject.isSensor = true
    character:insert(displayObject)
    character.displayObject = displayObject

    function character.displayObject.hop()
        transition.to(character.displayObject, {time=100, xScale = character.displayObject.xScale*1.2, yScale = 1.2})
        transition.to(character.displayObject, {time=400, delay=100, xScale = character.displayObject.xScale*1, yScale = 1})
    end
    
    function character.displayObject.small()
        transition.to(character.displayObject, {time=100, xScale = character.displayObject.xScale*0.8, yScale = 0.8})
        transition.to(character.displayObject, {time=400, delay=100, xScale = character.displayObject.xScale*1, yScale = 1})
    end

    -- rzucanie
    character.canThrow = true

    -- poruszanie
    character.canMove = true
    character.position = 0
    character.moveDirection = 0
    character.seeDirection = -1
    character.lastMoveTime = 0

    -- functions
    function character.realeseMove()
        character.canMove = true
    end

    function character.realeseThrow()
        character.canThrow = true
    end

    function character:setMove(direction)
        if(character.seeDirection ~= direction and direction ~= 0) then
            character.seeDirection = direction
            character.displayObject:scale(-1, 1)
        end
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
        --local dest = startPos[1] + character.dispalyObject.x + dist
        if(globalParams.steringModifType == 1) then
            dist = dist + dist
        elseif(globalParams.steringModifType == -1) then
            dist = 0
        end

        local dest = character.displayObject.x + dist

        if(dest < display.contentWidth*0.2) then
            dest = display.contentWidth*0.2
        elseif(dest > display.contentWidth*0.8) then
            dest = display.contentWidth*0.8
        end

        character.displayObject.x = dest-- - startPos[1]
        --transition.to( character, { time=1, x=dest})--, onComplete=character.realeseMove} )
    end

    function character:throw(direction, screenGroup)
        if(character.canThrow) then
            character.canThrow = false
            --local drug = drugsFactory.createDrug(direction, {startPos[1]+character.x, startPos[2]+character.y})
            local drug = drugsFactory.createDrug(direction, {character.displayObject.x, character.displayObject.y})
            screenGroup:insert(drug)
            timer.performWithDelay(globalParams.throwSpeed, character.realeseThrow)
        end
    end

    --character

    return character
end

return class

