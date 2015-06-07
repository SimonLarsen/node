local GameController = class("GameController", Entity)

function GameController:initialize()
	Entity.initialize(self)

	self:setName("controller")
end

function GameController:addKill()
	self.scene:find("map"):addKill()
	self.scene:find("score"):addKill()
end

return GameController
