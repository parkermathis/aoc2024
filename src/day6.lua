Directions = {"^", ">", "v", "<"}

function Track_Guard(file_path)
    local file = assert(io.open(file_path, "r"), "Failed to open file")

    local init_posn = {x = 1, y = 1}
    local count = 0
    local tiles = {}
    local guard_rot = 1

    local x,y = 1,1
    for l in file:lines() do
	x = 1
	local row = {}
	--print(l)
    	for c in string.gmatch(l, ".") do
	    table.insert(row, c)
	    if string.find(c,"[<>v^]") ~= nil then init_posn = {x = x, y = y} end
	    x = x + 1
    	end
	table.insert(tiles, row)
	y = y + 1
    end

    file:close()

    local curr_posn = init_posn

    while true do
	local next_posn = {x = 1, y = 1}

	if guard_rot == 1 then
	    next_posn = {x = curr_posn.x, y = (curr_posn.y - 1)}
	elseif guard_rot == 2 then
	    next_posn = {x = (curr_posn.x + 1), y = curr_posn.y}
	elseif guard_rot == 3 then
	    next_posn = {x = curr_posn.x, y = (curr_posn.y + 1)}
	else
	    next_posn = {x = (curr_posn.x - 1), y = curr_posn.y}
	end

	if next_posn.x < 1 or next_posn.x > #tiles[1] or next_posn.y < 1 or next_posn.y > #tiles then
	    tiles[curr_posn.y][curr_posn.x] = "X"
	    count = count + 1
	    break
	end

	if tiles[next_posn.y][next_posn.x] == "#" then
	    guard_rot = guard_rot + 1
	    if guard_rot > 4 then guard_rot = 1 end
	else
	    if tiles[curr_posn.y][curr_posn.x] ~= "X" then
	    	tiles[curr_posn.y][curr_posn.x] = "X"
		count = count + 1
	    end
	    curr_posn = { x = next_posn.x, y = next_posn.y}
	end
    end

    return count
end


function Try_Loop_Guard(file_path)
    local file = assert(io.open(file_path, "r"), "Failed to open file")

    local init_posn = {x = 1, y = 1, r = 1}
    local count = 0
    local tiles = {}
    local obstructions = {}

    local x,y = 1,1
    for l in file:lines() do
	x = 1
	local row = {}
    	for c in string.gmatch(l, ".") do
	    table.insert(row, c)
	    if string.find(c,"[<>v^]") ~= nil then init_posn = {x = x, y = y, r = 1} end
	    x = x + 1
    	end
	table.insert(tiles, row)
	y = y + 1
    end

    file:close()

    local curr_posn = {x = init_posn.x, y = init_posn.y, r = init_posn.r}
    print("Initial x: "..curr_posn.x.." y:"..curr_posn.y.." r:"..curr_posn.r)
    print("Width: "..#tiles[1].." Height: "..#tiles)
    local num_tiles = #tiles[1] * #tiles

    while true do
	local next_posn = {x = 1, y = 1, r = curr_posn.r}

	if curr_posn.r == 1 then
	    next_posn.x = curr_posn.x
	    next_posn.y = curr_posn.y - 1
	elseif curr_posn.r == 2 then
	    next_posn.x = curr_posn.x + 1
	    next_posn.y = curr_posn.y
	elseif curr_posn.r == 3 then
	    next_posn.x = curr_posn.x
	    next_posn.y = curr_posn.y + 1
	else
	    next_posn.x = curr_posn.x - 1
	    next_posn.y = curr_posn.y
	end

	if next_posn.x < 1 or next_posn.x > #tiles[1] or next_posn.y < 1 or next_posn.y > #tiles then
	    break
	elseif tiles[next_posn.y][next_posn.x] == "#" then
	    curr_posn.r = curr_posn.r + 1
	    if curr_posn.r > 4 then curr_posn.r = 1 end
	else
	    --if next_posn.y >= init_posn.y and next_posn.x ~= init_posn.x then
	    print("Testing obstruction at x: "..next_posn.x.." y: "..next_posn.y)
		if Run_Simulation(tiles, curr_posn, next_posn, num_tiles) then
		    if Contains_Value(next_posn.x..next_posn.y, obstructions) == false then
		    	table.insert(obstructions, next_posn.x..next_posn.y)
			tiles[next_posn.y][next_posn.x] = "O"
			print("Valid Loop. "..#obstructions)
		    else
			print ("Valid Loop but duplicate")
		    end
		else
		    print ("Invalid Loop")
		end
	    --end
	    curr_posn = {x = next_posn.x, y = next_posn.y, r = next_posn.r}
	end
    end
    for _,v in ipairs(tiles) do print(table.concat(v,"")) end
    return #obstructions
end

function Run_Simulation(grid, start, obstruct)
    local curr_posn = {x = start.x, y = start.y, r = start.r}
    local visited_points = {}

    local initial_char = grid[obstruct.y][obstruct.x]
    grid[obstruct.y][obstruct.x] = "#"

    while true do
	local next_posn = {x = 1, y = 1, r = curr_posn.r}

	if curr_posn.r == 1 then
	    next_posn.x = curr_posn.x
	    next_posn.y = curr_posn.y - 1
	elseif curr_posn.r == 2 then
	    next_posn.x = curr_posn.x + 1
	    next_posn.y = curr_posn.y
	elseif curr_posn.r == 3 then
	    next_posn.x = curr_posn.x
	    next_posn.y = curr_posn.y + 1
	else
	    next_posn.x = curr_posn.x - 1
	    next_posn.y = curr_posn.y
	end

	if next_posn.x < 1 or next_posn.x > #grid[1] or next_posn.y < 1 or next_posn.y > #grid then
	    grid[obstruct.y][obstruct.x] = initial_char
	    return false
	elseif Contains_Value(next_posn.x..next_posn.y..next_posn.r, visited_points) == true then
	    grid[obstruct.y][obstruct.x] = initial_char
	    return true
	else
	    if grid[next_posn.y][next_posn.x] == "#" then
	    	curr_posn.r = curr_posn.r + 1
		if curr_posn.r > 4 then curr_posn.r = 1 end
	    else
		table.insert(visited_points, curr_posn.x..curr_posn.y..curr_posn.r)
		curr_posn = {x = next_posn.x, y = next_posn.y, r = next_posn.r}
	    end
	end
    end
end

function Contains_Value(val, tbl)
    for _, v in ipairs(tbl) do
    	if val == v then return true end
    end

    return false
end

local file_path = "./input/day6.txt" 
print("Part 1 Guard Locations: ", Track_Guard(file_path))
print("Part 2 Guard Loop Locations: ", Try_Loop_Guard(file_path))

