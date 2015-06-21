local BoxCollider = require("BoxCollider")
local CollisionHandler = require("CollisionHandler")
local Kick = require("Kick")
local GlitchFade = require("GlitchFade")

local Player = class("Player", Entity)

Player.static.GHOST_COLOR_START = {220, 239, 237}
Player.static.GHOST_COLOR_DIFF = {220-91, 239-200, 237-186}

Player.static.MOVE_SPEED = 200
Player.static.DASH_SPEED = 500

Player.static.SLOWMO_FACTOR = 0.5
Player.static.GHOST_INTERVAL = 0.06
Player.static.DASH_MIN_SPEED = 100

Player.static.TRIGGER_TIME = 0.42
Player.static.INVUL_TIME = 1.4
Player.static.DASH_TIME = 0.2
Player.static.KNOCKBACK_TIME = 0.5
Player.static.KICK_TIME = 7 * 0.06
Player.static.SPAWN_TIME = 20 * 0.1

Player.static.STATE_IDLE	= 0
Player.static.STATE_RUN		= 1
Player.static.STATE_KICK	= 2
Player.static.STATE_HIT		= 3
Player.static.STATE_TRIGGER	= 4
Player.static.STATE_DASH 	= 5
Player.static.STATE_DEAD	= 6
Player.static.STATE_SPAWN	= 7

Player.static.STAMINA_INCREASE = 0.7
Player.static.STAMINA_COOLDOWN = 0.6
Player.static.MAX_STAMINA = 1
Player.static.MAX_POWER = 1
Player.static.BLIP_POWER = 1/50

Player.static.LINK_COST = 1
Player.static.DASH_COST = 0.2
Player.static.KICK_COST = 0.5

function Player:initialize(x, y)
	Entity.initialize(self, x, y, 0)
	self:setName("player")

	self.xspeed = 0
	self.yspeed = 100.0

	self.dir = 1
	self.invulnerable = 0
	self.state = Player.static.STATE_SPAWN
	self.time = Player.static.SPAWN_TIME
	self.knockback = 0

	self.health = 3
	self.stamina = Player.static.MAX_STAMINA
	self.stamina_cooldown = 0
	self.power = 0

	self.animator = Animator(Resources.getAnimator("player.lua"))
	self.img_ghost = Resources.getImage("dash_ghost.png")
	self.collider = BoxCollider(20, 20, 0, 0)

	self.img_viewcircle = Resources.getImage("viewcircle.png")
end

function Player:enter()
	self.map = self.scene:find("map")
	self.hud = self.scene:find("hud")
	self.glitchoverlay = self.scene:find("glitchoverlay")
end

function Player:update(dt)
	self.animator:update(dt)

	local oldx, oldy = self.x, self.y

	local animstate = self.state
	self.xspeed = math.movetowards(self.xspeed, 0, 1000*dt)
	self.yspeed = math.movetowards(self.yspeed, 0, 1000*dt)

	self.time = self.time - dt
	self.knockback = self.knockback - dt

	if self.state == Player.static.STATE_DEAD then
		self.animator:setProperty("state", self.state)
		if self.time <= 0 then
			self.scene:find("pausemenu"):setVisible(true)
		end
		return
	end

	if self.state == Player.static.STATE_IDLE then
		self:updateMovement()

		if Mouse.wasPressed("r") then
			self:kick()
		end

		if Keyboard.wasPressed(" ") then
			self:dash()
		end

		if vector.length(self.xspeed, self.yspeed) > 50 then
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
		self.next_ghost = self.next_ghost - dt
		if self.next_ghost <= 0 then
			self.next_ghost = Player.static.GHOST_INTERVAL
			table.insert(self.ghosts, {x=self.x, y=self.y})
		end
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
	
	elseif self.state == Player.static.STATE_SPAWN then
		animstate = 7
		if self.time <= 0 then
			self.state = Player.static.STATE_IDLE
		end
	end

	self.x = self.x + self.xspeed * dt
	if CollisionHandler.checkMapBox(self.map, self) then
		self.xspeed = 0
		self.x = oldx
	end

	self.y = self.y + self.yspeed * dt
	if CollisionHandler.checkMapBox(self.map, self) then
		self.yspeed = 0
		self.y = oldy
	end

	if self.invulnerable > 0 then
		self.invulnerable = self.invulnerable - dt

		if self.invulnerable > 0.7 * Player.static.INVUL_TIME then
			animstate = Player.static.STATE_HIT
		end
	end

	if Mouse.wasPressed("l") then
		self.linking = true
	end

	if self.linking and Mouse.isDown("l")
	and self:useStamina(Player.static.LINK_COST * dt) then
		self.scene:setSpeed(Player.static.SLOWMO_FACTOR)
		self.linking = true
		self.glitchoverlay:setActive(true)
	else
		self.scene:setSpeed(1)
		self.linking = false
		self.glitchoverlay:setActive(false)
	end

	self:updateStamina(dt)
	self.animator:setProperty("state", animstate)
	self.scene:getCamera():setPosition(self.x, self.y)
end

function Player:updateMovement()
	if self.knockback > 0 then return end

	if Keyboard.isDown("a") then
		self.xspeed = -Player.static.MOVE_SPEED
		self.dir = -1
	end
	if Keyboard.isDown("d") then
		self.xspeed = Player.static.MOVE_SPEED
		self.dir = 1
	end

	if Keyboard.isDown("w") then
		self.yspeed = -Player.static.MOVE_SPEED
	end
	if Keyboard.isDown("s") then
		self.yspeed = Player.static.MOVE_SPEED
	end
end

