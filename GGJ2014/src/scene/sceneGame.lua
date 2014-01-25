------------------------------------------------------
--  GLOWNA SCENA GRY
-----------------------------------------------------
local globalParams = require("src.data.dataGlobalParams")
local storyboard = require( "storyboard" )
local gui = require("src.ui.uiItems")
local roadFactory = require("src.unit.unitRoadFactory")

local scene = storyboard.newScene()
local screenGroup

scene.data = {}
scene.onListener = nil

local character = require("src.unit.unitCharacter")
local updatedMenu = nil

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

local function enterScene()
    scene:updateUI()
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
    local guiAlpha = 0.7
    local leftButton = gui.newSimpleButton({buttonSize[1]/2, display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/arrow_left.jpg", onLeftClick)
    leftButton.alpha = guiAlpha
    screenGroup:insert(leftButton)
    
    local rightButton = gui.newSimpleButton({display.contentWidth-buttonSize[1]/2, display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/arrow_right.jpg", onRightClick)
    rightButton.alpha = guiAlpha
    screenGroup:insert(rightButton)
    
    local throwLeftButton = gui.newSimpleButton({display.contentCenterX-buttonSize[1], display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/throw_button.jpg", onThrowLeftClick)
    throwLeftButton.alpha = guiAlpha
    screenGroup:insert(throwLeftButton)
    
    local throwRightButton = gui.newSimpleButton({display.contentCenterX+buttonSize[1], display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/throw_button.jpg", onThrowRightClick)
    throwRightButton.alpha = guiAlpha
    screenGroup:insert(throwRightButton)
    
    screenGroup:insert(character)
    
-- NEED TO UPDATE GUI
    updatedMenu = display.newGroup()
    
    local lifeBar = gui.newHorizontalSlider({display.contentCenterX, 10}, {display.contentCenterX, 30}, 
            "gfx/slider_background.jpg", "gfx/slider_fill.jpg", character.life, globalParams.maxLife)
    lifeBar.anchorX = 0
    lifeBar.anchorY = 0
    updatedMenu:insert(lifeBar)
    
    local pointsText = gui.newSimpleText({0, 0}, 30, "Pts: " .. character.points)
    local pointsText = gui.newSimpleText({0, 35}, 30, "Dist: " .. character.distance)
    
    screenGroup:insert(updatedMenu)
end

function scene:updateUI()
    updatedMenu:removeSelf()
   
    updatedMenu = display.newGroup()
    
    local lifeBar = gui.newHorizontalSlider({display.contentCenterX, 0}, {display.contentCenterX, 30}, 
            "gfx/slider_background.jpg", "gfx/slider_fill.jpg", character.life, globalParams.maxLife)
    updatedMenu:insert(lifeBar)
    
    screenGroup:insert(updatedMenu)
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
Runtime:addEventListener( "enterFrame", enterScene )

return scene
