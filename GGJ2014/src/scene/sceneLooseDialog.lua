local storyboard = require( "storyboard" )
local gui = require("src.ui.uiItems")
local globalParams = require("src.data.dataGlobalParams")

local scene = storyboard.newScene()
local screenGroup

scene.customData = {}
scene.onRestart = nil

---------------------------------------------------
--   LOCALS
---------------------------------------------------

---------- KILL THE POPUP
local function onRestartClick( event )
    if(scene.onRestart) then
        scene.onRestart()
    end
    storyboard.hideOverlay(true, "zoomOutInFade", 250)
    --storyboard.gotoScene("src.scene.sceneGame", "fromTop", 250)
end

local function onMainMenuClick( event )
    --storyboard.hideOverlay( true, "zoomOutInFade", 250 )
    --storyboard.gotoScene("src.scene.sceneGame", "fromTop", 250)
end

---------------------------------------------------
--   SCENE
---------------------------------------------------

-----------------------
function scene:createScene( event )
    
    -- scene group
    screenGroup = display.newGroup()
    scene.view:insert(screenGroup)
    
    local back = gui.newImageRect("gfx/back.jpg", {display.contentCenterX, display.contentCenterY}, {display.contentWidth-50, display.contentHeight-50})
    screenGroup:insert(back)
    
    local fontSize = 20
    local leftButton = gui.newSimpleTextButton({display.contentCenterX, display.contentHeight/2}, {250, 100},
            "Play Again!!!111ONE", fontSize, onRestartClick)
    screenGroup:insert(leftButton)
    
    local rightButton = gui.newSimpleTextButton({display.contentCenterX, display.contentHeight*3/4}, {250, 100},
            "Back to Main Menu", fontSize, onMainMenuClick)
    screenGroup:insert(rightButton)
end

------------
function scene:willEnterScene( event )
    
end

------------
function scene:enterScene( event )
    local text = "You earn " .. globalParams.points .. "$\n"
        .. " And travel " .. globalParams.distance .. "m\n"
        .. " Play Again - improve result!!!"
    local resultText = gui.newSimpleText({display.contentCenterX, display.contentHeight/4}, 20, text, 0.5, 0.5)
    screenGroup:insert(resultText)
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


