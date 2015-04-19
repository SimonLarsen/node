local HUD = class("HUD", Entity)

HUD.static.HEALTH_OFFSET_X = 32
HUD.static.HEALTH_OFFSET_Y = 32

function HUD:initialize()
	Entity.initialize(self, 0, 0, -200)

	self.health = 3
	self.img_healthbar = Resources.getImage("healthbar.png")
end

function HUD:update(dt)
	
end

function HUD:gui()
	love.graphics.setColor(112, 218, 217)
	love.graphics.rectangle(
		"fill",
		HUD.static.HEALTH_OFFSET_X+1,
		HUD.static.HEALTH_OFFSET_Y+1,
		math.min(self.health*26, 77),
	10)

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(
		self.img_healthbar,
		HUD.static.HEALTH_OFFSET_X,
		HUD.static.HEALTH_OFFSET_Y
	)
end

return HUD
