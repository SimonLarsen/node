local Camera = require("Camera")

local Scene = class("Scene")

function Scene:initialize()
	self.entities = {}
	self.camera = Camera()
end

function Scene:update(dt)
	for i,v in ipairs(self.entities) do
		if v:isAlive() and v.update then
			v:update(dt)
		end
	end

	Timer.update(dt)

	table.sort(self.entities, function(a, b)
		if a.y == b.y then
			return a.z > b.z
		else
			return a.y < b.y
		end
	end)

	for i=#self.entities, 1, -1 do
		if self.entities[i]:isAlive() == false then
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
	return e
end

function Scene:find(name)
	for i,v in ipairs(self.entities) do
		if v.name == name then
			return v
		end
	end
end

function Scene:getCamera()
	return self.camera
end

return Scene
