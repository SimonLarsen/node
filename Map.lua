local MapCover = require("MapCover")
local MapCollider = require("MapCollider")

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

	self:generate()
	self:createQuads()
	self:createSpriteBatches()

	self.collider = MapCollider(self.map, self.width, self.height, 32)
end

function Map:enter()
	self.scene:add(MapCover(self.front_batch))
end

function Map:generate()
	-- Fill empty tile map
	self.map = {}
	for ix = 0, self.width-1 do
		self.map[ix] = {}
		for iy = 0, self.height-1 do
			self.map[ix][iy] = 0
		end
	end

	-- Draw circles
	for i=1, 10 do
		local cx = love.math.random(8, 24)
		local cy = love.math.random(8, 24)
		local r = love.math.random(2, 6)

		for ix = math.max(1, cx - r), math.min(30, cx + r) do
			for iy = math.max(1, cy - r), math.min(30, cy + r) do
				if (ix-cx)^2+(iy-cy)^2 <= r^2 then
					self.map[ix][iy] = 1
				end
			end
		end
	end

	-- Add border tiles
	for ix = 0, self.width-1 do
		self.map[ix][0] = 0
		self.map[ix][self.height-1] = 0
	end
	for iy = 0, self.height-1 do
		self.map[0][iy] = 0
		self.map[self.width-1][iy] = 0
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
			local tile = self.map[ix][iy]
			if tile > 0 then
				self.floor_batch:add(self.quad_floor[tile], ix*32, iy*32)
			end

			if iy < self.height-1 and tile == 0 and self.map[ix][iy+1] == 1 then
				self.back_batch:add(self.quad_wall_front, ix*32, iy*32-8)
			end
			if iy > 0 and tile == 0 and self.map[ix][iy-1] == 1 then
				self.front_batch:add(self.quad_wall_back, ix*32, iy*32-40)
			end
		end
	end
end

function Map:draw()
	love.graphics.draw(self.floor_batch, 0, 0)
	love.graphics.draw(self.back_batch, 0, 0)
end

return Map
