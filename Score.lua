local Score = class("Score", Entity)

Score.static.COOLDOWN = 0.5
Score.static.SHOW_TIME = 1.5

function Score:initialize()
	Entity.initialize(self, 0, 0, -200)
	self:setName("score")

	self.quad_numbers = {}
	self.img_text = Resources.getImage("combo_text.png")
	self.offx = 0
	self.offy = 0
	self.next_shake = 0

	self.score = 0
	self.kills = 0
	self.cooldown = 0

	self.combo = 0
	self.time = 0

	local imgw, imgh = self.img_text:getDimensions()
	for ix = 0, 3 do
		for iy = 0, 1 do
			self.quad_numbers[iy*4 + ix + 1] = love.graphics.newQuad(ix*64, iy*64, 64, 64, imgw, imgh)
		end
	end

	self.quad_chain = love.graphics.newQuad(156, 145, 119, 47, imgw, imgh)
	self.quad_node = love.graphics.newQuad(0, 150, 131, 47, imgw, imgh)
end

function Score:update(dt)
	self.time = self.time - dt
	if self.combo > 0 and self.time <= 0 then
		self.score = self.score + (100 + 50*(self.combo-1)) * self.combo
		self.combo = 0
	end

	if self.next_shake > dt then
		self.next_shake = self.next_shake - dt
	else
		self.next_shake = 0.018
		self.offx = love.math.random(0, 1)
		self.offy = love.math.random(0, 1)
	end

	self.cooldown = self.cooldown - dt
	if self.cooldown <= 0 and self.kills > 0 then
		self.kills = 0
	end
end

function Score:addKill()
	self.kills = self.kills + 1
	self.combo = self.kills
	self.cooldown = Score.static.COOLDOWN
	self.time = Score.static.SHOW_TIME
end

function Score:gui()
	if self.combo > 7 then
		love.graphics.draw(self.img_text, self.quad_node, WIDTH-150+self.offx, HEIGHT-100+self.offy)
		love.graphics.draw(self.img_text, self.quad_chain, WIDTH-130+self.offx, HEIGHT-60+self.offy)
	elseif self.combo >= 2 then
		love.graphics.draw(self.img_text, self.quad_numbers[self.combo], WIDTH-200+self.offx, HEIGHT-75+self.offy)
		love.graphics.draw(self.img_text, self.quad_chain, WIDTH-130+self.offx, HEIGHT-60+self.offy)
	end
end

return Score
