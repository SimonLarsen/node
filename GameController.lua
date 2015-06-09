local GameController = class("GameController", Entity)

function GameController:initialize()
	Entity.initialize(self)

	self:setName("controller")
end

function GameController:addKill(o)
	self.scene:find("map"):addKill(o)
	self.scene:find("score"):addKill(o)
end

return GameController
