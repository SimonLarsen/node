local Player = class("Player", Entity)

Player.static.MOVE_SPEED = 8

function Player:initialize()
	Entity.initialize(self, 0, 0, 0)

	self.image = Resources.getImage("images/test.png")
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
end

function Player:draw()
	love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, 16, 16)
end

return Player
