local LinkJoint = require("LinkJoint")

local Link = class("Link", Entity)

Link.static.STEP_TIME = 1/60
Link.static.STIFFNESS = 1

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
			for i,v in ipairs(self.joints) do
				v:update(Link.static.STEP_TIME)
				allActive = allActive and v:isActive()
				active = active or v:isActive()
			end

			for i,v in ipairs(self.joints) do
				if v:isActive() then
					local diffX = v.e1.x - v.e2.x
					local diffY = v.e1.y - v.e2.y
					local d = math.sqrt(diffX^2 + diffY^2)

					local diff = (v.dist - d) / d

					local transX = diffX * stiffness * diff
					local transY = diffY * stiffness * diff

					if v.e1:isSolid() == false then
						v.e1.x = v.e1.x + transX
						v.e1.y = v.e1.y + transY
					end

					if v.e2:isSolid() == false then
						v.e2.x = v.e2.x - transX
						v.e2.y = v.e2.y - transY
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
		love.graphics.line(self.links[i].x, self.links[i].y-16, self.links[i+1].x, self.links[i+1].y-16)
	end

	if #self.links > 0 and self.triggered == false then
		local mx, my = Mouse.getPositionCamera()
		love.graphics.line(self.links[#self.links].x, self.links[#self.links].y-16, mx, my)
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
		self.links[1]:setLinked(false)
		self.links = {}
		return
	end

	self.joints = {}
	for i = 1, #self.links-1 do
		table.insert(self.joints, LinkJoint(self.links[i], self.links[i+1]))
	end
	self.timeacc = 0
	self.triggered = true
end

return Link
