local GameScene = require("GameScene")
local Fade = require("Fade")

local MainMenuController = class("MainMenuController", Entity)

function MainMenuController:initialize()
	Entity.initialize(self, 0, 0, 0)

	love.mouse.setVisible(true)

	self.img_pressanykey = Resources.getImage("pressanykey.png")
	self.img_menupoints = Resources.getImage("mainmenupoints.png")
	self.img_bg = Resources.getImage("mainmenu.png")
	self.img_underline = Resources.getImage("selection_underline.png")
	self.img_credits = Resources.getImage("credits.png")

	self.highlighted = 0
	self.state = 0
end

function MainMenuController:update(dt)
	self.highlighted = 0

	local mx, my = Mouse.getPosition()

	local menutop = math.max(HEIGHT/2-84, 0.35*HEIGHT) + 10
	if mx >= WIDTH/2-134 and mx <= WIDTH/2+134 then
		if my >= menutop and my < menutop+50 then
			self.highlighted = 1
		elseif my >= menutop+50 and my < menutop+100 then
			self.highlighted = 2
		elseif my >= menutop+100 and my < menutop+150 then
			self.highlighted = 3
		end
	end

	if self.state == 1 then
		if Mouse.wasPressed("l") then
			if self.highlighted == 1 then
				gamestate.switch(GameScene(1))
			elseif self.highlighted == 2 then
				self.state = 2
			elseif self.highlighted == 3 then
				love.event.quit()
			end
		end
	elseif self.state == 0 or self.state == 2 then
		if Keyboard.wasPressed(" ") then
			self.state = 1
		end
	end
end

function MainMenuController:gui()
	local imgw, imgh = self.img_bg:getDimensions()

	local bgscale = HEIGHT / imgh
	love.graphics.draw(self.img_bg, (WIDTH-bgscale*imgw)/2, 0, 0, bgscale, bgscale)

	if self.state == 0 then
		love.graphics.setColor(0, 0, 0, 200)
		love.graphics.rectangle("fill", 0, HEIGHT-80, WIDTH, 30)

		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(self.img_pressanykey, math.floor(WIDTH/2-125), math.floor(HEIGHT-73))
	
	elseif self.state == 1 then
		local menutop = math.floor(math.max(HEIGHT/2-84, 0.35*HEIGHT))
		love.graphics.draw(self.img_menupoints, math.floor(WIDTH/2-134), menutop)

		if self.highlighted > 0 then 
			love.graphics.draw(self.img_underline, math.floor(WIDTH/2-100), menutop+self.highlighted*50)
		end

	elseif self.state == 2 then
		local menutop = math.floor(math.max(HEIGHT/2-84, 0.35*HEIGHT))
		love.graphics.draw(self.img_credits, math.floor(WIDTH/2-134), menutop)
	end
end

return MainMenuController
