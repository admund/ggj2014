------------------------------------------------------
--  GLOWNA SCENA GRY
-----------------------------------------------------

local storyboard = require( "storyboard" )
local gui = require("src.ui.uiItems")
local roadFactory = require("src.unit.unitRoadFactory")

local scene = storyboard.newScene()
local screenGroup

scene.data = {}
scene.onListener = nil

local character = require("src.unit.unitCharacter")

---------------------------------------------------
--   LOCALS
---------------------------------------------------

---------- KILL THE POPUP
local function onLeftClick( event )
    character:moveLeft()
end

local function onRightClick( event )
    character:moveRight()
end

local function onThrowLeftClick( event )
    character:throw(-1)
end

local function onThrowRightClick( event )
    character:throw(1)
end

---------------------------------------------------
--   SCENE
---------------------------------------------------

-----------------------
function scene:createScene( event )
    
    -- scene group
    screenGroup = display.newGroup()
    
    scene.view:insert(screenGroup)
    
-- background
    local road1 = roadFactory.createRoad({0, -480})
    screenGroup:insert(road1)
    local road2 = roadFactory.createRoad({0, 0})
    screenGroup:insert(road2)
    
    local buttonSize = {60, 60}
    -- gui
    local leftButton = gui.newSimpleButton({buttonSize[1]/2, display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/arrow_left.jpg", onLeftClick)
    screenGroup:insert(leftButton)
    
    local rightButton = gui.newSimpleButton({display.contentWidth-buttonSize[1]/2, display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/arrow_right.jpg", onRightClick)
    screenGroup:insert(rightButton)
    
    local throwLeftButton = gui.newSimpleButton({display.contentCenterX-buttonSize[1], display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/throw_button.jpg", onThrowLeftClick)
    
    local throwLeftButton = gui.newSimpleButton({display.contentCenterX+buttonSize[1], display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/throw_button.jpg", onThrowRightClick)
    
    screenGroup:insert(character)
end


------------
function scene:willEnterScene( event )
    
end

------------
function scene:enterScene( event )
    
end

------------
function scene:exitScene( event )
    
end

------------
function scene:didExitScene( event )
    
end

-----------------------
function scene:destroyScene( event )
    
end

----------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )
scene:addEventListener( "didExitScene", scene )

return scene
