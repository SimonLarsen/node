local Enemy = require("Enemy")
local Bullet = require("Bullet")
local BoxCollider = require("BoxCollider")

local PlayerBullet = class("PlayerBullet", Bullet)

PlayerBullet.static.SPEED = 500

function PlayerBullet:initialize(x, y, dir)
	Entity.initialize(self, x, y)
	self:setName("playerbullet")

	self.xspeed = math.cos(dir) * PlayerBullet.static.SPEED
	self.yspeed = math.sin(dir) * PlayerBullet.static.SPEED

	self.sprite = Resources.getImage("bullet.png")
	self.collider = BoxCollider(16, 32, 0, 0)
end

function PlayerBullet:onCollide(o, dt)
	
end

return PlayerBullet
