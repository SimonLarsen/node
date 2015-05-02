local CollisionHandler = require("CollisionHandler")

local Map = require("Map")
local Player = require("Player")
local GlitchOverlay = require("GlitchOverlay")
local Link = require("Link")
local HUD = require("HUD")
local Score = require("Score")
local PauseMenu = require("PauseMenu")
local Winscreen = require("Winscreen")

local ClearScreen = require("ClearScreen")

local GameScene = class("GameScene", Scene)

GameScene.static.NUM_LEVELS = 10

function GameScene:initialize(level)
	Scene.initialize(self)
	love.mouse.setVisible(false)

	self.level = level

	local map = self:add(Map())
	map:loadLevel(self.level)

	self:add(Player(map:getPlayerStart()))
	self:add(GlitchOverlay())
	self:add(Link())
	self:add(HUD())
	self:add(Score(map:getNumEnemies()))

	self:add(PauseMenu())

	self:setBackgroundColor(35, 28, 55)

	self:enter()
end

function GameScene:restart()
	gamestate.switch(GameScene(self.level))
end

function GameScene:nextLevel()
	if self.level == GameScene.static.NUM_LEVELS then
		gamestate.switch(Winscreen())
	else
		gamestate.switch(GameScene(self.level+1))
	end
end

return GameScene
