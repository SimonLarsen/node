local Enemy = require("Enemy")

local HUD = class("HUD", Entity)

HUD.static.COOLDOWN = 0.2

function HUD:initialize()
	Entity.initialize(self, 0, 0, -100)
	self:setName("hud")

	self.health = 3
	self.subhealth = self.health
	self.health_cooldown = 0

	self.stamina = 1
	self.substamina = self.stamina
	self.stamina_cooldown = 0

	self.img_hud_top = Resources.getImage("hud_top.png")
	self.img_healthbar = Resources.getImage("healthbar.png")
	self.img_staminabar = Resources.getImage("stamina_bar.png")
	self.img_substaminabar = Resources.getImage("stamina_subbar.png")
	self.img_minimap = Resources.getImage("minimap.png")
	self.img_minimap_overlay = Resources.getImage("minimap_overlay.png")
	self.img_enemy_dot = Resources.getImage("enemy_dot.png")

	self.quad_stamina = love.graphics.newQuad(0, 0, 78, 3, 78, 3)
	self.quad_substamina = love.graphics.newQuad(0, 0, 78, 3, 78, 3)
end

function HUD:enter()
	self.player = self.scene:find("player")
end

function HUD:setHealth(value)
	self.subhealth = self.health
	self.health = value
	self.health_cooldown = HUD.static.COOLDOWN*3
end

function HUD:setStamina(value)
	if value < self.stamina then
		self.stamina_cooldown = HUD.static.COOLDOWN
	end
	if value > self.substamina then
		self.substamina = value
	end
	self.stamina = value
	self.quad_stamina:setViewport(0, 0, self.stamina*78, 3)
end

function HUD:update(dt)
	if self.stamina_cooldown > 0 then
		self.stamina_cooldown = self.stamina_cooldown - dt
	elseif self.substamina > self.stamina then
		self.substamina = math.movetowards(self.substamina, self.stamina, dt)
	end
	self.quad_substamina:setViewport(0, 0, self.substamina*78, 3)

	self.health_cooldown = self.health_cooldown - dt
end

function HUD:gui()
	love.graphics.draw(self.img_hud_top, 0, 8)

	local barlen = self.subhealth * 34
	if self.health_cooldown > 0 then
		love.graphics.polygon("fill", 5, 27, 15, 17, barlen+15, 17, barlen+5, 27)
	end
	love.graphics.setColor(112, 218, 218)
	barlen = self.health * 34
	love.graphics.polygon("fill", 5, 27, 15, 17, barlen+15, 17, barlen+5, 27)

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.img_healthbar, 4, 16)

	if self.substamina - self.stamina > 1/78 then
		love.graphics.draw(self.img_substaminabar, self.quad_substamina, 4, 36)
	end
	love.graphics.draw(self.img_staminabar, self.quad_stamina, 4, 36)

	love.graphics.draw(self.img_minimap, WIDTH-117, 6)
	local cx = WIDTH-40
	local cy = 26
	for i,v in ipairs(self.scene:getEntities()) do
		if v:isInstanceOf(Enemy) then
			local offx = math.cap((v.x - self.player.x) / 20, -26, 26)
			local offy = math.cap((v.y - self.player.y) / 20, -17, 17)
			if offy > 8 then
				offx = math.max(offx, -26 + offy - 8)
			elseif offy < -7 then
				offx = math.min(offx, 26 + 7 + offy)
			end
			love.graphics.draw(self.img_enemy_dot, cx+offx, cy+offy, 0, 1, 1, 1, 1)
		end
	end
	love.graphics.draw(self.img_minimap_overlay, WIDTH-68, 6)
end

return HUD
