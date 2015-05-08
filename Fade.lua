local Fade = class("Fade", Entity)

Fade.static.FADE_IN = 0
Fade.static.FADE_OUT = 1

function Fade:initialize(dir, time, color)
	Entity.initialize(self, 0, 0, -1000)

	self.dir = dir
	self.total_time = time
	self.time = time
	self.color = color or {0, 0, 0}
end

function Fade:update(dt)
	self.time = self.time - dt
	if self.time <= 0 then
		self:kill()
	end
end

function Fade:gui()
	local alpha
	if self.dir == Fade.static.FADE_IN then
		alpha = self.time / self.total_time * 255
	else
		alpha = 255 - self.time / self.total_time * 255
	end

	love.graphics.setColor(self.color[1], self.color[2], self.color[3], alpha)

	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)

	love.graphics.setColor(255, 255, 255, 255)
end

return Fade
