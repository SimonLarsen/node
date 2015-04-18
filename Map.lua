local Map = class("Map", Entity)

function Map:initialize()
	Entity.initialize(self, 0, 0, 100)

	self.width, self.height = 32, 32
	self.img_floor_tiles = Resources.getImage("images/floor_tiles.png")
	self.floor_batch = love.graphics.newSpriteBatch(self.img_floor_tiles, 32*32)

	self:createQuads()
	self:generate()
end

function Map:generate()
	-- Generate tile map
	self.floor_tiles = {}
	for ix = 0, self.width-1 do
		self.floor_tiles[ix] = {}
		for iy = 0, self.height-1 do
			if ix == 0 or ix == self.width-1
			or iy == 0 or iy == self.height-1 then
				self.floor_tiles[ix][iy] = 0
			else
				self.floor_tiles[ix][iy] = 1
			end
		end
	end

	-- Fill sprite batches
	self.floor_batch:clear()
	for ix = 0, self.width-1 do
		for iy = 0, self.height-1 do
			local tile = self.floor_tiles[ix][iy]
			self.floor_batch:add(self.floor_quads[tile], ix*32, iy*32)
		end
	end
end

function Map:createQuads()
	local imgw, imgh = self.img_floor_tiles:getDimensions()

	self.floor_quads = {}
	for i=0, 3 do
		self.floor_quads[i] = love.graphics.newQuad(i*32, 0, 32, 32, imgw, imgh)
	end
end

function Map:draw()
	love.graphics.draw(self.floor_batch, 0, 0)
end

return Map
