local drugsFactory = require("src.unit.unitDrugsFactory")
local gui = require("src.ui.uiItems")

local character = display.newGroup()

local startPos = {display.contentCenterX, display.contentHeight - 70*2}

-- wyswietlanie
local dispalyObject = gui.newImageRect("gfx/character.jpg", startPos, {40, 70})
character:insert(dispalyObject)

-- poruszanie
character.canMove = true
character.verticalSpeed = 10
character.horizontalSpeed = 500
character.moveStep = display.contentWidth/6

function character.realeseMove()
    character.canMove = true
end

function character:moveLeft()
    if(character.canMove) then
        character.canMove = false
        transition.to( character, 
            { time=character.horizontalSpeed, x=character.x - character.moveStep, onComplete=character.realeseMove} )
    end
end

function character:moveRight()
    if(character.canMove) then
        character.canMove = false
        transition.to( character, 
            { time=character.horizontalSpeed, x=character.x + character.moveStep, onComplete=character.realeseMove} )
    end
end

function character:throw(direction)
    print("1 " .. character.x .. " " .. character.y)
    print("2 " .. startPos[1] .. " " .. startPos[2])
    print("3 " .. startPos[1]+character.x .. " " .. startPos[2]+character.y)
    local drug = drugsFactory.createDrug(direction, startPos)
    character:insert(drug)
end

function character:move()
    
end
--character

return character

