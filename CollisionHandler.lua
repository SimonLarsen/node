local CollisionHandler = {}

function CollisionHandler.checkAll(scene)
	local entities = scene:getEntities()

	for i=1, #entities do
		for j=i+1, #entities do
			local v = entities[i]
			local w = entities[j]
			if v.collider and w.collider then
				local collision = false
				if v.collider:getType() == "box" and w.collider:getType() == "box" then
					collision = CollisionHandler.checkBoxBox(v, w)
				elseif v.collider:getType() == "line" and w.collider:getType() == "box" then
					collision = CollisionHandler.checkLineBox(v, w)
				elseif v.collider:getType() == "box" and w.collider:getType() == "line" then
					collision = CollisionHandler.checkLineBox(w, v)
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
	if math.abs(a.x-b.x) > (a.collider.w+b.collider.w)/2
	or math.abs(a.y-b.y) > (a.collider.w+b.collider.w)/4 then
		return false
	end

	return true
end

function CollisionHandler.checkBoxPoint(a, x, y)
	if math.abs(a.x + a.collider.ox - x) < a.collider.w/2
	and math.abs(a.y + a.collider.oy - y) < a.collider.h/2 then
		return true end 
	return false
end

function CollisionHandler.checkMapBox(a, b)
	local r = b.collider.w / 2

	for offx = -1, 1, 2 do
		for offy = -1, 1, 2 do
			local cx = math.floor((b.x + offx*r) / a.collider.tilesize)
			local cy = math.floor((b.y + offy*r) / a.collider.tilesize)

			if a.collider.map:isSolid(cx, cy) then
				return true
			end
		end
	end

	return false
end

function CollisionHandler.checkLineBox(l, a)
	local bx = l.collider.x2 - l.collider.x1
	local by = l.collider.y2 - l.collider.y1
	local blen = math.sqrt(bx^2 + by^2)
	bx = bx/blen
	by = by/blen

	local ax = a.x - l.collider.x1
	local ay = a.y - l.collider.y1

	local a1s = ax * bx + ay * by
	a1s = math.max(0, a1s)
	a1s = math.min(blen, a1s)

	local px = l.collider.x1 + bx * a1s
	local py = l.collider.y1 + by * a1s
	local dist = math.sqrt((a.x - px)^2 + (a.y - py)^2)
	
	return dist < a.collider.w/2
end

function CollisionHandler.checkClicked(scene)
	if Mouse.wasPressed("l") == false then
		return
	end

	local entities = scene:getEntities()

	local mx, my = Mouse.getPositionCamera(scene:getCamera())
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

function CollisionHandler.checkMouseHover(camera, v)
	local mx, my = Mouse.getPositionCamera(camera)
	if v.collider and v.collider:getType() == "box" then
		return CollisionHandler.checkBoxPoint(v, mx, my)
	end

	return false
end

return CollisionHandler
