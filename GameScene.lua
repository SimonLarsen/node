local CollisionHandler = require("CollisionHandler")

local Map = require("Map")
local Player = require("Player")
local Link = require("Link")
local HUD = require("HUD")
local Score = require("Score")

local GameScene = class("GameScene", Scene)

function GameScene:initialize()
	Scene.initialize(self)

	love.mouse.setVisible(false)

	local map = self:add(Map())
	map:loadLevel("level1")

	self:add(Player(map:getPlayerStart()))
	self:add(Link())
	self:add(HUD())
	self:add(Score())

	self:enter()
end

return GameScene
