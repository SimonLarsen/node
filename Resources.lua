local Resources = {}

local images = {}

function Resources.getImage(path)
	if images[path] == nil then
		images[path] = love.graphics.newImage(path)
	end
	return images[path]
end

return Resources
