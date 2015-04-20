local BoxCollider = require("BoxCollider")
local CollisionHandler = require("CollisionHandler")
local Kick = require("Kick")

local Player = class("Player", Entity)

Player.static.MOVE_SPEED = 200
Player.static.DASH_SPEED = 500

Player.static.INVUL_TIME = 1.4
Player.static.TRIGGER_TIME = 0.42
Player.static.SLOWMO_FACTOR = 0.5
Player.static.DASH_TIME = 0.2

Player.static.STATE_IDLE	= 0
Player.static.STATE_RUN		= 1
Player.static.STATE_KICK	= 2
Player.static.STATE_HIT		= 3
Player.static.STATE_TRIGGER	= 4
Player.static.STATE_DASH 	= 5

function Player:initialize(x, y)
	Entity.initialize(self, x, y, 0)
	self:setName("player")

	self.xspeed = 0
	self.yspeed = 0

	self.dir = 1
	self.state = Player.static.STATE_IDLE
	self.health = 3
	self.invulnerable = 0
	self.time = 0

	self.animator = Animator(Resources.getAnimator("player.lua"))
	self.collider = BoxCollider(20, 48, 0, 0)

	self.img_viewcircle = Resources.getImage("viewcircle.png")
end

function Player:enter()
	self.map = self.scene:find("map")
	self.hud = self.scene:find("hud")
end

function Player:update(dt)
	self.animator:update(dt)

	local oldx, oldy = self.x, self.y

	local animstate = self.state
	self.xspeed = math.movetowards(self.xspeed, 0, 1000*dt)
	self.yspeed = math.movetowards(self.yspeed, 0, 1000*dt)

	self.time = self.time - dt

	if self.state == Player.static.STATE_IDLE then
		self:updateMovement()

		if Mouse.wasPressed("r") then
			self:kick()
		end

		if Keyboard.wasPressed(" ") then
			self:dash()
		end

		if self.xspeed^2+self.yspeed^2 > 50^2 then
			animstate = 1
		end

	elseif self.state == Player.static.STATE_KICK then
		if self.time <= 0 then
			self.state = Player.static.STATE_IDLE
		end
	
	elseif self.state == Player.static.STATE_TRIGGER then
		if self.time <= 0 then
			self.state = Player.static.STATE_IDLE
		end

		if Keyboard.wasPressed(" ") then
			self:updateMovement()
			self:dash()
		end
	
	elseif self.state == Player.static.STATE_DASH then
		if self.time < Player.static.DASH_TIME / 2 then
			self.xspeed = math.movetowards(self.xspeed, 0, 2000*dt)
			self.yspeed = math.movetowards(self.yspeed, 0, 2000*dt)
		end
		if self.time <= 0 then
			self.state = Player.static.STATE_IDLE
		end
		if Mouse.wasPressed("r") then
			self:kick()
		end
	end

	self.dir = math.sign(self.xspeed)

	self.x = self.x + self.xspeed * dt
	if CollisionHandler.checkMapBox(self.map, self) then
		self.x = oldx
	end

	self.y = self.y + self.yspeed * dt
	if CollisionHandler.checkMapBox(self.map, self) then
		self.y = oldy
	end

	if self.invulnerable > 0 then
		self.invulnerable = self.invulnerable - dt

		if self.invulnerable > 0.7 * Player.static.INVUL_TIME then
			animstate = Player.static.STATE_HIT
		end
	end

	if Mouse.isDown("l") then
		self.scene:setSpeed(Player.static.SLOWMO_FACTOR)
	else
		self.scene:setSpeed(1)
	end

	self.animator:setProperty("state", animstate)
	camera:setPosition(self.x, self.y)
end

function Player:draw()
	if self:isInvulnerable() == false or love.timer.getTime() % 0.2 < 0.1 then
		self.animator:draw(self.x, self.y, 0, self.dir, 1, nil, 48)
	end
end

function Player:gui()
	love.graphics.setColor(0, 0, 0)
	if WIDTH > 800 then
		love.graphics.rectangle("fill", 0, 0, WIDTH/2-400, HEIGHT)
		love.graphics.rectangle("fill", WIDTH/2+400, 0, WIDTH/2-400, HEIGHT)
	end
	if HEIGHT > 400 then
		love.graphics.rectangle("fill", WIDTH/2-400, 0, 800, HEIGHT/2-200)
		love.graphics.rectangle("fill", WIDTH/2-400, HEIGHT/2+200, 800, HEIGHT/2-200)
	end

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.img_viewcircle, WIDTH/2, HEIGHT/2, 0, 1, 1, 400, 200)
end

function Player:updateMovement()
	if Keyboard.isDown("a") then
		self.xspeed = -Player.static.MOVE_SPEED
	end
	if Keyboard.isDown("d") then
		self.xspeed = Player.static.MOVE_SPEED
	end

	if Keyboard.isDown("w") then
		self.yspeed = -Player.static.MOVE_SPEED
	end
	if Keyboard.isDown("s") then
		self.yspeed = Player.static.MOVE_SPEED
	end
end

function Player:hit()
	self.health = self.health - 1
	self.invulnerable = Player.static.INVUL_TIME
	self.hud:setHealth(self.health)
end

function Player:trigger()
	self.state = Player.static.STATE_TRIGGER
	self.time = Player.static.TRIGGER_TIME
end

function Player:dash()
	self.state = Player.static.STATE_DASH
	self.time = Player.static.DASH_TIME

	self.xspeed = self.xspeed / Player.static.MOVE_SPEED * Player.static.DASH_SPEED
	self.yspeed = self.yspeed / Player.static.MOVE_SPEED * Player.static.DASH_SPEED
end

function Player:kick()
	self.state = Player.static.STATE_KICK
	self.time = 7 * 0.06
	self.scene:add(Kick(self.x, self.y, self.xspeed, self.yspeed))
end

function Player:isInvulnerable()
	return self.invulnerable > 0
end

function Player:onCollide(o)
	if self:isInvulnerable() then return end

	if o:getName() == "bullet" then
		self:hit()
	elseif o:getName() == "laser" then
		self:hit()
	end
end

return Player
