local Winscreen = class("Winscreen", Scene)

function Winscreen:initialize()
	Scene.initialize(self)

	self.img_bg = Resources.getImage("winscreen.png")
end

function Winscreen:update(dt)
	if Keyboard.wasPressed(" ")
	or Keyboard.wasPressed("return") 
	or Keyboard.wasPressed("escape")
	or Keyboard.wasPressed("q") then
		love.event.quit()
	end
end

function Winscreen:gui()
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)

	local imgw, imgh = self.img_bg:getDimensions()

	local bgscale = HEIGHT / imgh
	love.graphics.draw(self.img_bg, (WIDTH-bgscale*imgw)/2, 0, 0, bgscale, bgscale)
end

return Winscreen
