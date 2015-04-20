local CollisionHandler = require("CollisionHandler")

local Scene = class("Scene")

function Scene:initialize()
	self.entities = {}
	self.hasEntered = false
	self.speed = 0
end

function Scene:enter()
	self.hasEntered = true
	for i,v in ipairs(self.entities) do
		v:enter()
	end
end

function Scene:update(dt)
	CollisionHandler.checkAll(self.entities)

	local rt = dt
	dt = dt * self.speed

	for i,v in ipairs(self.entities) do
		if v:isAlive() and v.update then
			v:update(dt, rt)
		end
	end

	Timer.update(dt)

	util.insertionsort(self.entities, function(a, b)
		return (a.z == b.z and a.y > b.y) or a.z < b.z
	end)

	for i=#self.entities, 1, -1 do
		if self.entities[i]:isAlive() == false then
			self.entities[i]:onRemove()
			table.remove(self.entities, i)
		end
	end
end

function Scene:draw()
	for i,v in ipairs(self.entities) do
		if v.draw then
			v:draw()
		end
	end
end

function Scene:gui()
	for i,v in ipairs(self.entities) do
		if v.gui then
			v:gui()
		end
	end
end

function Scene:add(e)
	table.insert(self.entities, e)
	e.scene = self
	if self.hasEntered then
		e:enter()
	end
	return e
end

function Scene:find(name)
	for i,v in ipairs(self.entities) do
		if v:getName() == name then
			return v
		end
	end
end

function Scene:setSpeed(speed)
	self.speed = speed
end

return Scene
