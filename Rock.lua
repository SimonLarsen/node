local Enemy = require("Enemy")
local Rock = class("Rock", Enemy)
local BoxCollider = require("BoxCollider")

Rock.static.MASS = 10000
Rock.static.SOLID = true

function Rock:initialize(x, y)
	Enemy.initialize(self, x, y, 0, Rock.static.MASS, Rock.static.SOLID)

	self.animator = Animator(Resources.getAnimator("rock.lua"))
	self.collider = BoxCollider(32, 32, -16, -32)
end

function Rock:update(dt)
	self.animator:update(dt)
end

function Rock:draw()
	self.animator:draw(self.x, self.y, 0, 1, 1, 16, 32)
end

return Rock
