local Enemy = require("Enemy")
local BoxCollider = require("BoxCollider")

local Sentinel = class("Sentinel", Enemy)

Sentinel.static.MASS = 10000
Sentinel.static.SOLID = true

function Sentinel:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Sentinel.static.MASS, Sentinel.static.SOLID, -8)
	self:setName("sentinel")

	self.collider = BoxCollider(32, 32, 0, -16)
	self.sprite = Resources.getImage("sentinel.png")
end

function Sentinel:update(dt)
	self:checkLinked()
end

function Sentinel:draw()
	love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1, 16, 28)
end

return Sentinel
