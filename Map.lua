local MapCover = require("MapCover")
local MapCollider = require("MapCollider")
local Robot = require("Robot")
local Spider = require("Spider")
local Rock = require("Rock")

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

function Map:loadLayout(cat, id)
	local data = love.image.newImageData("data/layouts/" .. cat .. "/" .. id .. ".png")

	self.map = {}
	for ix = 0, self.width-1 do
		self.map[ix] = {}
		for iy = 0, self.height-1 do
			local r, g, b, a = data:getPixel(ix, iy)
			self.map[ix][iy] = 1
			if r == 0 and g == 0 and b == 0 then
				self.map[ix][iy] = 0
			elseif r == 255 and g == 0 and b == 0 then
				self.scene:add(Robot(ix*32+16, iy*32+16))
			elseif r == 255 and g == 0 and b == 255 then
				self.scene:add(Spider(ix*32+16, iy*32+16))
			elseif r == 0 and g == 0 and b == 255 then
				self.scene:add(Rock(ix*32+16, iy*32+16))
			elseif r == 0 and g == 255 and b == 0 then
				self.startx = ix*32+16
				self.starty = iy*32+16
			end
		end
	end

	self:createQuads()
	self:createSpriteBatches()

	self.collider = MapCollider(self.map, self.width, self.height, 32)
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

function Map:getPlayerStart()
	return self.startx, self.starty
end

return Map
