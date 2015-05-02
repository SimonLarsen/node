local MapCollider = require("MapCollider")
local Robot = require("Robot")
local Spider = require("Spider")
local Rock = require("Rock")
local Commander = require("Commander")
local Demobot = require("Demobot")
local Sentinel = require("Sentinel")
local Sniper = require("Sniper")

local bresenham = require("bresenham.bresenham")

local Map = class("Map", Entity)

function Map:initialize()
	Entity.initialize(self, 0, 0, 10)
	self:setName("map")

	self.img_tiles = Resources.getImage("tiles.png")

	self.shader = Resources.getShader("glitch.lua")
	self.dispswitch = 0
	self.disppause = 0
	self.glitch = false
	self.glitchfactor = 0

	self.disp = {}
	for i = 1,6 do
		self.disp[i] = Resources.getImage("disp/" .. i .. ".png")
	end
end

function Map:loadLevel(id)
	local f = love.filesystem.load("data/levels/" .. id .. ".lua")
	local data = f()

	self.width = data.width
	self.height = data.height
	self.enemies = 0
	self:clear()

	for i, layer in ipairs(data.layers) do
		if layer.type == "tilelayer" then
			for ix = 0, self.width-1 do
				for iy = 0, self.height-1 do
					self.map[ix][iy] = layer.data[iy*self.width + ix + 1]
				end
			end

		elseif layer.type == "objectgroup" then
			for j, o in ipairs(layer.objects) do
				local x, y = o.x, o.y
				if o.type == "player" then
					self.startx = x
					self.starty = y
				elseif o.type == "robot" then
					self.scene:add(Robot(x, y))
					self.enemies = self.enemies + 1
				elseif o.type == "commander" then
					self.scene:add(Commander(x, y))
					self.enemies = self.enemies + 1
				elseif o.type == "demobot" then
					self.scene:add(Demobot(x, y))
					self.enemies = self.enemies + 1
				elseif o.type == "spider" then
					self.scene:add(Spider(x, y))
					self.enemies = self.enemies + 1
				elseif o.type == "sniper" then
					self.scene:add(Sniper(x, y))
					self.enemies = self.enemies + 1
				end
			end
		end
	end

	-- Add walls
	self.batch = love.graphics.newSpriteBatch(self.img_tiles, self.width*self.height)
	self:createQuads()
	self:createSpriteBatches()

	self.collider = MapCollider(self, self.width, self.height, 32)
end

function Map:generate()
	self:clear()

	local lastx, lasty
	for i=1, 10 do
		local cx = love.math.random(4, self.width-5)
		local cy = love.math.random(4, self.width-5)
		local r = love.math.random(3, 6)
		if i == 1 then
			self.startx = cx*32 + 16
			self.starty = cy*32 + 16
		else
			self:setPath(lastx, lasty, cx, cy)
			for j=1, r do
				local dir = love.math.random()*2*math.pi
				local x = cx*32+16 + math.cos(dir) * r*32/2
				local y = cy*32+16 + math.sin(dir) * r*32/2

				local dice = love.math.random(1, 7)
				if dice >= 1 and dice <= 2 then
					self.scene:add(Robot(x, y))
				elseif dice >= 3 and dice <= 4 then
					self.scene:add(Commander(x, y))
				elseif dice == 5 then
					self.scene:add(Demobot(x, y))
				elseif dice == 6 then
					self.scene:add(Spider(x, y))
				elseif dice == 7 then
					self.scene:add(Sniper(x, y))
				end
			end
		end
		self:setCircle(cx, cy, r)
		lastx, lasty = cx, cy
	end
	
	for ix = 0, self.width-1 do
		for iy=0, self.height-2 do
			if self:get(ix, iy) == 0 and self:get(ix, iy+1) == 1 then
				self:set(ix, iy, 2)
			end
		end
	end

	self:createQuads()
	self:createSpriteBatches()

	self.collider = MapCollider(self.map, self.width, self.height, 32)
end

