local Resources = {}

local images = {}
local animators = {}
local fonts = {}
local sounds = {}
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
	local sound = Resources.getSound(path)
	sound:setVolume(volume or 1)
	love.audio.play(sound)
end

function Resources.getShader(path)
	if shaders[path] == nil then
		local f = love.filesystem.load("data/shaders/" .. path)
		local data = f()
		shaders[path] = love.graphics.newShader(data.pixelcode)
	end
	return shaders[path]
end

return Resources
