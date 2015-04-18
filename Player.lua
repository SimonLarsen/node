local Player = class("Player", Entity)

Player.static.MOVE_SPEED = 3

function Player:initialize(x, y)
	Entity.initialize(self, x, y, 0)

	self.image = Resources.getImage("player.png")
	self.crosshair = Resources.getImage("crosshair.png")
end

function Player:update()
	if Keyboard.isDown("a") then
		self.x = self.x - Player.static.MOVE_SPEED
	end
	if Keyboard.isDown("d") then
		self.x = self.x + Player.static.MOVE_SPEED
	end
	if Keyboard.isDown("w") then
		self.y = self.y - Player.static.MOVE_SPEED
	end
	if Keyboard.isDown("s") then
		self.y = self.y + Player.static.MOVE_SPEED
	end

	camera:setPosition(self.x, self.y)
end

function Player:draw()
	love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, 16, 48)
end

function Player:gui()
	local mx, my = Mouse.getPosition()
	love.graphics.draw(self.crosshair, mx, my, 0, 1, 1, 16, 16)
end

return Player
