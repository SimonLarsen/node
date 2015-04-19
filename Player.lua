local BoxCollider = require("BoxCollider")
local CollisionHandler = require("CollisionHandler")
local Kick = require("Kick")

local Player = class("Player", Entity)

Player.static.MOVE_SPEED = 200

Player.static.STATE_IDLE = 0
Player.static.STATE_RUN = 1
Player.static.STATE_KICK = 2

function Player:initialize(x, y)
	Entity.initialize(self, x, y, 0)
	self:setName("player")

	self.dir = 1
	self.state = Player.static.STATE_IDLE
	self.health = 3
	self.invulnerable = 0

	self.animator = Animator(Resources.getAnimator("player.lua"))
	self.collider = BoxCollider(20, 48, 0, 0)
end

function Player:enter()
	self.map = self.scene:find("map")
end

function Player:update(dt)
	self.animator:update(dt)

	local oldx, oldy = self.x, self.y

	local animstate = self.state
	if self.state == Player.static.STATE_IDLE then
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

		if Keyboard.wasPressed(" ") then
			self.state = Player.static.STATE_KICK
			self.time = 7 * 0.06
			self.scene:add(Kick(self.x, self.y))
		end

	elseif self.state == Player.static.STATE_KICK then
		self.time = self.time - dt
		if self.time <= 0 then
			self.state = Player.static.STATE_IDLE
		end
	end

	self.animator:setProperty("state", animstate)
	camera:setPosition(self.x, self.y)
end

function Player:draw()
	self.animator:draw(self.x, self.y, 0, self.dir, 1, nil, 48)
end

function Player:onCollide(o)
	if o.collider:getType() == "map" then
		self.x, self.y = self.lastx, self.lasty
	end
end

return Player
