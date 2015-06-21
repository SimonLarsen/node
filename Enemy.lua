local Linkable = require("Linkable")

local Enemy = class("Enemy", Linkable)

function Enemy:onRemove()
	self.scene:find("controller"):addKill(self)
end

function Enemy:countsInWave()
	return true
end

return Enemy
