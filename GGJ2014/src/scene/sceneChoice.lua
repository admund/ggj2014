local storyboard = require( "storyboard" )
local globalParams = require("src.data.dataGlobalParams")
local gui = require("src.ui.uiItems")

local scene = storyboard.newScene()
local screenGroup

scene.customData = {}
scene.onListener = nil

---------------------------------------------------
--   LOCALS
---------------------------------------------------

---------- KILL THE POPUP
local function onLeftClick( event )
    globalParams.badMode = false
    
    --storyboard.hideOverlay( true, "zoomOutInFade", 250 )
    storyboard.gotoScene("src.scene.sceneGame", "fromTop", 250)
end

local function onRightClick( event )
    globalParams.badMode = true
    
    --storyboard.hideOverlay( true, "zoomOutInFade", 250 )
    storyboard.gotoScene("src.scene.sceneGame", "fromTop", 250)
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
    
    local fontSize = 12
    local leftButton = gui.newSimpleTextButton({display.contentWidth/4, display.contentHeight/2}, {100, 100},
            "Want to \ndistribute Candy", fontSize, onLeftClick)
    screenGroup:insert(leftButton)
    
    local rightButton = gui.newSimpleTextButton({display.contentWidth*3/4, display.contentHeight/2}, {100, 100},
            "Want to \ndistribute \"Candy\" :>", fontSize, onRightClick)
    screenGroup:insert(rightButton)
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
