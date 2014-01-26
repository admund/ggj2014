------------------------------------------------------
--  UI COMPONENTS
----------------------------------------------------

local class = {}

function class.newImageRect(fileName, pos, size)
    local back = display.newImageRect(fileName, size[1], size[2])
    back.x = pos[1]
    back.y = pos[2]
    return back
end

---
-- @param pos
-- @param size
-- @param color
-- @param value
-- @param valueMax
-- @return

function class.newHorizontalSliderFill(pos, size, backgroundName, fullfilmentName, value, valueMax) 
    local boarderSize = 4
    local T = display.newGroup()
    
    local back = class.newImageRect(backgroundName, {pos[1] - boarderSize/2, pos[2] - boarderSize/2} , {size[1] + boarderSize, size[2] + boarderSize})
    back.anchorX = 0
    back.anchorY = 0
    T:insert(back)
    
    local width
    if(valueMax ~= -1) then
        width = value/(valueMax + 1) * size[1] + 1
        if(width > size[1]) then
            width = size[1]
        end
    else
        width = size[1]
    end
    local fill = class.newImageRect(fullfilmentName, pos, {width, size[2]})
    fill.anchorX = 0
    fill.anchorY = 0
    T:insert(fill)
    
    return T
end

function class.newHorizontalSliderIndicator(pos, size, backgroundName, indicatorName, percent) 
    local T = display.newGroup()
    
    local back = class.newImageRect(backgroundName, pos, size)
    back.anchorX = 0
    back.anchorY = 0
    T:insert(back)
    
    local width = (size[1] - size[2]) * percent
    
    local fill = class.newImageRect(indicatorName, {pos[1] + size[2]/2 + width, pos[2] + size[2]/2}, {size[2], size[2]})
    T:insert(fill)
    
    return T
end

function class.newSimpleText(pos, size, text, anchorX, anchorY)
    local T = display.newGroup()
    
    local text = display.newText(text, pos[1], pos[2], native.systemFont, size)
    text.anchorX = anchorX or 0
    text.anchorY = anchorY or 0
    
    T:insert(text)
    
    return T
end

function class.newSimpleTextWithBackground(pos, size, text, color, anchorX, anchorY)
    local T = display.newGroup()
    
    local text = display.newText(text, pos[1], pos[2], native.systemFont, size)
    text.anchorX = anchorX or 0
    text.anchorY = anchorY or 0
    
    local back = display.newRect(pos[1], pos[2], text.contentWidth, text.contentHeight)
    back.anchorX = anchorX or 0
    back.anchorY = anchorY or 0
    back.fill = color
    
    T:insert(back)
    T:insert(text)
    
    return T
end

function class.newSimpleButton(pos, size, imgName, onTap, onTouch)
    local T = display.newGroup()
    --T.anchorChildren = true
    
    local btn = class.newImageRect(imgName, pos, size)
    
    if(onTap ~= nil) then
        btn:addEventListener("tap", onTap)
    end
    
    if(onTouch ~= nil) then
        btn:addEventListener("touch", onTouch)
    end
    
    T.btn = btn
    T:insert(btn)
    
    return T
end

function class.newSimpleTextButton(pos, size, text, fontSize, onTap)
    local T = display.newGroup()
    --T.anchorChildren = true
    
    local btn = class.newImageRect("gfx/slider_background.jpg", pos, size)
    
    if(onTap ~= nil) then
        btn:addEventListener("tap", onTap)
    end
    T.btn = btn
    T:insert(btn)
    
    local textUi = display.newText(text, pos[1], pos[2], native.systemFont, fontSize)--20)
    textUi.fill = {0.2,0.2,0.2}
    T.text = textUi
    T:insert(textUi)
    
    return T
end

---
-- @param pos
-- @param size
-- @param color
-- @param value
-- @param valueMax
-- @return

function class.newVerticalSlider(pos, size, fullfilmentName, value, valueMax) 
    local T = display.newGroup()
    
    local back = class.newImageRect("gfx/ui/vertical_slider_background.png", {x=pos.x - 1, y=pos.y - 1}, {w=size.w + 2, h=size.h + 2})
    T:insert(back)
    
    local hight
    if(valueMax ~= -1) then
        hight = value/(valueMax + 1) * size.h + 1
        if(hight > size.h) then
            hight = size.h
        end
    else
        hight = size.h
    end
    
    local fill = class.newImageRect(fullfilmentName, {x=pos.x, y=pos.y + size.h - hight}, {w=size.w, h=hight})
    T:insert(fill)
    
    return T
end

function class.newFlotingText(text, isBad) 
    local T = display.newGroup()
    
    local text = display.newText(text, 0, display.contentHeight/4, native.systemFont, 30)
    local back = display.newRect(0, display.contentHeight/4, text.contentWidth, text.contentHeight)
    if(isBad) then
        back.fill = {1, 0.2, 0.2}
    else
        back.fill = {0.2, 1, 0.2}
    end
    T:insert(back)
    T:insert(text)
    
    T.x = -text.contentWidth/2
    
    transition.to(T, {time = 3000, x=320 + text.contentWidth/2, onComplete=text.removeSelf})
end

return class