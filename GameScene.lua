local CollisionHandler = require("CollisionHandler")

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

function GameScene:update(dt)
	CollisionHandler.checkAll(self.entities)

	if Mouse.isDown("l") then
		dt = dt / 2
	end

	for i,v in ipairs(self.entities) do
		if v:isAlive() and v.update then
			v:update(dt)
		end
	end

	Timer.update(dt)

	util.insertionsort(self.entities, function(a, b)
		return (a.z == b.z and a.y > b.y) or a.z < b.z
	end)

	for i=#self.entities, 1, -1 do
		if self.entities[i]:isAlive() == false then
			table.remove(self.entities, i)
		end
	end
end

return GameScene
