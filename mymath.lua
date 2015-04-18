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
