local GlitchFade = class("GlitchFade", Entity)

GlitchFade.static.FADE_IN = 0
GlitchFade.static.FADE_OUT = 1

function GlitchFade:initialize(dir, time, color)
	Entity.initialize(self, 0, 0, -1000)

	self.dir = dir
	self.total_time = time
	self.time = time
	self.color = color or {0, 0, 0}

	self.dispswitch = 0
	self.disppause = 0

	self.shader = love.graphics.newShader(Resources.getShader("glitch.lua").pixelcode)

	self.shader:send("disp", Resources.getImage("displacement.png"))
end

function GlitchFade:update(dt)
	self.time = self.time - dt
	if self.time <= 0 then
		self:kill()
	end

	self.dispswitch = self.dispswitch - dt
	self.disppause = self.disppause - dt
	if self.dispswitch <= 0 then
		self.dispswitch = love.math.random() * 0.05
		if love.math.random(1, 7) == 1 then
			love.disppause = love.math.random() * 0.2
		else
			self.shader:send("offset", love.math.random())
		end
	end
end

function GlitchFade:draw()
	local alpha
	if self.dir == GlitchFade.static.FADE_IN then
		alpha = self.time / self.total_time * 255
	else
		alpha = 255 - self.time / self.total_time * 255
	end

	love.graphics.setColor(self.color[1], self.color[2], self.color[3], alpha)
	love.graphics.push()
	love.graphics.origin()
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	love.graphics.pop()
	love.graphics.setColor(255, 255, 255, 255)

	if self.disppause < 0 then
		self.shader:send("factor", alpha/255)
		self.scene:drawFullscreenShader(self.shader)
	end
end

return GlitchFade
