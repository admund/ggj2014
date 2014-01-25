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

function class.newHorizontalSlider(pos, size, backgroundName, fullfilmentName, value, valueMax) 
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

function class.newSimpleText(pos, size, text)
    local T = display.newGroup()
    
    local text = display.newText(text, pos[1], pos[2], native.systemFont, size)
    text.anchorX = 0
    text.anchorY = 0
    
    T:insert(text)
    
    return T
end

function class.newSimpleButton(pos, size, imgName, onTap)
    local T = display.newGroup()
    --T.anchorChildren = true
    
    local btn = class.newImageRect(imgName, pos, size)
    
    if(onTap ~= nil) then
        btn:addEventListener("tap", onTap)
    end
    
    T.btn = btn
    T:insert(btn)
    
    return T
end

function class.newSimpleTextButton(pos, size, text, onTap)
    local T = display.newGroup()
    --T.anchorChildren = true
    
    local btn = class.newImageRect("gfx/ui/button_background.png", pos, size)
    
    if(onTap ~= nil) then
        btn:addEventListener("tap", onTap)
    end
    
    if(onTouch ~= nil) then
        btn:addEventListener("touch", onTouch)
    end
    T.btn = btn
    T:insert(btn)
    
    local textUi = display.newText(text, pos.x, pos.y, native.systemFont, size.h/3)--20)
    textUi.fill = {0.2,0.2,0.2}
    T.text = textUi
    T:insert(textUi)
    
    ---
    -- @param r @class number
    -- @param g @class number
    -- @param b @class number
    -- @param a @class number @optional
    -- @return
    --
    function T.fill(r, g, b, a)
        local a = a or 1
        T.btn.fill  = {r, g, b, a}
    end
    
    function T.setTextColor(r, g, b, a)
        local a = a or 1
        local r = r or 0
        local g = g or 0
        local b = b or 0
        T.text:setFillColor(r, g, b, a)
    end
    
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

return class