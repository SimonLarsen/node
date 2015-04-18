local BoxCollider = require("BoxCollider")
local CollisionHandler = require("CollisionHandler")

local Player = class("Player", Entity)

Player.static.MOVE_SPEED = 200

function Player:initialize(x, y)
	Entity.initialize(self, x, y, 0)

	self.dir = 1

	self.animator = Animator(Resources.getAnimator("player.lua"))
	self.crosshair = Resources.getImage("crosshair.png")
	self.collider = BoxCollider(20, 48, 10, 48)
end

function Player:enter()
	self.map = self.scene:find("map")
end

function Player:update(dt)
	self.animator:update(dt)

	local oldx, oldy = self.x, self.y

	local animstate = 0
	if Keyboard.isDown("a") then
		self.x = self.x - Player.static.MOVE_SPEED * dt
		self.dir = -1
		animstate = 1
	end
	if Keyboard.isDown("d") then
		self.x = self.x + Player.static.MOVE_SPEED * dt
		self.dir = 1
		animstate = 1
	end

	if CollisionHandler.checkMapBox(self.map, self) then
		self.x = oldx
	end

	if Keyboard.isDown("w") then
		self.y = self.y - Player.static.MOVE_SPEED * dt
		animstate = 1
	end
	if Keyboard.isDown("s") then
		self.y = self.y + Player.static.MOVE_SPEED * dt
		animstate = 1
	end

	if CollisionHandler.checkMapBox(self.map, self) then
		self.y = oldy
	end

	self.animator:setProperty("state", animstate)

	camera:setPosition(self.x, self.y)
end

function Player:draw()
	self.animator:draw(self.x, self.y, 0, self.dir, 1, nil, 48)
end

function Player:gui()
	local mx, my = Mouse.getPosition()
	love.graphics.draw(self.crosshair, mx, my, 0, 1, 1, 16, 16)
end

function Player:onCollide(o)
	if o.collider:getType() == "map" then
		self.x, self.y = self.lastx, self.lasty
	end
end

return Player
