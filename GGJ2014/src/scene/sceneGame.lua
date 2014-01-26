------------------------------------------------------
--  GLOWNA SCENA GRY
-----------------------------------------------------
local globalParams = require("src.data.dataGlobalParams")
local storyboard = require( "storyboard" )
local gui = require("src.ui.uiItems")

local roadFactory = require("src.unit.unitRoadFactory")
local candymanFactory = require("src.unit.unitCandymanFactory")
local obstacleFactory = require("src.unit.unitObstacleFactory")

local physics = require( "physics" )
--physics.setDrawMode( "hybrid" )
physics.start()
physics.setGravity(0, 0)

local logicCollisions = require("src.logic.logicCollisions")
local logicGame = require("src.logic.logicGame")

local scene = storyboard.newScene()
local screenGroup

scene.data = {}
scene.obstacleList = {}
scene.looseState = false

local characterFactory = require("src.unit.unitCharacterFactory")
local updatedMenu = nil

-- timers
local roadTimer = nil
local candymanTimers = nil
local obstacleTimers = nil

---------------------------------------------------
--   LOCALS         
---------------------------------------------------
local function onLeftClick( event )
    if(event.phase == "began") then
        scene.character:setMove(-1)
    elseif(event.phase == "ended" or event.phase == "cancelled") then
        scene.character:setMove(0)
    end
    
    --character:moveLeft()
end

local function onRightClick( event )
    if(event.phase == "began") then
        scene.character:setMove(1)
    elseif(event.phase == "ended" or event.phase == "cancelled") then
        scene.character:setMove(0)
    end
    
    --character:moveRight()
end

local function onThrowLeftClick( event )
    scene.character:throw(-1, screenGroup)
end

local function onThrowRightClick( event )
    scene.character:throw(1, screenGroup)
end

local function onLoose()
    print("onLoose")
    
    scene.looseState = true
    
    --timer.cancel(roadTimer);
    timer.cancel(candymanTimers);
    timer.cancel(obstacleTimers);
    
    globalParams.verticalSpeed = 0
    scene.obstacleList = {}
    
    screenGroup:removeSelf()
    screenGroup = display.newGroup()
    scene.view:insert(screenGroup)
    updatedMenu = nil
    print("myk")
    
    scene:createGame()
    scene:updateUI()
end

local function onRestart()
    scene.looseState = false
    
    globalParams.reset()
    
    scene:createTimers()
end

local function onEnterFrame( event )
    if(scene.looseState == false) then
        scene:updateUI()

        scene:moveRoad(event.time)

        globalParams.updateSkillTime(event.time)
        scene.character:move(event.time)
        logicGame.checkLooseCondition(onLoose, onRestart)
        logicGame.nextLevel()
    end
end

local function onCollision(event)
    logicCollisions.collision(event)
end

local function onKeyEvent(event)
    print(event.keyName)
end

local function onUpTouch(event)
    if(event.phase == "ended" or event.phase == "cancelled") then
        scene.character:setMove(0)
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
end

------------
function scene:enterScene( event )
    globalParams.reset()
    
-- game
    scene:createGame()
    
-- GUI
    scene:updateUI()
    
-- timers
    scene:createTimers()
    
    Runtime:addEventListener("enterFrame", onEnterFrame)
    Runtime:addEventListener("collision", onCollision)
end

function scene:createGame()
    
-- background
    local road1, road2 = roadFactory.createRoad()
    print("1 " .. road1.x .. " " .. road1.y )
    print("2 " .. road2.x .. " " .. road2.y )
   screenGroup:insert(road1)
   screenGroup:insert(road2)
   
   scene.road1 = road1
   scene.road2 = road2
    
-- PLAYER
    scene.character = characterFactory.new()
    screenGroup:insert(scene.character)
end

function scene:createTimers()
    
    candymanTimers = timer.performWithDelay(globalParams.verticalSpeed, scene.createCandyman)
    
    obstacleTimers = timer.performWithDelay(globalParams.verticalSpeed/2, scene.createObstacle)
    
end

function scene.createCandyman()
    local candyman = candymanFactory.getRandomCandyman()
    if candyman then
        screenGroup:insert(candyman)
        
        table.insert(scene.obstacleList, candyman)
    end
    candymanTimers = timer.performWithDelay(globalParams.verticalSpeed, scene.createCandyman)
end

function scene.createObstacle()
    local obstacle = obstacleFactory.getRandomObstacle()
    if obstacle then
        screenGroup:insert(obstacle)
        
        table.insert(scene.obstacleList, obstacle)
    end
    obstacleTimers = timer.performWithDelay(globalParams.verticalSpeed/2, scene.createObstacle)
end

local lastRoadUpdateTime = 0
function scene:moveRoad(updateTime)
    if(lastRoadUpdateTime == 0) then
        lastRoadUpdateTime = updateTime
        return
    end
    
    local deltaTime = updateTime - lastRoadUpdateTime
    lastRoadUpdateTime = updateTime
    local dist = globalParams.verticalSpeed * deltaTime/10000
    
    scene.road1.y = scene.road1.y + dist
    if(scene.road1.y > 480) then
        scene.road1.y = -960
    end
    
    scene.road2.y = scene.road2.y + dist
    if(scene.road2.y > 480) then
        scene.road2.y = -960
    end
    
    for i = 1, #scene.obstacleList do 
        local tmp = scene.obstacleList[i]
        if(tmp ~= nil and tmp.y ~= nil) then
            tmp.y = tmp.y + dist
            if(tmp.y > 480) then
                table.remove(scene.obstacleList, i)
                tmp:removeSelf()
                i = i - 1
            end
        end
    end
end

function scene:updateUI()
    if updatedMenu ~= nil then
        updatedMenu:removeSelf()
    end
   -- NEED TO UPDATE GUI
    updatedMenu = display.newGroup()
    updatedMenu:toFront()
    
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
        "gfx/bad_slider_back.png", "gfx/indicator.jpg", globalParams.badLevel)
    updatedMenu:insert(badLevelBar)
    
    local pointsText = gui.newSimpleText({10, 40}, 25, globalParams.points .. "$")
    updatedMenu:insert(pointsText)
    local pointsText = gui.newSimpleText({10, 60}, 25, string.format("%.2f", globalParams.distance) .. "m")
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
function scene:exitScene( event )
    Runtime:addEventListener( "enterFrame", nil )
    Runtime:addEventListener( "collision", nil )
    Runtime:addEventListener( "key", nil );
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
--Runtime:addEventListener("touch", onUpTouch)

return scene
