------------------------------------------------------
--  GLOWNA SCENA GRY
-----------------------------------------------------
local globalParams = require("src.data.dataGlobalParams")
local storyboard = require( "storyboard" )
local gui = require("src.ui.uiItems")
local utilsAudio = require("src.utils.utilsAudio")

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
local obstacleList = {}
local looseState = false
local lastRoadUpdateTime = 0

local character = nil
--local road1 = nil
--local road2 = nil

local characterFactory = require("src.unit.unitCharacterFactory")
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
end

local function onRightClick( event )
    if(event.phase == "began") then
        character:setMove(1)
    elseif(event.phase == "ended" or event.phase == "cancelled") then
        character:setMove(0)
    end
end

local function onThrowLeftClick( event )
    character:throw(-1, screenGroup)
end

local function onThrowRightClick( event )
    character:throw(1, screenGroup)
end

local function onLoose()
    looseState = true
    
    utilsAudio.playLoose()
    
    --timer.cancel(roadTimer);
    timer.cancel(candymanTimers);
    timer.cancel(obstacleTimers);
    
    lastRoadUpdateTime = 0
    globalParams.verticalSpeed = 0
    obstacleList = {}
    
    screenGroup:removeSelf()
    screenGroup = display.newGroup()
    scene.view:insert(screenGroup)
    --updatedMenu = nil
    
    scene:createGame()
    --scene:updateGUI()
    scene:createGUI()
end

local function onRestart()
    globalParams.reset()
    
    scene:createTimers()
    
    looseState = false
end

local function onEnterFrame( event )
    if(looseState == false) then
        scene:updateGUI()

        scene:moveRoad(event.time)

        globalParams.updateSkillTime(event.time)
        character:move(event.time)
        logicGame.nextLevel(obstacleList)
        logicGame.checkLooseCondition(onLoose, onRestart)
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
end

------------
function scene:enterScene( event )
    globalParams.reset()
    
-- game
    scene:createGame()
    
-- GUI
    scene:createGUI()
    --scene:updateGUI()
    
-- timers
    scene:createTimers()
    
    Runtime:addEventListener("enterFrame", onEnterFrame)
    Runtime:addEventListener("collision", onCollision)
    Runtime:addEventListener("key", onKeyEvent)
end

function scene:createGame()
    
-- background
   --road1, road2 = roadFactory.createRoad()
   --screenGroup:insert(road1)
   local road2 = display.newImageRect("gfx/road2.jpg", 320, 480)
   road2.anchorX = 0
   road2.anchorY = 0
   screenGroup:insert(road2)
    
-- PLAYER
    character = characterFactory.new()
    screenGroup:insert(character)
end

function scene:createTimers()
    --candymanTimers = timer.performWithDelay(globalParams.verticalSpeed, scene.createCandyman)
    --obstacleTimers = timer.performWithDelay(globalParams.verticalSpeed/2, scene.createObstacle)
    
    candymanTimers = timer.performWithDelay(1000, scene.createCandyman)
    obstacleTimers = timer.performWithDelay(500, scene.createObstacle)
end

function scene.createCandyman()
    local candyman = candymanFactory.getRandomCandyman()
    if candyman then
        screenGroup:insert(candyman)
        
        table.insert(obstacleList, candyman)
    end
    candymanTimers = timer.performWithDelay(globalParams.verticalSpeed, scene.createCandyman)
end

function scene.createObstacle()
    local obstacle = obstacleFactory.getRandomObstacle()
    if obstacle then
        screenGroup:insert(obstacle)
        
        table.insert(obstacleList, obstacle)
    end
    obstacleTimers = timer.performWithDelay(globalParams.verticalSpeed/2, scene.createObstacle)
end

function scene:moveRoad(updateTime)
    if(lastRoadUpdateTime == 0) then
        lastRoadUpdateTime = updateTime
        return
    end
    
    local deltaTime = updateTime - lastRoadUpdateTime
    lastRoadUpdateTime = updateTime
    local dist = globalParams.verticalSpeed * deltaTime/10000
    
    -- add distance
    globalParams.distance = globalParams.distance + dist/500
