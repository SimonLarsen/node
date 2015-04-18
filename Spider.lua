local Enemy = require("Enemy")
local BoxCollider = require("BoxCollider")

local Spider = class("Spider", Enemy)

Spider.static.MASS = 30
Spider.static.SOLID = false

function Spider:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Spider.static.MASS, Spider.static.SOLID)

	self.dir = -1 + love.math.random(0, 1) * 2

	self.animator = Animator(Resources.getAnimator("spider.lua"))
	self.collider = BoxCollider(32, 32, -16, -32)
end

function Spider:update(dt)
	self.animator:update(dt)
end

function Spider:draw()
	self.animator:draw(self.x, self.y, 0, self.dir, 1, 16, 32)
end

return Spider
