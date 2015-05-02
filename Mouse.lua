local Mouse = {}

local state = {}
state.down = {}
state.pressed = {}
state.released = {}

function Mouse.wasPressed(button)
	return state.pressed[button] == true
end

function Mouse.wasReleased(button)
	return state.released[button] == true
end

function Mouse.isDown(button)
	return state.down[button] == true
end

function Mouse.getPosition()
	local mx, my = love.mouse.getPosition()
	return mx/SCALE, my/SCALE
end

function Mouse.getPositionCamera(camera)
	local mx, my = love.mouse.getPosition()
	return mx/SCALE + camera:getLeft(), my/SCALE + camera:getTop()
end

function Mouse.mousepressed(x, y, button)
	state.down[button] = true
	state.pressed[button] = true
end

function Mouse.mousereleased(x, y, button)
	state.down[button] = false
	state.released[button] = true
end

function Mouse.clear()
	for i,v in pairs(state.pressed) do
		state.pressed[i] = false
	end
	for i,v in pairs(state.released) do
		state.released[i] = false
	end
end

return Mouse
