
local storyboard = require( "storyboard" )
local gui = require("src.ui.uiItems")
local globalParams = require("src.data.dataGlobalParams")

local scene = storyboard.newScene()
local screenGroup

scene.isShowCredits = false

local pyra = nil

---------------------------------------------------
--   LOCALS
---------------------------------------------------

---------- KILL THE POPUP
local function onStartGame( event )
    if( scene.isShowCredits == false) then
        storyboard.gotoScene("src.scene.sceneGame", "fade", 300)
    end
end

local function onCredits( event )
    if scene.isShowCredits == false then
        scene.isShowCredits = true
        scene.showCredits()
    end
end

local function onHideCredits( event )
    transition.to(scene.credits, {time=500, y=-500, onComplete=scene.credits.removeSelf})
    scene.canShowCredits = false
end

---------------------------------------------------
--   SCENE
---------------------------------------------------

function scene.showCredits()
    local credits = display.newGroup()
    
    local fontSize = 20
    local transTime = 1000
    local potatoSize = {60, 40}
    
    local firstGroup = display.newGroup()
    local back = display.newRect(-400, 0, 320, 150)
    back.anchorX = 0; back.anchorY = 0;
    back.fill = {0.3, 0.4, 0.8}
    firstGroup:insert(back)
    local firsMR = gui.newImageRect("gfx/potato_mr.png", {-40, 70} , potatoSize)
    firstGroup:insert(firsMR)
    local creditsText = gui.newSimpleTextWithBackground({-330, 70}, 60, "Credits")--, {0.3, 0.4, 0.8})
    firstGroup:insert(creditsText)
    transition.to(firstGroup, {time=transTime, x=400})
    
    local secGroup = display.newGroup()
    local secBack = display.newRect(400, 150, 320, 100)
    secBack.anchorX = 0; secBack.anchorY = 0;
    secBack.fill = {0.3, 0.4, 0.8}
    secGroup:insert(secBack)
    local secMR = gui.newImageRect("gfx/potato_mr.png", {360, 200} , potatoSize)
    secMR:scale(-1, 1)
    secGroup:insert(secMR)
    local programerText = gui.newSimpleTextWithBackground({420, 180}, fontSize, "Programmer:\n     admund aka Closhard Alpha")--, {0.3, 0.4, 0.8})
    secGroup:insert(programerText)
    transition.to(secGroup, {time=transTime, delay = transTime, x=-400})
    
    local threeGroup = display.newGroup()
    local threeBack = display.newRect(-400, 250, 320, 100)
    threeBack.anchorX = 0; threeBack.anchorY = 0;
    threeBack.fill = {0.3, 0.4, 0.8}
    threeGroup:insert(threeBack)
    local threeMR = gui.newImageRect("gfx/potato_mr.png", {-40, 330} , potatoSize)
    threeGroup:insert(threeMR)
    local designText = gui.newSimpleTextWithBackground({-380, 280}, fontSize, "Design & Graphic:\n     admund aka Closhard Alpha")--, {0.3, 0.4, 0.8})
    threeGroup:insert(designText)
    transition.to(threeGroup, {time=transTime, delay = transTime*2, x=400})
    
    local fourGroup = display.newGroup()
    local secBack = display.newRect(400, 350, 320, 100)
    secBack.anchorX = 0; secBack.anchorY = 0;
    secBack.fill = {0.3, 0.4, 0.8}
    fourGroup:insert(secBack)
    local fourMR = gui.newImageRect("gfx/potato_mr.png", {360, 380} , potatoSize)
    fourMR:scale(-1, 1)
    fourGroup:insert(fourMR)
    local musicText = gui.newSimpleTextWithBackground({420, 400}, fontSize, "Music & Sounds:\n     admund aka Closhard Alpha")--, {0.3, 0.4, 0.8})
    fourGroup:insert(musicText)
    transition.to(fourGroup, {time=transTime, delay = transTime*3, x=-400})

    local fiveGroup = display.newGroup()
    local threeBack = display.newRect(-400, 450, 320, 100)
    threeBack.anchorX = 0; threeBack.anchorY = 0;
    threeBack.fill = {0.3, 0.4, 0.8}
    fiveGroup:insert(threeBack)
    local fiveMR = gui.newImageRect("gfx/potato_mr.png", {-120, 460} , potatoSize)
    fiveMR:addEventListener("tap", onHideCredits)
    fiveGroup:insert(fiveMR)
    local clickText = gui.newSimpleTextWithBackground({-280, 460}, fontSize, "Click ME ==> ")--, {0.3, 0.4, 0.8})
    fiveGroup:insert(clickText)
    transition.to(fiveGroup, {time=transTime, delay = transTime*4, x=400})
    
    credits:insert(firstGroup)
    credits:insert(secGroup)
    credits:insert(threeGroup)
    credits:insert(fourGroup)
    credits:insert(fiveGroup)
    scene.credits = credits
end

-----------------------
function scene:createScene( event )
    
    -- scene group
    screenGroup = display.newGroup()
    scene.view:insert(screenGroup)
    
    local back = gui.newImageRect("gfx/back.jpg", {display.contentCenterX, display.contentCenterY}, {display.contentWidth, display.contentHeight})
    screenGroup:insert(back)
    
    local fontSize = 20
    local leftButton = gui.newSimpleTextButton({display.contentCenterX, display.contentHeight/2}, {250, 100},
            "Play!!!111ONE", fontSize, onStartGame)
    screenGroup:insert(leftButton)
    
    local rightButton = gui.newSimpleTextButton({display.contentCenterX, display.contentHeight*3/4}, {250, 100},
            "Credits :)", fontSize, onCredits)
    screenGroup:insert(rightButton)
end

------------
function scene:willEnterScene( event )

end


local function changePyraDirection()
    if(pyra) then
        if pyra.direction == 1 then
            pyra.direction = -1
            pyra:scale(-1, 1)
            pyra.transition = transition.to(pyra, {time=2000, x=520, onComplete=changePyraDirection})
        else
            pyra.direction = 1
            pyra:scale(-1, 1)
            pyra.transition = transition.to(pyra, {time=2000, x=-200, onComplete=changePyraDirection})
        end
    end
end
    
------------
function scene:enterScene( event )
    pyra = gui.newImageRect("gfx/potato_mr.png", {-200, 80} , {200, 130})
    pyra.direction = -1
    
    pyra.tran = transition.to(pyra, {time=2000, x=520, onComplete=changePyraDirection})
end

------------
function scene:exitScene( event )
    transition.cancel(pyra.tran)
    pyra:removeSelf()
    pyra = nil
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
