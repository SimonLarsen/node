local BoxCollider = require("BoxCollider")
local CollisionHandler = require("CollisionHandler")
local BulletExplosion = require("BulletExplosion")

local Bullet = class("Bullet", Entity)

Bullet.static.SPEED = 160

function Bullet:initialize(x, y, dir)
	Entity.initialize(self, x, y)
	self:setName("bullet")

	self.xspeed = math.cos(dir) * Bullet.static.SPEED
	self.yspeed = math.sin(dir) * Bullet.static.SPEED

	self.sprite = Resources.getImage("bullet.png")
	self.collider = BoxCollider(8, 8, 0, 0)
end

function Bullet:enter()
	self.map = self.scene:find("map")
end

function Bullet:update(dt)
	self.x = self.x + self.xspeed * dt
	self.y = self.y + self.yspeed * dt

	if CollisionHandler.checkMapBox(self.map, self) then
		self.scene:add(BulletExplosion(self.x, self.y))
		self:kill()
	end
end

function Bullet:draw()
	love.graphics.setColor(0, 0, 0, 128)
	love.graphics.circle("fill", self.x, self.y, 4, 8)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.sprite, self.x, self.y-16, 0, 1, 1, 6, 6)
end

function Bullet:onCollide(o)
	if o:getName() == "kick"
	or o:getName() == "player" then
		self.scene:add(BulletExplosion(self.x, self.y))
		self:kill()
	end
end

return Bullet
