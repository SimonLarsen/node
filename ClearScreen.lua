local ClearScreen = class("ClearScreen", Entity)

function ClearScreen:initialize(score, time)
	Entity.initialize(self, 0, 0, -200)

	self.score = score
	self.time = time

	self.font = Resources.getFont("dd.ttf", 12)
	self.img_bg = Resources.getImage("pausebg.png")
end

function ClearScreen:update(dt)

end

function ClearScreen:gui()
	love.graphics.setFont(self.font)
	love.graphics.draw(self.img_bg, WIDTH/2-150, HEIGHT/2-100)

	love.graphics.printf("LEVEL COMPLETE", 0, HEIGHT/2-60, WIDTH, "center")
	love.graphics.printf("SCORE: " .. self.score, 0, HEIGHT/2-20, WIDTH, "center")
	love.graphics.printf("TIME: " ..  util.secsToString(self.time), 0, HEIGHT/2, WIDTH, "center")

	love.graphics.printf("PRESS 'ENTER'", 0, HEIGHT/2+40, WIDTH, "center")
	love.graphics.printf("TO CONTINUE", 0, HEIGHT/2+60, WIDTH, "center")
end

return ClearScreen
