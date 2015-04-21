local Score = require("Score")
local Winscreen = class("Winscreen", Scene)

function Winscreen:initialize()
	Scene.initialize(self)

	self.font = Resources.getFont("dd.ttf", 18)
	self.state = 0
	self.img_bg = Resources.getImage("winscreen.png")
end

function Winscreen:update(dt)
	if Keyboard.wasPressed(" ")
	or Keyboard.wasPressed("return") 
	or Keyboard.wasPressed("escape")
	or Keyboard.wasPressed("q") then
		if self.state == 0 then
			self.state = 1
		elseif self.state == 1 then
			love.event.quit()
		end
	end
end

function Winscreen:gui()
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	love.graphics.setFont(self.font)

	local imgw, imgh = self.img_bg:getDimensions()

	local bgscale = HEIGHT / imgh
	love.graphics.draw(self.img_bg, (WIDTH-bgscale*imgw)/2, 0, 0, bgscale, bgscale)

	if self.state == 1 then
		love.graphics.setColor(0, 0, 0, 240)
		love.graphics.rectangle("fill", 0, HEIGHT/2-40, WIDTH, 80)

		love.graphics.setColor(255, 255, 255)
		love.graphics.printf("TOTAL SCORE: " .. Score.static.total_score, 0, HEIGHT/2-30, WIDTH, "center")
		love.graphics.printf("TOTAL TIME: " .. util.secsToString(Score.static.total_time), 0, HEIGHT/2, WIDTH, "center")
	end

end

return Winscreen
