local PauseMenu = class("PauseMenu", Entity)

function PauseMenu:initialize()
	Entity.initialize(self, 0, 0, -1000)
	self:setName("pausemenu")

	self.visible = false
	self.dead = false
	self.font = Resources.getFont("dd.ttf", 12)

	self.img_bg = Resources.getImage("pausebg.png")
end

function PauseMenu:update(dt)
	if Keyboard.wasPressed("escape") then
		self:toggle()
	end

	if self.visible == true and self.dead == false then
		self.scene:setSpeed(0)
	end

	if self.visible == true and Keyboard.wasPressed("r") then
		self.scene:restart()
	end

	if self.visible == true and Keyboard.wasPressed("q") then
		love.event.quit()
	end
end

function PauseMenu:setDead()
	self.dead = true
end

function PauseMenu:toggle()
	self:setVisible(not self.visible)
end

function PauseMenu:setVisible(state)
	self.visible = state

	if self.visible == false then
		self.scene:setSpeed(1)
	end
end

function PauseMenu:gui()
	if self.visible == false then return end

	love.graphics.setFont(self.font)

	love.graphics.draw(self.img_bg, WIDTH/2-150, HEIGHT/2-100)

	love.graphics.setColor(255, 255, 255)
	if self.dead == true then
		love.graphics.printf("YOU DIED", 0, HEIGHT/2-60, WIDTH, "center")
	else
		love.graphics.printf("PAUSED", 0, HEIGHT/2-60, WIDTH, "center")
	end
	love.graphics.printf("PRESS 'R' TO RETRY", 0, HEIGHT/2, WIDTH, "center")
	love.graphics.printf("PRESS 'Q' TO QUIT", 0, HEIGHT/2+30, WIDTH, "center")
end

return PauseMenu
