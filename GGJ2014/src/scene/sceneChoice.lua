------------------------------------------------------
--  GLOWNA SCENA GRY
-----------------------------------------------------

local storyboard = require( "storyboard" )

local scene = storyboard.newScene()
local screenGroup

scene.customData = {}
scene.onListener = nil

---------------------------------------------------
--   LOCALS
---------------------------------------------------

---------- KILL THE POPUP
local function onLeftClick( event )
    
end

local function onRightClick( event )
    
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