function Player:hit(o)
	if self.health <= 0 then return end

	self.health = self.health - 1
	self.hud:setHealth(self.health)
	Resources.playSound("hurt.wav")
	if self.health == 0 then
		self.state = Player.static.STATE_DEAD
		local menu = self.scene:find("pausemenu")
		menu:setDead()
		self.time = 1.5
		self.scene:setSpeed(1)
		Resources.playSound("death.wav")
	else
		self.invulnerable = Player.static.INVUL_TIME
	end

	if o:getName() == "bullet" then
		self.xspeed = o.xspeed * 2
		self.yspeed = o.yspeed * 2

	elseif o:getName() == "bigexplosion" then
		local xdist = self.x - o.x
		local ydist = self.y - o.y
		local dist = vector.length(xdist, ydist)

		self.xspeed = xdist / dist * 400
		self.yspeed = ydist / dist * 400
	end

	self.knockback = 0.5
	self.scene:find("panicoverlay"):panic()
	self.scene:add(GlitchFade(GlitchFade.static.FADE_IN, 1.0, {240, 50, 50}, 128))

	self.scene:find("link"):cancel()
end

function Player:trigger()
	self.state = Player.static.STATE_TRIGGER
	self.time = Player.static.TRIGGER_TIME
end

function Player:dash()
	if self:useStamina(Player.static.DASH_COST)
	and vector.length(self.xspeed, self.yspeed) > Player.static.DASH_MIN_SPEED then
		self.state = Player.static.STATE_DASH
		self.time = Player.static.DASH_TIME

		self.next_ghost = 0
		self.ghosts = {}

		self.xspeed = self.xspeed / Player.static.MOVE_SPEED * Player.static.DASH_SPEED
		self.yspeed = self.yspeed / Player.static.MOVE_SPEED * Player.static.DASH_SPEED
		Resources.playSound("dash.wav")
	else
		Resources.playSound("denied.wav")
	end
end

function Player:kick()
	if self:useStamina(Player.static.KICK_COST) then
		self.state = Player.static.STATE_KICK
		self.time = Player.static.KICK_TIME
		self.scene:add(Kick(self.x, self.y, self.xspeed, self.yspeed))
		Resources.playSound("kick.wav")
	else
		Resources.playSound("denied.wav")
	end
end

function Player:isInvulnerable()
	return self.invulnerable > 0
end

function Player:useStamina(cost)
	if self.stamina >= cost then
		self.stamina = self.stamina - cost
		self.stamina_cooldown = Player.static.STAMINA_COOLDOWN
		return true
	else
		return false
	end
end

function Player:isLinking()
	return self.linking
end

function Player:giveStamina(amount)
	self.stamina = math.min(
		Player.static.MAX_STAMINA,
		self.stamina + amount
	)
end

function Player:updateStamina(dt)
	if self.stamina_cooldown > 0 then
		self.stamina_cooldown = self.stamina_cooldown - dt
	elseif self.linking == false then
		self.stamina = math.min(
			Player.static.MAX_STAMINA,
			self.stamina + Player.static.STAMINA_INCREASE * dt
		)
	end

	self.hud:setStamina(self.stamina)
end

function Player:onCollide(o)
	if self:isInvulnerable()
	or self.state == Player.static.STATE_DASH then
		return
	end

	if o:getName() == "bullet"
	or o:getName() == "laser"
	or o:getName() == "bigexplosion" then
		self:hit(o)
	end

	if o:getName() == "blip" then
		self.power = math.min(self.power + Player.static.BLIP_POWER, Player.static.MAX_POWER)
		self.hud:setPower(self.power)
		o:kill()
	end
end

function Player:isDead()
	return self.state == Player.static.STATE_DEAD
end

function Player:draw()
	if self.state == Player.static.STATE_DASH then
		local inc = 1 / #self.ghosts-1
		local col_start = Player.static.GHOST_COLOR_START
		local col_diff = Player.static.GHOST_COLOR_DIFF

		local col = {
			col_start[1], col_start[2], col_start[3]
		}
		
		for i,v in ipairs(self.ghosts) do
			love.graphics.setColor(col)
			love.graphics.draw(self.img_ghost, v.x, v.y, 0, self.dir, 1, 24, 47)
			col[1] = col[1] + col_diff[1]*inc
			col[2] = col[2] + col_diff[2]*inc
			col[3] = col[3] + col_diff[3]*inc
		end
	end
	love.graphics.setColor(255, 255, 255)

	if self:isInvulnerable() == false or love.timer.getTime() % 0.2 < 0.1 then
		self.animator:draw(self.x, self.y, 0, self.dir, 1)
	end
end

function Player:gui()
	love.graphics.setColor(0, 0, 0)
	if self:isLinking() then
		self.glitchoverlay.shader:send("factor", self.glitchoverlay.glitchfactor*0.5)
		love.graphics.setShader(self.glitchoverlay.shader)
	end

	if WIDTH > 800 then
		love.graphics.rectangle("fill", 0, 0, WIDTH/2-400, HEIGHT)
		love.graphics.rectangle("fill", WIDTH/2+400, 0, WIDTH/2-400, HEIGHT)
	end
	if HEIGHT > 400 then
		love.graphics.rectangle("fill", WIDTH/2-400, 0, 800, HEIGHT/2-200)
		love.graphics.rectangle("fill", WIDTH/2-400, HEIGHT/2+200, 800, HEIGHT/2-200)
	end

	love.graphics.draw(self.img_viewcircle, WIDTH/2, HEIGHT/2, 0, 1, 1, 400, 200)

	love.graphics.setShader()
	love.graphics.setColor(255, 255, 255)
end

return Player
