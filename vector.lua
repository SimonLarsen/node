local vector = {}

function vector.length(x, y)
	return math.sqrt(x^2 + y^2)
end

function vector.normalize(x, y)
	local len = vector.length(x, y)
	return x/len, y/len
end

return vector
