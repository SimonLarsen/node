local Resources = {}

local images = {}
local animators = {}

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

return Resources
