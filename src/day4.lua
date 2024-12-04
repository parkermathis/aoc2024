function Part1 (file_name)
    local file = assert(io.open(file_name, "r"), "Failed to open file")
    local xmas_count = 0

    local lines = {}
    for l in file:lines() do
    	table.insert(lines, l)
    end

    file:close()

    for y,line in ipairs(lines) do
	print(line)
    	local x = 1
	local good_xmas = false
	for char in line:gmatch"." do
	    if char == "X" then
		print("Found X at X: "..x.." Y: "..y)
		if Find_Letter(lines, "MAS", x, y) then 
		    print("Found XMAS starting at X: "..x.." Y: "..y)
		    xmas_count = xmas_count + 1 
		end
	    end

	    x = x + 1
	end
    end

    return xmas_count
end

function Find_Letter (grid, rem, cx, cy, bx, by)
    bx = bx or {-1, 0, 1}
    by = by or {-1, 0, 1}
    local letter = rem:sub(1,1)

    for _, x in ipairs(bx) do
	local tx = cx + x
	for _, y in ipairs(by) do
	    local ty = cy + y
	    local test_line = grid[ty]
	    if test_line ~= nil then
	    	local test_char = test_line:sub(tx,tx)
		--print("X: "..tx.." Y: "..ty.." L: "..test_char.." M: "..letter)
		if test_char ~= nil then
		    if test_char == letter then
			print("Found "..test_char.." at X: "..tx.." Y: "..ty)
			if #rem <= 1 then return true end
		    	local new_rem = rem:sub(2,#rem)
			if Find_Letter(grid, new_rem, tx, ty, {x}, {y}) == true then
				return true
			end
		    end
		end
	    end
	end
    end

    return false
end

local file_path = "./test/day4.txt" 
local count1 = Part1(file_path)
print("Part 1 XMAS count: ", count1)
