------------------------------------------------------
--  GLOWNA SCENA GRY
-----------------------------------------------------
local globalParams = require("src.data.dataGlobalParams")
local storyboard = require( "storyboard" )
local gui = require("src.ui.uiItems")

local roadFactory = require("src.unit.unitRoadFactory")
local candymanFactory = require("src.unit.unitCandymanFactory")
local obstacleFactory = require("src.unit.unitObstacleFactory")

print("physics.start")
local physics = require( "physics" )
--physics.setDrawMode( "hybrid" )
physics.start()
physics.setGravity(0, 0)

local logicCollisions = require("src.logic.logicCollisions")

local scene = storyboard.newScene()
local screenGroup

scene.data = {}

local character = require("src.unit.unitCharacter")
local updatedMenu = nil

-- timers
local candymanTimers = nil
local obstacleTimers = nil

---------------------------------------------------
--   LOCALS         
---------------------------------------------------
local function onLeftClick( event )
    if(event.phase == "began") then
        character:setMove(-1)
    elseif(event.phase == "ended" or event.phase == "cancelled") then
        character:setMove(0)
    end
    
    --character:moveLeft()
end

local function onRightClick( event )
    if(event.phase == "began") then
        character:setMove(1)
    elseif(event.phase == "ended" or event.phase == "cancelled") then
        character:setMove(0)
    end
    
    --character:moveRight()
end

local function onThrowLeftClick( event )
    character:throw(-1, screenGroup)
end

local function onThrowRightClick( event )
    character:throw(1, screenGroup)
end

local function onEnterScene( event )
    scene:updateUI()
    globalParams.updateSkillTime(event.time)
    character:move(event.time)
end

local function onCollision(event)
    logicCollisions.collision(event)
end

local function onUpTouch(event)
    if(event.phase == "ended" or event.phase == "cancelled") then
        character:setMove(0)
    end
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
    
-- PLAYER
    screenGroup:insert(character)
    
-- GUI
    scene:updateUI()

-- timers
    scene:createTimers()
end

function scene:createTimers()
    candymanTimers = timer.performWithDelay(globalParams.verticalSpeed, scene.createCandyman)
    
    obstacleTimers = timer.performWithDelay(globalParams.verticalSpeed/2, scene.createObstacle)
    
    --print("physics.start")
    --physics.start()
end

function scene.createCandyman()
    local candyman = candymanFactory.getRandomCandyman()
    if candyman then
        screenGroup:insert(candyman)
    end
    candymanTimers = timer.performWithDelay(globalParams.verticalSpeed, scene.createCandyman)
end

function scene.createObstacle()
    local obstacle = obstacleFactory.getRandomObstacle()
    if obstacle then
        screenGroup:insert(obstacle)
    end
    obstacleTimers = timer.performWithDelay(globalParams.verticalSpeed/2, scene.createObstacle)
end

function scene:updateUI()
    if updatedMenu ~= nil then
        updatedMenu:removeSelf()
    end
   
    updatedMenu = display.newGroup()
    updatedMenu:toFront()
    
    -- NEED TO UPDATE GUI
    updatedMenu = display.newGroup()
    
    local buttonSize = {60, 60}
    -- gui
    local guiAlpha = 0.7
    local leftButton = gui.newSimpleButton({buttonSize[1]/2, display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/arrow_left.jpg", nil, onLeftClick)
    leftButton.alpha = guiAlpha
    updatedMenu:insert(leftButton)
    
    local rightButton = gui.newSimpleButton({display.contentWidth-buttonSize[1]/2, display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/arrow_right.jpg", nil, onRightClick)
    rightButton.alpha = guiAlpha
    updatedMenu:insert(rightButton)
    
    local throwLeftButton = gui.newSimpleButton({display.contentCenterX-buttonSize[1], display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/throw_button.jpg", onThrowLeftClick)
    throwLeftButton.alpha = guiAlpha
    updatedMenu:insert(throwLeftButton)
    
    local throwRightButton = gui.newSimpleButton({display.contentCenterX+buttonSize[1], display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/throw_button.jpg", onThrowRightClick)
    throwRightButton.alpha = guiAlpha
    updatedMenu:insert(throwRightButton)
    
    local lifeBar = gui.newHorizontalSliderFill({display.contentCenterX + 10, 10}, {display.contentCenterX-20, 30}, 
            "gfx/slider_background.jpg", "gfx/slider_fill.jpg", globalParams.life, globalParams.maxLife)
    updatedMenu:insert(lifeBar)
    
    local badLevelBar = gui.newHorizontalSliderIndicator({10, 10}, {display.contentCenterX-20, 30}, 
        "gfx/slider_background.jpg", "gfx/indicator.jpg", globalParams.badLevel)
    updatedMenu:insert(badLevelBar)
    
    local pointsText = gui.newSimpleText({10, 40}, 25, globalParams.points .. "$")
    updatedMenu:insert(pointsText)
    local pointsText = gui.newSimpleText({10, 60}, 25, globalParams.distance .. "m")
    updatedMenu:insert(pointsText)
    
    local iconSize = 20
    local pointsGfx = nil
    if(globalParams.pointsModif == 2) then
        pointsGfx = "gfx/good_$.jpg"
    elseif(globalParams.pointsModif == 0.5) then
        pointsGfx = "gfx/bad_$.jpg"
    else
        pointsGfx = "gfx/back.jpg"
    end
    local goldModifIcon = gui.newImageRect(pointsGfx, 
        {display.contentWidth-iconSize, display.contentCenterY}, {iconSize, iconSize})
    updatedMenu:insert(pointsText)
    
    local dmgGfx = nil
    if(globalParams.dmgModif == 0.5) then
        dmgGfx = "gfx/good_def.jpg"
    elseif(globalParams.dmgModif == 2) then
        dmgGfx = "gfx/bad_def.jpg"
    else
        dmgGfx = "gfx/back.jpg"
    end
    local dmgModifIcon = gui.newImageRect(dmgGfx, 
        {display.contentWidth-iconSize, display.contentCenterY + iconSize}, {iconSize, iconSize})
    updatedMenu:insert(dmgModifIcon)
    
    local steringGfx = nil
    if(globalParams.steringModifType == 1) then
        steringGfx = "gfx/good_ster.jpg"
    elseif(globalParams.steringModifType == -1) then
        steringGfx = "gfx/bad_ster.jpg"
    else
        steringGfx = "gfx/back.jpg"
    end
    local steringModifIcon = gui.newImageRect(steringGfx, 
        {display.contentWidth-iconSize, display.contentCenterY+iconSize*2}, {iconSize, iconSize})
    updatedMenu:insert(steringModifIcon)
    
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
Runtime:addEventListener( "enterFrame", onEnterScene )
Runtime:addEventListener( "collision", onCollision )
Runtime:addEventListener("touch", onUpTouch)

return scene
