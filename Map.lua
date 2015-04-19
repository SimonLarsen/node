local MapCover = require("MapCover")
local MapCollider = require("MapCollider")
local Robot = require("Robot")
local Spider = require("Spider")
local Rock = require("Rock")

local bresenham = require("bresenham.bresenham")

local Map = class("Map", Entity)

function Map:initialize()
	Entity.initialize(self, 0, -100000, 100000)
	self:setName("map")

	self.width, self.height = 32, 32
	self.img_floor_tiles = Resources.getImage("floor_tiles.png")
	self.img_walls = Resources.getImage("walls.png")
	self.floor_batch = love.graphics.newSpriteBatch(self.img_floor_tiles, 32*32)
	self.back_batch = love.graphics.newSpriteBatch(self.img_walls, 256)
	self.front_batch = love.graphics.newSpriteBatch(self.img_walls, 256)
end

function Map:enter()
	self.scene:add(MapCover(self.front_batch))
end

function Map:generate()
	self:clear()

	local lastx, lasty
	for i=1, 5 do
		local cx = love.math.random(4, self.width-5)
		local cy = love.math.random(4, self.width-5)
		local r = love.math.random(4, 6)
		if i == 1 then
			self.startx = cx*32 + 16
			self.starty = cy*32 + 16
		else
			self:setPath(lastx, lasty, cx, cy)
		end
		self:setCircle(cx, cy, r)
		lastx, lasty = cx, cy
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
	local imgw, imgh = self.img_floor_tiles:getDimensions()

	self.quad_floor = {}
	for i=0, 3 do
		self.quad_floor[i] = love.graphics.newQuad(i*32, 0, 32, 32, imgw, imgh)
	end

	self.quad_wall_front = love.graphics.newQuad(0, 0, 32, 40, 64, 40)
	self.quad_wall_back = love.graphics.newQuad(32, 0, 32, 40, 64, 40)
end

function Map:createSpriteBatches()
	self.floor_batch:clear()
	self.back_batch:clear()
	for ix = 0, self.width-1 do
		for iy = 0, self.height-1 do
			local tile = self:get(ix, iy)
			if tile > 0 then
				self.floor_batch:add(self.quad_floor[tile], ix*32, iy*32)
			end

			if iy < self.height-1 and tile == 0 and self:get(ix, iy+1) == 1 then
				self.back_batch:add(self.quad_wall_front, ix*32, iy*32-8)
			end
			if iy > 0 and tile == 0 and self:get(ix, iy-1) == 1 then
				self.front_batch:add(self.quad_wall_back, ix*32, iy*32-40)
			end
		end
	end
end

function Map:draw()
	love.graphics.draw(self.floor_batch, 0, 0)
	love.graphics.draw(self.back_batch, 0, 0)
end

function Map:getPlayerStart()
	return self.startx, self.starty
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
	return self.map[x][y]
end

return Map
