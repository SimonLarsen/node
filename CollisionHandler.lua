local CollisionHandler = {}

function CollisionHandler.checkAll(entities)
	for i=1, #entities do
		for j=i+1, #entities do
			local v = entities[i]
			local w = entities[j]
			if v.collider and w.collider then
				local collision
				if v.collider:getType() == "box" and w.collider:getType() == "box" then
					collision = CollisionHandler.checkBoxBox(v, w)
				end

				if collision == true then
					v:onCollide(w)
					w:onCollide(v)
				end
			end
		end
	end
end

function CollisionHandler.checkBoxBox(a, b)
	if math.abs((a.x+a.collider.ox)-(b.x+b.collider.ox)) > (a.collider.w+b.collider.w)/2
	or math.abs((a.y+a.collider.oy)-(b.y+b.collider.oy)) > (a.collider.h+b.collider.h)/2 then
		return false
	end

	return true
end

function CollisionHandler.checkBoxPoint(a, x, y)
	if x >= a.x + a.collider.ox and x <= a.x + a.collider.ox + a.collider.w
	and y >= a.y + a.collider.oy and y <= a.y + a.collider.oy + a.collider.h then
		return true
	end

	return false
end

function CollisionHandler.checkMapBox(a, b)
	local r = b.collider.w / 2

	for offx = -1, 1, 2 do
		for offy = -1, 1, 2 do
			local cx = math.floor((b.x + offx*r) / a.collider.tilesize)
			local cy = math.floor((b.y + offy*r) / a.collider.tilesize)

			if a.collider.map[cx][cy] == 0 then
				return true
			end
		end
	end

	return false
end

function CollisionHandler.checkClicked(entities)
	if Mouse.wasPressed("l") == false then
		return
	end

	local mx, my = Mouse.getPositionCamera()
	for i,v in ipairs(entities) do
		if v.collider then
			local collision
			if v.collider:getType() == "box" then
				collision = CollisionHandler.checkBoxPoint(v, mx, my)
			end

			if collision then
				local consume = v:onClick(mx, my)
				if consume then
					break
				end
			end
		end
	end
end

return CollisionHandler