--    
--    road1.y = road1.y + dist
--    if(road1.y > 480) then
--        road1.y = -960
--    end
--    
--    road2.y = road2.y + dist
--    if(road2.y > 480) then
--        road2.y = -960
--    end
    
    for i = 1, #obstacleList do 
        local tmp = obstacleList[i]
        if(tmp ~= nil and tmp.y ~= nil) then
            --tmp.y = tmp.y + dist
            if(tmp.y > 520) then
                --print("del " .. #obstacleList)
                table.remove(obstacleList, i)
                tmp:removeSelf()
                i = i - 1
            end
        end
    end
end

function scene:createGUI()
--function scene:updateGUI()
    updatedMenu = display.newGroup()
    
    local buttonSize = {60, 60}
    -- gui
    local guiAlpha = 0.7
    local leftButton = gui.newSimpleButton({buttonSize[1]/2, display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/arrow_left.png", nil, onLeftClick)
    leftButton.alpha = guiAlpha
    updatedMenu:insert(leftButton)
    updatedMenu.leftButton = leftButton
    
    local rightButton = gui.newSimpleButton({display.contentWidth-buttonSize[1]/2, display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/arrow_right.png", nil, onRightClick)
    rightButton.alpha = guiAlpha
    updatedMenu:insert(rightButton)
    updatedMenu.rightButton = rightButton
    
    local throwLeftButton = gui.newSimpleButton({display.contentCenterX-buttonSize[1], display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/throw_button.png", onThrowLeftClick)
    throwLeftButton.alpha = guiAlpha
    updatedMenu:insert(throwLeftButton)
    updatedMenu.throwLeftButton = throwLeftButton
    
    local throwRightButton = gui.newSimpleButton({display.contentCenterX+buttonSize[1], display.contentHeight-buttonSize[2]/2},
        buttonSize, "gfx/throw_button.png", onThrowRightClick)
    throwRightButton.alpha = guiAlpha
    updatedMenu:insert(throwRightButton)
    updatedMenu.throwRightButton = throwRightButton
    
    local lifeBar = gui.newHorizontalSliderFill({display.contentCenterX + 10, 10}, {display.contentCenterX-20, 30}, 
            "gfx/slider_background.jpg", "gfx/slider_fill.jpg", globalParams.life, globalParams.maxLife)
    updatedMenu:insert(lifeBar)
    updatedMenu.lifeBar = lifeBar
    
    local badLevelBar = gui.newHorizontalSliderIndicator({10, 10}, {display.contentCenterX-20, 30}, 
        "gfx/bad_slider_back.png", "gfx/skull.png", globalParams.badLevel)
    updatedMenu:insert(badLevelBar)
    updatedMenu.badLevelBar = badLevelBar
    
    local pointsText = gui.newSimpleText({10, 40}, 25, globalParams.points .. "$")
    updatedMenu:insert(pointsText)
    updatedMenu.pointsText = pointsText
    
    local distanceText = gui.newSimpleText({10, 60}, 25, string.format("%.2f", globalParams.distance) .. "m")
    updatedMenu:insert(distanceText)
    updatedMenu.distanceText = distanceText
    
    local sheetSettings = {
     width = 40,
     height = 40,
     numFrames = 3
    }
    local sequences = {
     { name="1", start=1, count=1, time= 80000},
     { name="2", start=2, count=1, time= 80000},
     { name="3", start=3, count=1, time= 80000}
    }
    local iconSize = 20
    local scale = 0.5
    local goldIconSheet = graphics.newImageSheet("gfx/sheet_$.png", sheetSettings)
    local goldModifIcon = display.newSprite(goldIconSheet, sequences)
    goldModifIcon.x = display.contentWidth-iconSize
    goldModifIcon.y = display.contentCenterY
    goldModifIcon:scale(scale, scale)
    goldModifIcon:setSequence("3")
    updatedMenu:insert(goldModifIcon)
    updatedMenu.goldModifIcon = goldModifIcon
    
    local dmgIconSheet = graphics.newImageSheet("gfx/sheet_def.png", sheetSettings)
    local dmgModifIcon = display.newSprite(dmgIconSheet, sequences)
    dmgModifIcon.x = display.contentWidth-iconSize
    dmgModifIcon.y = display.contentCenterY + iconSize
    dmgModifIcon:scale(scale, scale)
    dmgModifIcon:setSequence("3")
    updatedMenu:insert(dmgModifIcon)
    updatedMenu.dmgModifIcon = dmgModifIcon
    
    local steringIconSheet = graphics.newImageSheet("gfx/sheet_ster.png", sheetSettings)
    local steringModifIcon = display.newSprite(steringIconSheet, sequences)
    steringModifIcon.x = display.contentWidth-iconSize
    steringModifIcon.y = display.contentCenterY + 2*iconSize
    steringModifIcon:scale(scale, scale)
    steringModifIcon:setSequence("3")
    updatedMenu:insert(steringModifIcon)
    updatedMenu.steringModifIcon = steringModifIcon
    
    screenGroup:insert(updatedMenu)
end

function scene:updateGUI()
    updatedMenu.lifeBar:updateIndicatorPos(globalParams.life, globalParams.maxLife)
    updatedMenu.badLevelBar:updateIndicatorPos(globalParams.badLevel)
    
    updatedMenu.pointsText.text = globalParams.points .. "$"
    updatedMenu.distanceText.text = string.format("%.2fm", globalParams.distance)
    
    local frame = nil
    local pts = globalParams.pointsModif
    if(pts == 2) then
        frame = "2"
    elseif(pts == 0.5) then
        frame = "1"
    else
        frame = "3"
    end
    updatedMenu.goldModifIcon:setSequence(frame)
    
    pts = globalParams.dmgModif
    if(pts == 0.5) then
        frame = "2"
    elseif(pts == 2) then
        frame = "1"
    else
        frame = "3"
    end
    updatedMenu.dmgModifIcon:setSequence(frame)
    
    pts = globalParams.steringModifType
    if(pts == 1) then
        frame = "2"
    elseif(pts == -1) then
        frame = "1"
    else
        frame = "3"
    end
    updatedMenu.steringModifIcon:setSequence(frame)
    updatedMenu:toFront()
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
