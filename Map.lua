local MapCollider = require("MapCollider")
local Robot = require("Robot")
local Spider = require("Spider")
local Rock = require("Rock")
local Commander = require("Commander")
local Demobot = require("Demobot")
local Sentinel = require("Sentinel")
local Sniper = require("Sniper")
local Spawner = require("Spawner")
local Sumo = require("Sumo")

local bresenham = require("bresenham.bresenham")

local Map = class("Map", Entity)

function Map:initialize()
	Entity.initialize(self, 0, 0, 10)
	self:setName("map")

	self.img_tiles = Resources.getImage("tiles.png")
end

function Map:loadLevel(id)
	local f = love.filesystem.load("data/levels/" .. id .. ".lua")
	local data = f()

	self.width = data.width
	self.height = data.height
	self.enemies = 0
	self.num_waves = 0
	self.waves = {}
	self.current_wave = 0
	self:clear()

	for i, layer in ipairs(data.layers) do
		if layer.type == "tilelayer" then
			for ix = 0, self.width-1 do
				for iy = 0, self.height-1 do
					self.map[ix][iy] = layer.data[iy*self.width + ix + 1]
				end
			end

		elseif layer.type == "objectgroup" then
			if layer.name == "base" then
				for j, o in ipairs(layer.objects) do
					local x, y = o.x, o.y
					if o.type == "player" then
						self.startx = x
						self.starty = y
					end
				end
			else
				local id = tonumber(layer.name)
				self.num_waves = math.max(self.num_waves, id)
				self.waves[id] = {}
				for j, o in ipairs(layer.objects) do
					table.insert(self.waves[id], o)
				end
			end
		end
	end

	self.batch = love.graphics.newSpriteBatch(self.img_tiles, self.width*self.height)
	self:createQuads()
	self:createSpriteBatches()

	self.collider = MapCollider(self, self.width, self.height, 32)
end

function Map:advance()
	self.current_wave = self.current_wave + 1

	if self.current_wave > self.num_waves then
		local score = self.scene:find("score")
		score:updateTotalScore()
		Timer.add(1, function()
			self.scene:add(ClearScreen(score:getScore(), score:getElapsedTime()))
		end)
		return
	end

	for i, o in ipairs(self.waves[self.current_wave]) do
		local x, y = o.x, o.y
		if o.type == "robot" then
			self.scene:add(Spawner(x, y, Robot(x, y)))
			self.enemies = self.enemies + 1
		elseif o.type == "commander" then
			self.scene:add(Spawner(x, y, Commander(x, y)))
			self.enemies = self.enemies + 1
		elseif o.type == "demobot" then
			self.scene:add(Spawner(x, y, Demobot(x, y)))
			self.enemies = self.enemies + 1
		elseif o.type == "spider" then
			self.scene:add(Spawner(x, y, Spider(x, y)))
			self.enemies = self.enemies + 1
		elseif o.type == "sniper" then
			self.scene:add(Spawner(x, y, Sniper(x, y)))
			self.enemies = self.enemies + 1
		elseif o.type == "sumo" then
			self.scene:add(Spawner(x, y, Sumo(x, y)))
			self.enemies = self.enemies + 1
		end
	end
end

function Map:addKill(o)
	if o:countsInWave() then
		self.enemies = self.enemies - 1
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

function Map:draw()
	love.graphics.draw(self.batch, 0, 0)
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
