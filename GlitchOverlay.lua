local GlitchOverlay = class("GlitchOverlay", Entity)

function GlitchOverlay:initialize()
	Entity.initialize(self, 0, 0, 9)
	self:setName("glitchoverlay")

	self.shader = love.graphics.newShader(Resources.getShader("glitch.lua").pixelcode)
	self.dispswitch = 0
	self.disppause = 0
	self.active = false
	self.glitchfactor = 0
	self.r = 0

	self.shader:send("disp", Resources.getImage("displacement.png"))
end

function GlitchOverlay:update(dt)
	music:setVolume((1-self.glitchfactor)*0.5)
	music_slow:setVolume(self.glitchfactor * 0.5)

	if self.active then
		self.glitchfactor = math.movetowards(self.glitchfactor, 1, 5*dt)
		self.r = self.glitchfactor * math.max(WIDTH/2, HEIGHT)

		self.dispswitch = self.dispswitch - dt
		self.disppause = self.disppause - dt
		if self.dispswitch <= 0 then
			self.dispswitch = love.math.random() * 0.05
			if love.math.random(1,7) == 1 then
				self.disppause = love.math.random() * 0.2
			else
				self.shader:send("offset", love.math.random())
			end
		end
	else
		self.glitchfactor = math.movetowards(self.glitchfactor, 0, 10*dt)
	end
end

function GlitchOverlay:draw()
	love.graphics.setColor(120, 220, 220, 100*self.glitchfactor)
	love.graphics.push()
	love.graphics.origin()
	love.graphics.scale(1, 0.5)
	love.graphics.circle("fill", WIDTH/2, HEIGHT, self.r, 32)
	love.graphics.pop()
	love.graphics.setColor(255, 255, 255)

	if self.active and self.disppause < 0 then
		self.shader:send("factor", self.glitchfactor)
		self.scene:drawFullscreenShader(self.shader)
	end
end

function GlitchOverlay:setActive(s)
	if self.active ~= s then
		if s == true then
			music_slow:seek(2*music:tell())
		else
			music:seek(0.5 * music_slow:tell())
		end
	end

	self.active = s
end

return GlitchOverlay
