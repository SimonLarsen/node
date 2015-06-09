local BoxCollider = require("BoxCollider")
local Blip = class("Blip", Entity)

Blip.static.SPEED = 400
Blip.static.RANGE = 75
Blip.static.LIFETIME = 4

function Blip:initialize(x, y, xspeed, yspeed)
	Entity.initialize(self, x, y)
	self:setName("blip")

	self.acceleration = 500
	self.xspeed = xspeed or 0
	self.yspeed = yspeed or 0
	self.time = 0

	self.animation = Animation(Resources.getImage("blip.png"), 9, 9, 0.07)
	self.collider = BoxCollider(4, 4)
end

function Blip:enter()
	self.player = self.scene:find("player")
end

function Blip:update(dt)
	self.animation:update(dt)

	self.time = self.time + dt
	
	local dx = self.player.x - self.x
	local dy = self.player.y - self.y
	local dist = vector.length(dx, dy)

	local txspeed = dx / dist * Blip.static.SPEED
	local tyspeed = dy / dist * Blip.static.SPEED
	self.xspeed = math.movetowards(self.xspeed, txspeed, self.acceleration*dt)
	self.yspeed = math.movetowards(self.yspeed, tyspeed, self.acceleration*dt)
	self.acceleration = self.acceleration + 200*dt

	if self.time >= Blip.static.LIFETIME and not following then
		self:kill()
	end

	self.x = self.x + self.xspeed * dt
	self.y = self.y + self.yspeed * dt
end

function Blip:draw()
	love.graphics.setColor(0, 0, 0, 128)
	love.graphics.circle("fill", self.x, self.y, 4.5, 8)
	love.graphics.setColor(255, 255, 255, 255)
	self.animation:draw(self.x, self.y-16)
end

return Blip
