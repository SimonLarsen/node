local LinkJoint = require("LinkJoint")
local Explosion = require("Explosion")

local Link = class("Link", Entity)

function Link:initialize()
	Entity.initialize(self, 0, 1000000, 0)

	self:setName("link")

	self.active = false
	self.links = {}
end

function Link:update(dt)
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
				v:destroy()
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
end

function Link:draw()
	love.graphics.setLineWidth(2)

	for i=1, #self.links-1 do
		love.graphics.line(self.links[i].x, self.links[i].y+self.links[i].linkz, self.links[i+1].x, self.links[i+1].y+self.links[i+1].linkz)
	end

	if #self.links > 0 and self.active == false then
		local mx, my = Mouse.getPositionCamera()
		love.graphics.line(self.links[#self.links].x, self.links[#self.links].y+self.links[#self.links].linkz, mx, my)
	end
end

function Link:addLink(e)
	for i,v in ipairs(self.links) do
		if v == e then
			return false
		end
	end
	if self.active == true then
		return false
	else
		table.insert(self.links, e)
		return true
	end
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
end

return Link
