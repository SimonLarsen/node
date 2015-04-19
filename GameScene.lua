local Map = require("Map")
local Player = require("Player")
local Link = require("Link")

local GameScene = class("GameScene", Scene)

function GameScene:initialize()
	Scene.initialize(self)

	local map = self:add(Map())
	map:loadLayout(1, 3)

	self:add(Player(map:getPlayerStart()))
	self:add(Link())

	self:enter()
end

return GameScene
