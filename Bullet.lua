local Enemy = require("Enemy")
local BoxCollider = require("BoxCollider")
local CollisionHandler = require("CollisionHandler")

local Bullet = class("Bullet", Enemy)

Bullet.static.MASS = 10
Bullet.static.SOLID = false

Bullet.static.SPEED = 75

function Bullet:initialize(x, y, dir)
	Enemy.initialize(self, x, y, 0, Bullet.static.MASS, Bullet.static.SOLID, -16)

	self.xspeed = math.cos(dir) * Bullet.static.SPEED
	self.yspeed = math.sin(dir) * Bullet.static.SPEED

	self.sprite = Resources.getImage("bullet.png")
	self.collider = BoxCollider(16, 16, 8, 8-16)
end

function Bullet:enter()
	self.map = self.scene:find("map")
end

function Bullet:update(dt)
	self:checkLinked()

	self.x = self.x + self.xspeed * dt
	self.y = self.y + self.yspeed * dt

	if self.x < 0 or self.x > 1024
	or self.y < 0 or self.y > 1024
	or CollisionHandler.checkMapBox(self.map, self) then
		self:kill()
	end
end

function Bullet:draw()
	love.graphics.setColor(0, 0, 0, 128)
	love.graphics.circle("fill", self.x, self.y, 4, 8)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.sprite, self.x, self.y-16, 0, 1, 1, 8, 8)
end

return Bullet