local CollisionHandler = require("CollisionHandler")

local Map = require("Map")
local Player = require("Player")
local Link = require("Link")
local HUD = require("HUD")
local Score = require("Score")
local PauseMenu = require("PauseMenu")

local GameScene = class("GameScene", Scene)

function GameScene:initialize(level)
	Scene.initialize(self)
	love.mouse.setVisible(false)

	self.level = level

	local map = self:add(Map())
	map:loadLevel(self.level)

	self:add(Player(map:getPlayerStart()))
	self:add(Link())
	self:add(HUD())
	self:add(Score())

	self:add(PauseMenu())
	self:enter()
end

function GameScene:restart()
	gamestate.switch(GameScene(self.level))
end

return GameScene
