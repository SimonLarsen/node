local LinkJoint = require("LinkJoint")
local Explosion = require("Explosion")
local BigExplosion = require("BigExplosion")

local Link = class("Link", Entity)

Link.static.PLAYER_REACH = 270
Link.static.LINK_REACH = 270

function Link:initialize()
	Entity.initialize(self, 0, 0, -1)

	self:setName("link")

	self.links = {}
	self.active = false
	self.hasSolid = false
	self.hasReach = false

	self.crosshair = Animation(Resources.getImage("crosshair.png"), 36, 36, 0.2)
end

function Link:enter()
	self.player = self.scene:find("player")
end

function Link:update(dt)
	self.crosshair:update(dt)

	if self.active == false then
		for i,v in ipairs(self.links) do
			if v:isAlive() == false then
				self:clear()
				return
			end
		end

		if Mouse.wasReleased("l") then
			if #self.links >= 1 then
				self:trigger()
				self.player:trigger()
			end
		end

		if Mouse.wasPressed("r") then
			self:clear()
		end
	else
		self.time = self.time - dt
		if self.time <= 0 then
			for i,v in ipairs(self.links) do
				v.x = v.x + love.math.random() * 16 - 8
				v.y = v.y + love.math.random() * 16 - 8
				self.scene:add(Explosion(v.x, v.y, love.math.randomNormal(0.2, 1.0)))
				v:kill()
			end
			self:clear()
			return
		end

		for i,v in ipairs(self.links) do
			if v:isSolid() == false then
				local xsp = math.abs(v.x - self.targetx) / self.time
				local ysp = math.abs(v.y - self.targety) / self.time
				v.x = math.movetowards(v.x, self.targetx, xsp * dt)
				v.y = math.movetowards(v.y, self.targety, ysp * dt)
			end
		end
	end

	local mx, my = Mouse.getPositionCamera()
	--[[
	if #self.links > 0 then
		local xdist = self.links[#self.links].x - mx
		local ydist = self.links[#self.links].y - my
		self.hasReach = xdist^2 + (2*ydist)^2 < Link.static.LINK_REACH^2
	else
	]]
		local xdist = self.player.x - mx
		local ydist = self.player.y - my
		self.hasReach = xdist^2 + (2*ydist)^2 < Link.static.PLAYER_REACH^2
	--end
end

function Link:draw()
	love.graphics.setLineWidth(2)

	for i=1, #self.links-1 do
		love.graphics.line(self.links[i].x, self.links[i].y+self.links[i].linkz, self.links[i+1].x, self.links[i+1].y+self.links[i+1].linkz)
	end

	local mx, my = Mouse.getPositionCamera()
	if #self.links > 0 and self.active == false then
		if not self.hasReach then
			love.graphics.setColor(255, 33, 33)
		end
		love.graphics.line(self.links[#self.links].x, self.links[#self.links].y+self.links[#self.links].linkz, mx, my)
		love.graphics.setColor(255, 255, 255)
	end
end

function Link:gui()
	local mx, my = Mouse.getPosition()
	if not self.hasReach then
		love.graphics.setColor(255, 33, 33)
	elseif Mouse.isDown("l") then
		love.graphics.setColor(156, 220, 220)
	end
	self.crosshair:draw(mx, my, 0, 1, 1, 16, 16)
	love.graphics.setColor(255, 255, 255)
end

function Link:addLink(e)
	for i,v in ipairs(self.links) do
		if v == e then
			return false
		end
	end
	if self.hasReach == false or self.active == true then
		return false
	end

	if e:isSolid() then
		if self.hasSolid then
			return false
		else
			self.hasSolid = true
		end
	end

	table.insert(self.links, e)
	return true
end

function Link:trigger()
	if #self.links == 1 then
		self:clear()
		return
	end

	local solidcount = 0
	for i,v in ipairs(self.links) do
		if v.solid then
			solidcount = solidcount + 1
		end
	end
	if solidcount > 1 then
		self:clear()
		return
	end

	local mass = 0
	local tx = 0
	local ty = 0

	for i,v in ipairs(self.links) do
		v:setLinked(true)
		tx = tx + v.x * v.mass
		ty = ty + v.y * v.mass
		mass = mass + v.mass
	end

	self.targetx = tx / mass
	self.targety = ty / mass

	self.time = 0.5
	self.active = true
end

function Link:clear()
	for i,v in ipairs(self.links) do
		v:setLinked(false)
	end
	self.links = {}
	self.active = false
	self.hasSolid = false
end

return Link
