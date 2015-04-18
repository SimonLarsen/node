local Collider = require("Collider")

local MapCollider = class("MapCollider", Collider)

function MapCollider:initialize(map, width, height, tilesize)
	self.map = map
	self.width = width
	self.height = height
	self.tilesize = tilesize
end

function MapCollider:getType()
	return "map"
end
	
return MapCollider
