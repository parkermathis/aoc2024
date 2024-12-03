function Part1 (file_path)

    local safe_reports = 0

	local lines = {}
    local file = assert(io.open(file_path, "r"), "failed to open file")
	for line in file:lines() do
		table.insert(lines, line)
	end
	file:close()

	for _, l in ipairs(lines) do
		local split = {}
		local sort_inc = {}
		local sort_dec = {}

		for level in string.gmatch(l, "([^".."%s".."]+)") do
			table.insert(split, tonumber(level))
			table.insert(sort_inc, tonumber(level))
			table.insert(sort_dec, tonumber(level))
		end

		local safe = false
		table.sort(sort_inc)
		table.sort(sort_dec, function (a, b) return a > b end)

		if table.concat(split) == table.concat(sort_inc) then
			safe = Part1_test_recurse(split, false)
		elseif table.concat(split) == table.concat(sort_dec) then
			safe = Part1_test_recurse(split, true)
		end

		--print("Testing Report: "..l.." Result: "..tostring(safe))
		if safe then safe_reports = safe_reports + 1 end
	end
	return safe_reports
end

function Part1_test_recurse (list, decreasing)
	local safe = false

	if decreasing == true and list[1] - list[2] > 0 and list[1] - list[2] <= 3 then
		safe = true
	elseif decreasing == false and list[2] - list[1] > 0 and list[2] - list[1] <= 3 then
		safe = true
	end

	if safe == true then
		table.remove(list, 1)
		if #list < 2 then
			return true
		else
			return Part1_test_recurse(list, decreasing)
		end
	end

	return false
end

function Part2 (file_path)

    local safe_reports = 0

	local lines = {}
    local file = assert(io.open(file_path, "r"), "failed to open file")
	for line in file:lines() do
		table.insert(lines, line)
	end
	file:close()

	for _, l in ipairs(lines) do
		local report = {}

		for level in string.gmatch(l, "([^".."%s".."]+)") do
			table.insert(report, tonumber(level))
		end

		--print("Testing Report: "..l.." Result: "..tostring(safe))
		if Part2_test_recurse(report) then safe_reports = safe_reports + 1 end
	end
	return safe_reports
end

function Part2_test_recurse (list, len, a, b)
	local safe = false

	len = len or #list
	a = a or 1
	b = b or 0

	for i = a, (len - 2), 1 do
		if not(Check_seq(list, i, b)) then
			if b ~= 0 then
				return false
			else
				return
					((i == 1) and Part2_test_recurse(list, len - 1, i, i)) or
					((i == 1) and Part2_test_recurse(list, len - 1, i, i + 1)) or
					((i == 1) and Part2_test_recurse(list, len - 1, i, i + 2)) or
					((i > 1) and Part2_test_recurse(list, len - 1, i - 1, i)) or
					((i > 1) and Part2_test_recurse(list, len-1, i - 1, i + 1)) or
					Part2_test_recurse(list, len - 1, i, i + 2)
			end
		end
	end

	return true
end

function Check_seq(list, i, e)
	local a = Get_value(list, i, e)
	local b = Get_value(list, i + 1, e)
	local c = Get_value(list, i + 2, e)

	return 
		Check_seq_dir(a, b, c) and
		Check_seq_diff(a, b) and
		Check_seq_diff(b, c)
end

function Check_seq_dir (a, b, c)
	return
		((a < b) and (b < c)) or
		((a > b) and (b > c))
end

function Check_seq_diff(a, b)
	local delta = math.abs(b - a)
	return (delta > 0) and (delta <= 3)
end

function Get_value(list, i, e)
	if (e == 0) or (i < e) then
		return list[i]
	else
		return list[i+1]
	end
end

local path = "./day2_input.txt"
local safe_reports = Part1(path)
print("Part 1 - Safe Reports: "..safe_reports)
safe_reports = Part2(path)
print("Part 2 - Safe Reports: "..safe_reports)
