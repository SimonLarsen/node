local Map = require("Map")
local Player = require("Player")
local Link = require("Link")
local Robot = require("Robot")
local Spider = require("Spider")
local Rock = require("Rock")

local GameScene = class("GameScene", Scene)

function GameScene:initialize()
	Scene.initialize(self)

	self:add(Player(512, 512))
	self:add(Link())
	self:add(Map())
	self:add(Robot(512, 512))
	self:add(Robot(572, 600))
	self:add(Robot(480, 632))
	self:add(Spider(500, 600))
	self:add(Rock(550, 630))
end

return GameScene
