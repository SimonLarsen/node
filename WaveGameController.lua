local GameController = require("GameController")

local WaveGameController = class("WaveGameController", GameController)

function WaveGameController:initialize()
	GameController:initialize(self)
end

function WaveGameController:enter()
	self.map = self.scene:find("map")
end

function WaveGameController:addKill()
	GameController.addKill(self)

	if self.map:getNumEnemies() == 0 then
		self.map:advance()
	end
end

return WaveGameController
