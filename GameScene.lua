local Map = require("Map")
local Player = require("Player")
local GlitchOverlay = require("GlitchOverlay")
local PanicOverlay = require("PanicOverlay")
local Link = require("Link")
local HUD = require("HUD")
local Score = require("Score")
local PauseMenu = require("PauseMenu")
local Winscreen = require("Winscreen")
local Fade = require("Fade")
local GlitchFade = require("GlitchFade")
local WaveGameController = require("WaveGameController")
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
	self:add(PanicOverlay())
	self:add(Link())
	self:add(HUD())
	self:add(Score())
	self:add(GlitchFade(GlitchFade.static.FADE_IN, 2, {255,255,255}))
	self:add(WaveGameController())

	Timer.add(1.5, function()
		map:advance()
	end)

	self:add(PauseMenu())

	self:setBackgroundColor(35, 28, 55)

	self:enter()
end

function GameScene:restart()
	gamestate.switch(GameScene(self.level))
end

return GameScene
