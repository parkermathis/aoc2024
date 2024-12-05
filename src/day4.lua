function Part1 (file_path)
    local file = assert(io.open(file_path, "r"), "Failed to open file")
    local xmas_count = 0

    local lines = {}
    for l in file:lines() do
    	table.insert(lines, l)
    end
    file:close()

    for y,line in ipairs(lines) do
		for x=1, #line, 1 do
			if line:sub(x,x) == "X" then
				if Find_Pattern(lines,"MAS", x, y, 1, 0) then xmas_count = xmas_count + 1 end
				if Find_Pattern(lines,"MAS", x, y, 1, 1) then xmas_count = xmas_count + 1 end
				if Find_Pattern(lines,"MAS", x, y, 0, 1) then xmas_count = xmas_count + 1 end
				if Find_Pattern(lines,"MAS", x, y, -1, 1) then xmas_count = xmas_count + 1 end
				if Find_Pattern(lines,"MAS", x, y, -1, 0) then xmas_count = xmas_count + 1 end
				if Find_Pattern(lines,"MAS", x, y, -1, -1) then xmas_count = xmas_count + 1 end
				if Find_Pattern(lines,"MAS", x, y, 0, -1) then xmas_count = xmas_count + 1 end
				if Find_Pattern(lines,"MAS", x, y, 1, -1) then xmas_count = xmas_count + 1 end
			end
		end
    end

    return xmas_count
end

function Find_Pattern (grid, pattern, cx, cy, ix, iy)
	for i=1,#pattern,1 do
		local x = (i * ix) + cx
		local y = (i * iy) + cy
		local match = pattern:sub(i,i)

		local line = grid[y]
		if line == nil then return false end

		if line:sub(x,x) ~= nil and line:sub(x,x) == match then
		else
			return false
		end
	end
	return true
end

function Part2 (file_path)
    local file = assert(io.open(file_path, "r"), "Failed to open file")
    local xmas_count = 0

    local lines = {}
    for l in file:lines() do
    	table.insert(lines, l)
    end
    file:close()

    for y,line in ipairs(lines) do
		for x=1, #line, 1 do
			if line:sub(x,x) == "A" then
				if Find_Pattern_Cross(lines, x, y) then xmas_count = xmas_count + 1 end
			end
		end
    end

    return xmas_count
end

function Find_Pattern_Cross(grid, cx, cy)
	if grid[cy-1] ~= nil and grid[cy+1] ~= nil then
		if cx-1 >= 1 and cx+1 <= #grid then
			local chars = {}
			for y = cy - 1, cy + 1, 1 do
				for x = cx - 1, cx + 1, 1 do
					table.insert(chars, grid[y]:sub(x,x))
				end
			end

			if (chars[1] == "M" and chars[9] == "S") or
			   (chars[9] == "M" and chars[1] == "S") then
				if (chars[7] == "M" and chars[3] == "S") or
				   (chars[3] == "M" and chars[7] == "S") then
				   	return true
			   end
			end

			if (chars[7] == "M" and chars[3] == "S") or
			   (chars[3] == "M" and chars[7] == "S") then
				if (chars[1] == "M" and chars[9] == "S") or
				   (chars[9] == "M" and chars[1] == "S") then
					return true
				end
			end
		end
	end
	return false
end

local file_path = "./input/day4.txt"
local count1 = Part1(file_path)
print("Part 1 XMAS count: ", count1)
local count2 = Part2(file_path)
print("Part 2 XMAS count: ", count2)
