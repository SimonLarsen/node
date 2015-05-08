local CollisionHandler = require("CollisionHandler")
local Camera = require("Camera")

local Scene = class("Scene")

function Scene:initialize()
	self.entities = {}
	self.hasEntered = false
	self.speed = 1
	self.camera = Camera()
	self.bgcolor = {r=255, g=255, b=255}

	Timer.clear()
end

function Scene:enter()
	self.hasEntered = true
	for i,v in ipairs(self.entities) do
		v:enter()
	end
end

function Scene:update(dt)
	self.camera:update(dt)

	CollisionHandler.checkAll(self)

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
	canvas:clear(self.bgcolor.r, self.bgcolor.g, self.bgcolor.b, 255)

	love.graphics.push()
	self.camera:apply()

	for i,v in ipairs(self.entities) do
		if v.draw then
			v:draw()
		end
	end
	
	love.graphics.pop()
end

function Scene:gui()
	love.graphics.push()

	for i,v in ipairs(self.entities) do
		if v.gui then
			v:gui()
		end
	end

	love.graphics.pop()
end

function Scene:drawFullscreenShader(shader)
	love.graphics.setShader(shader)
	love.graphics.setCanvas()

	love.graphics.push()
	love.graphics.origin()
	love.graphics.scale(SCALE, SCALE)

	love.graphics.draw(canvas, 0, 0)

	love.graphics.pop()

	canvas:clear(self.bgcolor.r, self.bgcolor.g, self.bgcolor.b, 0)
	love.graphics.setCanvas(canvas)
	love.graphics.setShader()
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

function Scene:clearEntities()
	self.entities = {}
end

function Scene:getEntities()
	return self.entities
end

function Scene:getCamera()
	return self.camera
end

function Scene:setBackgroundColor(r, g, b)
	self.bgcolor = {r=r, g=g, b=b}
end

return Scene
