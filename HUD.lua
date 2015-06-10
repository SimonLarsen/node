local Enemy = require("Enemy")
local Explosion = require("Explosion")
local BigExplosion = require("BigExplosion")
local Spawner = require("Spawner")

local HUD = class("HUD", Entity)

HUD.static.HEALTH_COOLDOWN = 0.6
HUD.static.STAMINA_COOLDOWN = 0.2
HUD.static.POWER_COOLDOWN = 0.4

function HUD:initialize()
	Entity.initialize(self, 0, 0, -100)
	self:setName("hud")

	self.health = 3
	self.subhealth = self.health
	self.health_cooldown = 0

	self.stamina = 1
	self.substamina = self.stamina
	self.stamina_cooldown = 0

	self.power = 0
	self.subpower = self.power
	self.power_cooldown = 0

	self.img_hud_top = Resources.getImage("hud_top.png")
	self.img_healthbar = Resources.getImage("healthbar.png")
	self.img_staminabar = Resources.getImage("stamina_bar.png")
	self.img_substaminabar = Resources.getImage("stamina_subbar.png")
	self.img_minimap = Resources.getImage("minimap.png")
	self.img_minimap_overlay = Resources.getImage("minimap_overlay.png")
	self.img_powerbar_end = Resources.getImage("powerbar_end.png")

	self.quad_stamina = love.graphics.newQuad(0, 0, 78, 3, 78, 3)
	self.quad_substamina = love.graphics.newQuad(0, 0, 78, 3, 78, 3)
end

function HUD:enter()
	self.player = self.scene:find("player")
end

function HUD:setHealth(value)
	self.subhealth = self.health
	self.health = value
	self.health_cooldown = HUD.static.HEALTH_COOLDOWN
end

function HUD:setStamina(value)
	if value < self.stamina then
		self.stamina_cooldown = HUD.static.STAMINA_COOLDOWN
	end
	if value > self.substamina then
		self.substamina = value
	end
	self.stamina = value
	self.quad_stamina:setViewport(0, 0, self.stamina*78, 3)
end

function HUD:setPower(value)
	self.power = value
	if value < self.subpower then
		self.subpower = value
	end
	self.power_cooldown = HUD.static.POWER_COOLDOWN
end

function HUD:update(dt)
	if self.stamina_cooldown > 0 then
		self.stamina_cooldown = self.stamina_cooldown - dt
	elseif self.substamina > self.stamina then
		self.substamina = math.movetowards(self.substamina, self.stamina, dt)
	end
	self.quad_substamina:setViewport(0, 0, self.substamina*78, 3)

	if self.power_cooldown > 0 then
		self.power_cooldown = self.power_cooldown - dt
	elseif self.subpower < self.power then
		self.subpower = math.movetowards(self.subpower, self.power, 0.4*dt)
	end

	self.health_cooldown = self.health_cooldown - dt
end

function HUD:gui()
	local barlen

	barlen = self.power * 104 - 16
	love.graphics.draw(self.img_powerbar_end, barlen, 36)
	love.graphics.rectangle("fill", 0, 36, math.max(0, barlen), 16)

	love.graphics.setColor(90, 90, 196)
	barlen = self.subpower * 104 - 16
	love.graphics.draw(self.img_powerbar_end, barlen, 36)
	love.graphics.rectangle("fill", 0, 36, math.max(0, barlen), 16)
	love.graphics.setColor(255, 255 ,255)

	love.graphics.draw(self.img_hud_top, 0, 8)

	barlen = self.subhealth * 34
	if self.health_cooldown > 0 then
		love.graphics.polygon("fill", 5, 27, 15, 17, barlen+15, 17, barlen+5, 27)
	end
	love.graphics.setColor(112, 218, 218)
	barlen = self.health * 34
	love.graphics.polygon("fill", 5, 27, 15, 17, barlen+15, 17, barlen+5, 27)

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.img_healthbar, 0, 8)

	if self.substamina - self.stamina > 1/78 then
		love.graphics.draw(self.img_substaminabar, self.quad_substamina, 4, 36)
	end
	love.graphics.draw(self.img_staminabar, self.quad_stamina, 4, 36)

	love.graphics.draw(self.img_minimap, WIDTH-117, 6)
	local cx = WIDTH-40
	local cy = 26
	for i,v in ipairs(self.scene:getEntities()) do
		draw = false

		if v:isInstanceOf(Enemy) then
			love.graphics.setColor(255, 98, 98)
			draw = true
		elseif v:isInstanceOf(Explosion) or v:isInstanceOf(BigExplosion) then
			love.graphics.setColor(255, 186, 88)
			draw = true
		elseif v:isInstanceOf(Spawner) then
			love.graphics.setColor(255, 98, 98, v:progress()*255)
			draw = true
		end

		if draw then
			local offx = math.cap((v.x - self.player.x) / 20, -26, 26)
			local offy = math.cap((v.y - self.player.y) / 20, -17, 17)
			if offy > 8 then
				offx = math.max(offx, -26 + offy - 8)
			elseif offy < -7 then
				offx = math.min(offx, 26 + 7 + offy)
			end
			love.graphics.rectangle("fill", cx+offx-1, cy+offy-1, 2, 2)
		end
	end

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.img_minimap_overlay, WIDTH-68, 6)

	love.graphics.rectangle("fill", WIDTH-41, 25, 2, 2)
end

return HUD
