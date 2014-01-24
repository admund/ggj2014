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

function class.newHorizontalSlider(pos, size, fullfilmentName, value, valueMax) 
    
    local T = display.newGroup()
    
    local back = class.newImageRect("gfx/ui/horizontal_slider_background.png", {x=pos.x - 1, y=pos.y - 1} , {w=size.w + 2, h=size.h + 2})
    back.fill = {0.6, 0.6, 0.6}
    T:insert(back)
    
    local width
    if(valueMax ~= -1) then
        width = value/(valueMax + 1) * size.w + 1
        if(width > size.w) then
            width = size.w
        end
    else
        width = size.w
    end
    local fill = class.newImageRect(fullfilmentName, pos, {w=width, h=size.h})
    T:insert(fill)
    
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

---
-- @param pos
-- @param size
-- @param skillType
-- @param level
-- @return

function class.newSpecialButton(pos, size, skillType, usableNr, level, isOthersEventUse)
    local T = display.newGroup()
    
    function T.buttonTouch(event)
        if(event.phase == "began") then
            if(class.useSpecial(skillType)) then
                level.skillUp = skillType
                class.createSkillDragItem(skillType, event)
            end
        end
        
        if(event.phase == "ended") then
            level.skillUp = nil
        end
    end
    
    local btn = class.newImageRect("gfx/ui/special_button.png", pos, size)
    btn.fill = {0.8,0.8,0.8}
    if(isOthersEventUse == false) then
        btn:addEventListener("touch", T.buttonTouch)
    end
    T:insert(btn)
    
    local text = display.newText(skillType, pos.x, pos.y, size.w, size.h, native.systemFont, 20)
    text:setFillColor(0.2,0.2,0.2)
    T:insert(text)
    
    local usableNrText = display.newText(usableNr, pos.x + 20, pos.y + size.h/2, native.systemFont, 15)
    usableNrText:setFillColor(0.2,0.2,0.2)
    T:insert(usableNrText)
    
    return T
end

function class.useSpecial(skillType) 
    if(skillType == "line") then
        if(Game.internalStore.line > 0) then
            Game.internalStore.line = Game.internalStore.line - 1
            return true
        end
    elseif(skillType == "reset") then
        if(Game.internalStore.reset > 0) then
            Game.internalStore.reset = Game.internalStore.reset - 1
            return true
        end
    elseif(skillType == "matrix") then
        if(Game.internalStore.bomb > 0) then
            Game.internalStore.bomb = Game.internalStore.bomb - 1
            return true
        end
    elseif(skillType == "color") then
        if(Game.internalStore.clear > 0) then
            Game.internalStore.clear = Game.internalStore.clear - 1
            return true
        end
    end
    
    return false
end

function class.removeSelf(event)
    if(event.phase == "moved") then
        event.target.x = event.x
        event.target.y = event.y
        return true
    end
    
    if(event.phase == "ended") then
        --display.getCurrentStage():setFocus(nil)
        --event.target.parent:dispatchEvent(event)
        event.target:removeSelf()
        event.target = nil
        return false
    end
end

function class.createSkillDragItem(skillType, event)
    -- TODO w zaleznosci od "skillType" moze dac inny obrazek ktory bedziemy przeciagac 
    local dragItem = class.newImageRect("gfx/ui/drag_element.png", {x=event.x, y=event.y}, {w=40, h=40})
    dragItem.anchorX = 0.5
    dragItem.anchorY = 0.5
    dragItem.x = event.x
    dragItem.y = event.y
    dragItem.fill = {1, 0.05, 0.05}
    dragItem:addEventListener("touch", class.removeSelf)
    --display.getCurrentStage():setFocus(dragItem)
end

return class