function Map:setCircle(x, y, r)
	for ix = x-r+1, x+r-1 do
		for iy = y-r+1, y+r-1 do
			if ix > 0 and ix < self.width-1
			and iy > 0 and iy < self.height-1
			and (ix-x)^2+(iy-y)^2 <= r^2 then
				self:set(ix, iy, 1)
			end
		end
	end
end

function Map:setPath(x1, y1, x2, y2)
	local path, found = bresenham.line(x1, y1, x2, y2, function() return true end)
	for i,v in ipairs(path) do
		self:setCircle(v[1], v[2], 2)
	end
end

function Map:createQuads()
	local imgw, imgh = self.img_tiles:getDimensions()
	local xtiles = math.floor(imgw / 32)
	local ytiles = math.floor(imgh / 32)

	self.quad_tiles = {}

	for ix = 0, xtiles-1 do
		for iy = 0, ytiles-1 do
			self.quad_tiles[iy*xtiles + ix + 1] = love.graphics.newQuad(ix*32, iy*32, 32, 32, imgw, imgh)
		end
	end
end

function Map:createSpriteBatches()
	self.batch:clear()
	for ix = 0, self.width-1 do
		for iy = 0, self.height-1 do
			local tile = self:get(ix, iy)
			if tile > 0 then
				self.batch:add(self.quad_tiles[tile], ix*32, iy*32)
			end
		end
	end
end

function Map:update(dt)
	if self.glitch then
		self.glitchfactor = math.movetowards(self.glitchfactor, 1, 5*dt)

		self.dispswitch = self.dispswitch - dt
		self.disppause = self.disppause - dt
		if self.dispswitch <= 0 then
			self.dispswitch = love.math.random() * 0.05
			if love.math.random(1,8) == 1 then
				self.disppause = love.math.random() * 0.2
			else
				self.shader:send("disp", self.disp[love.math.random(1,6)])
			end
		end
	else
		self.glitchfactor = math.movetowards(self.glitchfactor, 0, 10*dt)
	end
end

function Map:draw()
	love.graphics.draw(self.batch, 0, 0)

	if self.glitch then
		love.graphics.setColor(120, 220, 220, 100*self.glitchfactor)
		love.graphics.push()
		love.graphics.origin()
		love.graphics.scale(1, 0.5)
		love.graphics.circle("fill", WIDTH/2, HEIGHT, self.glitchfactor*math.max(WIDTH,HEIGHT)/2, 32)
		love.graphics.pop()
		love.graphics.setColor(255, 255, 255)

		if self.disppause < 0 then
			self.shader:send("factor", self.glitchfactor)
			self.scene:drawFullscreenShader(self.shader)
		end
	end
end

function Map:getPlayerStart()
	return self.startx, self.starty
end

function Map:getNumEnemies()
	return self.enemies
end

function Map:clear()
	self.map = {}
	for ix = 0, self.width-1 do
		self.map[ix] = {}
		for iy = 0, self.height-1 do
			self:set(ix, iy, 0)
		end
	end
end

function Map:set(x, y, val)
	if x >= 0 and x < self.width
	and y >= 0 and y < self.height then
		self.map[x][y] = val
	end
end

function Map:get(x, y)
	if x < 0 or x >= self.width
	or y < 0 or y >= self.height then
		return 0
	end
	return self.map[x][y]
end

function Map:isSolid(x, y)
	return self:get(x, y) <= 24
end

function Map:los(x1, y1, x2, y2)
	return bresenham.los(x1, y1, x2, y2, function(x, y)
		return not self:isSolid(x, y)
	end)
end

function Map:canSee(e1, e2)
	local x1 = math.floor(e1.x / 32)
	local y1 = math.floor(e1.y / 32)
	local x2 = math.floor(e2.x / 32)
	local y2 = math.floor(e2.y / 32)
	return self:los(x1, y1, x2, y2)
end

function Map:canSeeLine(e1, e2)
	local x1 = math.floor(e1.x / 32)
	local y1 = math.floor(e1.y / 32)
	local x2 = math.floor(e2.x / 32)
	local y2 = math.floor(e2.y / 32)
	return bresenham.line(x1, y1, x2, y2, function(x, y)
		return not self:isSolid(x, y)
	end)
end

return Map
