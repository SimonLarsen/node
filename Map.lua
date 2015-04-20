local MapCover = require("MapCover")
local MapCollider = require("MapCollider")
local Robot = require("Robot")
local Spider = require("Spider")
local Rock = require("Rock")
local Sentinel = require("Sentinel")
local Sniper = require("Sniper")

local bresenham = require("bresenham.bresenham")

local Map = class("Map", Entity)

function Map:initialize()
	Entity.initialize(self, 0, 0, 10)
	self:setName("map")

	self.width = 48
	self.height = 48
	self.img_tiles = Resources.getImage("tiles.png")
	self.back_batch = love.graphics.newSpriteBatch(self.img_tiles, self.width*self.height)
	self.front_batch = love.graphics.newSpriteBatch(self.img_tiles, self.width*self.height)
end

function Map:enter()
	self.scene:add(MapCover(self.front_batch))
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

				local dice = love.math.random(1, 5)
				if dice >= 1 and dice <= 3 then
					self.scene:add(Robot(x, y))
				elseif dice == 4 then
					self.scene:add(Spider(x, y))
				elseif dice == 5 then
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

	self.quad_tiles = {}
	for i=0, 3 do
		self.quad_tiles[i] = love.graphics.newQuad(i*32, 0, 32, 32, imgw, imgh)
	end
end

function Map:createSpriteBatches()
	self.back_batch:clear()
	self.front_batch:clear()
	for ix = 0, self.width-1 do
		for iy = 0, self.height-1 do
			local tile = self:get(ix, iy)
			if tile > 0 then
				self.back_batch:add(self.quad_tiles[tile], ix*32, iy*32)
			end

			if iy < self.height-2
			and self:get(ix, iy) == 1 and self:get(ix, iy+1) ~= 1 then
				self.front_batch:add(self.quad_tiles[0], ix*32, iy*32)
			end
		end
	end
end

function Map:draw()
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

function Map:los(x1, y1, x2, y2)
	return bresenham.los(x1, y1, x2, y2, function(x, y)
		return self:get(x, y) == 1
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
		return self:get(x, y) == 1
	end)
end

return Map
