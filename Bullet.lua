local Enemy = require("Enemy")
local BoxCollider = require("BoxCollider")

local Bullet = class("Bullet", Enemy)

Bullet.static.MAXX = 10
Bullet.static.SOLID = false

function Bullet:initialize(x, y, dir, speed)
	Enemy.initialize(self. x, y, 0, Bullet.static.MASS, Bullet.static.SOLID)

	self.xspeed = math.cos(dir) * speed
	self.yspeed = math.sin(dir) * speed

	self.sprite = Resources.getImage("bullet.png")
	self.collider = BoxCollider(8, 8, 4, 4)
end

function Bullet:update(dt)
	self.x = self.x + self.xspeed * dt
	self.y = self.y + self.yspeed * dt
end

function Bullet:draw()
	love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1, 4, 4)
end
