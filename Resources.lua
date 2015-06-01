local Resources = {}

Resources.SOUND_INTERVAL = 0.1

local images = {}
local animators = {}
local fonts = {}
local sounds = {}
local sound_last_play = {}
local shaders = {}

function Resources.getImage(path)
	if images[path] == nil then
		images[path] = love.graphics.newImage("data/images/" .. path)
	end
	return images[path]
end

function Resources.getAnimator(path)
	if animators[path] == nil then
		local f = love.filesystem.load("data/animators/" .. path)
		animators[path] = f()
	end
	return animators[path]
end

function Resources.getFont(path, size)
	if fonts[path .. size] == nil then
		fonts[path .. size] = love.graphics.newFont("data/fonts/" .. path, size)
	end
	return fonts[path .. size]
end

function Resources.getSound(path)
	if sounds[path] == nil then
		sounds[path] = love.audio.newSource("data/sounds/" .. path)
	end
	return sounds[path]
end

function Resources.playSound(path, volume)
	if sound_last_play[path] == nil
	or love.timer.getTime() - sound_last_play[path] > Resources.SOUND_INTERVAL then
		sound_last_play[path] = love.timer.getTime()

		local sound = Resources.getSound(path)
		sound:setVolume(volume or 1)
		love.audio.play(sound)
	end
end

function Resources.getShader(path)
	if shaders[path] == nil then
		local f = love.filesystem.load("data/shaders/" .. path)
		shaders[path] = f()
	end
	return shaders[path]
end

return Resources
