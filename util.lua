local util = {}

--- Sorts an array using bubble sort
-- @param a Array to sort
-- @param t function taking two arguments (a,b). Returns true if a > b, false otherwise.
function util.bubblesort(a, t)
	while true do
		swapped = false
		for i=2,#a do
			if t(a[i-1], a[i]) == true then
				local tmp = a[i-1]
				a[i-1] = a[i]
				a[i] = tmp
				swapped = true
			end
		end

		if swapped == false then return end
	end
end

function util.insertionsort(a, t)
	for i = 2, #a do
		local j = i
		while j > 1 and t(a[j-1], a[j]) == true do
			local tmp = a[j-1]
			a[j-1] = a[j]
			a[j] = tmp
			j = j - 1
		end
	end
end

function util.seq(from, to)
	local t = {}
	for i=from, to do
		table.insert(t, i)
	end
	return t
end

function util.shuffle(a)
	for i=#a, 2 do
		local j = love.math.random(0, i)
		local tmp = a[j]
		a[j] = a[i]
		a[i] = tmp
	end
	return a
end

return util
