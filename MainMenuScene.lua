local MainMenuController = require("MainMenuController")

local MainMenuScene = class("MainMenuScene", Scene)

function MainMenuScene:initialize()
	Scene.initialize(self)

	self:add(MainMenuController())

	self:setBackgroundColor(72, 117, 167)
end

return MainMenuScene
