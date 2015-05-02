function math.movetowards(x, y, dt)
	if math.abs(x - y) <= dt then
		return y
	end
	if x > y then
		return x - dt
	else
		return x + dt
	end
end

function math.sign(x)
	if x < 0 then
		return -1
	else
		return 1
	end
end

function math.signz(x)
	if x < 0 then
		return -1
	elseif x > 0 then
		return 1
	else
		return 0
	end
end

function math.round(x)
	return math.floor(x + 0.5)
end
