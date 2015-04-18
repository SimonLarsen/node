local Scene = class("Scene")

function Scene:initialize()
	self.entities = {}
end

function Scene:update(dt)
	for i,v in ipairs(self.entities) do
		if v:isAlive() then
			v:update(dt)
		end
	end

	Timer.update(dt)

	for i=#self.entities, 1, -1 do
		if self.entities[i]:isAlive() == false then
			table.remove(self.entities, i)
		end
	end
end

function Scene:draw()
	for i,v in ipairs(self.entities) do
		v:draw()
	end
end

function Scene:gui()
	for i,v in ipairs(self.entities) do
		v:gui()
	end
end

function Scene:add(e)
	table.insert(self.entities, e)
	table.sort(self.entities, function(a, b)
		return a.z > b.z
	end)
	return e
end

function Scene:find(name)
	for i,v in ipairs(self.entities) do
		if v.name == name then
			return v
		end
	end
end

return Scene
