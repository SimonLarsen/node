local PanicOverlay = class("PanicOverlay", Entity)

PanicOverlay.static.TIME = 0.5
PanicOverlay.static.MAX_FACTOR = 0.04

function PanicOverlay:initialize()
	Entity.initialize(self, 0, 0, 8);
	self:setName("panicoverlay")

	self.shader = love.graphics.newShader(Resources.getShader("panic.lua").pixelcode)
	self.time = 0
end

function PanicOverlay:update(dt)
	self.time = self.time - dt
end

function PanicOverlay:draw()
	if self.time > 0 then
		self.shader:send("factor", self.time / PanicOverlay.static.TIME * PanicOverlay.static.MAX_FACTOR)
		self.scene:drawFullscreenShader(self.shader)
	end
end

function PanicOverlay:panic()
	self.time = PanicOverlay.static.TIME
end

return PanicOverlay
