local globalParams = require("src.data.dataGlobalParams")
local drugsFactory = require("src.unit.unitDrugsFactory")
local gui = require("src.ui.uiItems")

local character = display.newGroup()

local startPos = {display.contentCenterX, display.contentHeight - 70*2}

-- wyswietlanie
local dispalyObject = gui.newImageRect("gfx/character.jpg", startPos, {40, 70})
character:insert(dispalyObject)

-- rzucanie
character.canThrow = true

-- poruszanie
character.canMove = true
character.position = 0

-- game
character.life = 100
character.points = 0
character.distance = 0

-- functions
function character.realeseMove()
    character.canMove = true
end

function character.realeseThrow()
    character.canThrow = true
end

function character:moveLeft()
    if(character.canMove and character.position > -3) then
        character.canMove = false
        character.position = character.position - 1
        transition.to( character, { time=globalParams.horizontalSpeed, 
                x=character.x - globalParams.horizontalStep, onComplete=character.realeseMove} )
    end
end

function character:moveRight()
    if(character.canMove and character.position < 3) then
        character.canMove = false
        character.position = character.position + 1
        transition.to( character, { time=globalParams.horizontalSpeed, 
                x=character.x + globalParams.horizontalStep, onComplete=character.realeseMove} )
    end
end

function character:throw(direction)
    if(character.canThrow) then
        character.canThrow = false
        local drug = drugsFactory.createDrug(direction, startPos)
        character:insert(drug)
        timer.performWithDelay(globalParams.throwSpeed, character.realeseThrow)
    end
end

--character

return character

