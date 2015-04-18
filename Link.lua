local LinkJoint = require("LinkJoint")

local Link = class("Link", Entity)

Link.static.STEP_TIME = 1/60
Link.static.STIFFNESS = 1.0

function Link:initialize()
	Entity.initialize(self, 0, 1000000, 0)

	self:setName("link")

	self.triggered = false
	self.timeacc = 0
	self.links = {}
	self.joints = {}
end

function Link:update(dt)
	if self.triggered == false then
		for i,v in ipairs(self.links) do
			if v:isAlive() == false then
				self:cancel()
				return
			end
		end

		if Mouse.wasPressed("r") then
			if #self.links >= 1 then
				self:trigger()
			end
		end
	else
		self.timeacc = self.timeacc + dt

		local stiffness = Link.static.STIFFNESS

		local active = true
		while self.timeacc > Link.static.STEP_TIME do
			self.timeacc = self.timeacc - Link.static.STEP_TIME

			active = false

			while #self.joints > 1 and self.joints[1]:isActive() == false do
				table.remove(self.joints, 1)
			end
			while #self.joints > 1 and self.joints[#self.joints]:isActive() == false do
				table.remove(self.joints, #self.joints)
			end

			for i=#self.joints, 1, -1 do
				local v = self.joints[i]
				v:update(Link.static.STEP_TIME)
				allActive = allActive and v:isActive()
				active = active or v:isActive()

				--[[
				if i > 1 then
					local w = self.joints[i-1]
					if v:isActive() == false and w:isActive() == false then
						w.e2 = v.e1
						table.remove(self.joints, i)
					end
				end
				]]
			end

			for i,v in ipairs(self.joints) do
				if v:isActive() then
					local diffX = v.e1.x - v.e2.x
					local diffY = v.e1.y - v.e2.y
					local d = math.sqrt(diffX^2 + diffY^2)

					local diff = (v.dist - d) / d

					local im1 = 1 / v.e1.mass
					local im2 = 1 / v.e2.mass

					local sc1 = (im1 / (im1 + im2)) * stiffness
					local sc2 = stiffness - sc1

					if v.e1:isSolid() == false then
						v.e1.x = v.e1.x + diffX * sc1 * diff
						v.e1.y = v.e1.y + diffY * sc1 * diff
					end

					if v.e2:isSolid() == false then
						v.e2.x = v.e2.x - diffX * sc2 * diff
						v.e2.y = v.e2.y - diffY * sc2 * diff
					end
				end
			end
		end

		if active == false then
			for i,v in ipairs(self.links) do
				v:kill()
			end
			self.links = {}
			self.joints = {}
			self.triggered = false
		end
	end
end

function Link:draw()
	for i=1, #self.links-1 do
		love.graphics.line(self.links[i].x, self.links[i].y+self.links[i].linkz, self.links[i+1].x, self.links[i+1].y+self.links[i+1].linkz)
	end

	if #self.links > 0 and self.triggered == false then
		local mx, my = Mouse.getPositionCamera()
		love.graphics.line(self.links[#self.links].x, self.links[#self.links].y+self.links[#self.links].linkz, mx, my)
	end
end

function Link:addLink(e)
	if self.triggered == true then
		return false
	else
		table.insert(self.links, e)
		return true
	end
end

function Link:trigger()
	if #self.links == 1 then
		self:cancel()
		return
	end

	self.joints = {}
	for i = 1, #self.links-1 do
		table.insert(self.joints, LinkJoint(self.links[i], self.links[i+1]))
	end
	self.timeacc = 0
	self.triggered = true
end

function Link:cancel()
	for i,v in ipairs(self.links) do
		v:setLinked(false)
	end
	self.links = {}
	self.joints = {}
	self.triggered = false
end

return Link
