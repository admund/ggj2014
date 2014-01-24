local gui = require("src.ui.uiItems")

local class = {}

function class.createDrug(direction, pos)
    local drug = gui.newImageRect("gfx/drug.jpg", pos, {30, 30})
    
    
    transition.to(drug, {time=5000, rotation=3600, x=pos[1] + 1000*direction, y=pos[2]-600, 
        onComplete = drug.removeSelf})
    
    
    return drug
end

return class

