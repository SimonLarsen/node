local Map = require("Map")
local Player = require("Player")
local Robot = require("Robot")

local GameScene = class("GameScene", Scene)

function GameScene:initialize()
	Scene.initialize(self)

	self:add(Player(512, 512))
	self:add(Map())
	self:add(Robot(512, 512))
	self:add(Robot(572, 600))
	self:add(Robot(480, 632))
end

return GameScene
