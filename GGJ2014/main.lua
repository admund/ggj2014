local seed = os.time()
math.randomseed( seed );
math.random();math.random();math.random();
local rand = math.random()
for i = 0, rand*100, 1 do
   math.random()
end

local storyboard = require("storyboard")

-- load scene
--storyboard.loadScene("src.scene.sceneMenu")
storyboard.loadScene("src.scene.sceneGame")
storyboard.loadScene("src.scene.sceneLooseDialog")

--  run first menu
storyboard.gotoScene( "src.scene.sceneGame", "fade", 0)
--storyboard.gotoScene( "src.scene.sceneChoice", "fade", 300)


