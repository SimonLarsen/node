local HUD = class("HUD", Entity)

function HUD:initialize()
	Entity.initialize(self, 0, 0, -100)
	self:setName("hud")

	self.health = 3
	self.subhealth = 3
	self.img_hud_top = Resources.getImage("hud_top.png")
	self.img_healthbar = Resources.getImage("healthbar.png")
end

function HUD:setHealth(value)
	if value > self.health then
		self.subhealth = value
	end
	self.health = value
end

function HUD:update(dt)
	
end

function HUD:gui()
	love.graphics.draw(self.img_hud_top, 0, 8)
	love.graphics.setColor(112, 218, 218)

	local barlen = self.health * 34
	love.graphics.polygon(
		"fill",
		5, 27,
		15, 17,
		barlen+15, 17,
		barlen+5, 27
	)

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.img_healthbar, 4, 16)
end

return HUD
