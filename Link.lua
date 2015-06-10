local BoxCollider = require("BoxCollider")
local Explosion = require("Explosion")
local BigExplosion = require("BigExplosion")
local LinkEffect = require("LinkEffect")
local LinkChain = require("LinkChain")
local Player = require("Player")
local Blip = require("Blip")

local Link = class("Link", Entity)

Link.static.PLAYER_REACH = 270
Link.static.LINK_REACH = 270
Link.static.TIME = 0.35

function Link:initialize()
	Entity.initialize(self, 0, 0, -1)

	self:setName("link")

	self.links = {}
	self.chains = {}
	self.active = false
	self.hasSolid = false
	self.hasReach = false

	self.crosshair = Animation(Resources.getImage("crosshair.png"), 36, 36, 0.2)
	self.collider = BoxCollider(48, 64, 0, 16)
end

function Link:enter()
	self.player = self.scene:find("player")
end

function Link:update(dt)
	self.crosshair:update(dt)

	self.x, self.y = Mouse.getPositionCamera(self.scene:getCamera())

	if self.player:isDead() then
		self.hasReach = false
		return
	end

	if self.active == false then
		for i=#self.links, 1, -1 do
			if self.links[i]:isAlive() == false then
				table.remove(self.links, i)
			end
		end

		if #self.chains > 0 then
			local mx, my = Mouse.getPositionCamera(self.scene:getCamera())
			self.chains[#self.chains].points[1].x = mx
			self.chains[#self.chains].points[1].y = my
		end

		if Mouse.wasReleased("l")
		or self.player:isLinking() == false then
			if #self.links >= 2 then
				self.player:trigger()
				Resources.playSound("denied.wav")
			end

			if #self.links >= 1 then
				self:trigger()
			end
		end
	else
		self.time = self.time - dt
		if self.time <= 0 then
			local blipcount = math.round(math.pow(#self.links, 1.5))
			for i=1, blipcount do
				local speed = love.math.random(100, 250)
				local dir = love.math.random() * 2 * math.pi
				local xspeed = math.cos(dir) * speed
				local yspeed = math.sin(dir) * speed
				self.scene:add(Blip(self.targetx, self.targety, xspeed, yspeed))
			end

			for i,v in ipairs(self.links) do
				v.x = v.x + love.math.random() * 16 - 8
				v.y = v.y + love.math.random() * 16 - 8
				v:destroy(false, #self.links)
			end
			Resources.playSound("explosion_deep.wav")
			self:clear()
			return
		end

		for i,v in ipairs(self.links) do
			if v:isSolid() == false then
				local xsp = math.abs(v.x - self.targetx) / self.time
				local ysp = math.abs(v.y - self.targety) / self.time
				v.x = math.movetowards(v.x, self.targetx, xsp * dt)
				v.y = math.movetowards(v.y, self.targety, ysp * dt)
			end
		end
	end

	local xdist = self.player.x - self.x
	local ydist = self.player.y - self.y
	self.hasReach = xdist^2 + (2*ydist)^2 < Link.static.PLAYER_REACH^2
end

function Link:draw()
	if not self.active then return end

	love.graphics.setLineWidth(2)
	love.graphics.setColor(255, 128, 248)

	for i=1, #self.links-1 do
		love.graphics.line(self.links[i].x, self.links[i].y+self.links[i].linkz, self.links[i+1].x, self.links[i+1].y+self.links[i+1].linkz)
	end

	if #self.links > 0 and self.active == false then
		if self.hasReach then
			love.graphics.setColor(255, 255, 255)
		else
			love.graphics.setColor(255, 33, 33)
		end
		love.graphics.line(self.links[#self.links].x, self.links[#self.links].y+self.links[#self.links].linkz, self.x, self.y)
		love.graphics.setColor(255, 255, 255)
	end
end

function Link:gui()
	local mx, my = Mouse.getPosition()
	if not self.hasReach then
		love.graphics.setColor(255, 33, 33)
	elseif Mouse.isDown("l") then
		love.graphics.setColor(156, 220, 220)
	end
	self.crosshair:draw(mx, my, 0, 1, 1, 16, 16)
	love.graphics.setColor(255, 255, 255)
end

function Link:addLink(e)
	if e:isLinked() then return false end

	if self.hasReach == false or self.active == true then
		return false
	end

	if e:isSolid() then
		if self.hasSolid then
			return false
		else
			self.hasSolid = true
		end
	end

	table.insert(self.links, e)

	e:setLinked(true)
	self.player:giveStamina(e.link_time * Player.static.LINK_COST)
	Resources.playSound("targeting.wav")
	self.scene:add(LinkEffect(e))

	local p = self.links[#self.links]
	if #self.links > 1 then
		self.chains[#self.chains].points[1].x = p.x
		self.chains[#self.chains].points[1].y = p.y + p.linkz
	end

	local mx, my = Mouse.getPositionCamera(self.scene:getCamera())
	local c = self.scene:add(LinkChain(mx, my, p.x, p.y+p.linkz, 10))
	table.insert(self.chains, c)

	return true
end

function Link:trigger()
	if #self.links == 1 then
		self:clear()
		return
	end

	local solidcount = 0
	for i,v in ipairs(self.links) do
		if v.solid then
			solidcount = solidcount + 1
		end
	end
	if solidcount > 1 then
		self:clear()
		return
	end

	local mass = 0
	local tx = 0
	local ty = 0

	for i,v in ipairs(self.links) do
		v:setTriggered(true)
		tx = tx + v.x * v.mass
		ty = ty + v.y * v.mass
		mass = mass + v.mass
	end

	for i,v in ipairs(self.chains) do
		v:kill()
	end

	self.targetx = tx / mass
	self.targety = ty / mass

	self.time = Link.static.TIME
	self.active = true
end

function Link:clear()
	for i,v in ipairs(self.links) do
		v:setLinked(false)
	end
	self.links = {}

	for i,v in ipairs(self.chains) do
		v:kill()
	end
	self.chains = {}

	self.active = false
	self.hasSolid = false
end

function Link:cancel()
	if self.active == true then
		return
	end
	self:clear()
end

return Link
