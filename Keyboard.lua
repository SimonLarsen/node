local Keyboard = {}

local state = {}
state.down = {}
state.pressed = {}
state.released = {}

function Keyboard.wasPressed(k)
	return state.pressed[k]
end

function Keyboard.wasReleased(k)
	return state.released[k]
end

function Keyboard.isDown(k)
	return state.down[k]
end

function Keyboard.keypressed(k)
	state.down[k] = true
	state.pressed[k] = true
end

function Keyboard.keyreleased(k)
	state.down[k] = false
	state.released[k] = true
end

function Keyboard.clear()
	for i,v in pairs(state.pressed) do
		state.pressed[i] = false
	end
	for i,v in pairs(state.released) do
		state.released[i] = false
	end
end

return Keyboard
