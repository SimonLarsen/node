local Map = require("Map")
local Player = require("Player")
local Link = require("Link")
local HUD = require("HUD")

local GameScene = class("GameScene", Scene)

function GameScene:initialize()
	Scene.initialize(self)

	local map = self:add(Map())
	map:generate()

	self:add(Player(map:getPlayerStart()))
	self:add(Link())
	self:add(HUD())

	self:enter()
end

return GameScene
