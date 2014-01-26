local gui = require("src.ui.uiItems")
local physics = require( "physics" )

local class = {}

function class.createDrug(direction, pos)
    local drug = gui.newImageRect("gfx/drug_1.png", pos, {30, 30})
    drug.name = "drug"
    physics.addBody(drug, "dynamic", {filter={ categoryBits = 1, maskBits = 2 }})
    
    transition.to(drug, {time=5000, rotation=3600, x=pos[1] + 1000*direction, y=pos[2]-400, 
        onComplete = drug.destroy})
        
    function drug.destroy()
        if drug then 
            drug:removeSelf()
        end
    end
    
    return drug
end

return class

