function Part1 (file_path)
    local file = assert(io.open(file_path, "r"), "failed to open file")
    local text = file:read("a")
    file:close()

    --print(text)

    local search_start = 1
    local sum = 0

    while search_start < #text do
    	_, match_end, d1, d2 = string.find(text,"mul%((%d+),(%d+)%)", search_start)

	if match_end == nil then break end

	sum = sum + (d1 * d2)
	search_start = match_end
    end

    return sum
end

function Part2 (file_path)
    local file = assert(io.open(file_path, "r"), "failed to open file")
    local text = file:read("a")
    file:close()

    local search_start = 1

    local sum = 0
    local enable = true

    while search_start < #text do
	nxt_mul_start, nxt_mul_end, d1, d2 = string.find(text, "mul%((%d+),(%d+)%)", search_start)
	nxt_dont_start, nxt_dont_end = string.find(text, "don't%(%)", search_start)
	nxt_do_start, nxt_do_end = string.find(text, "do%(%)", search_start)

	if nxt_mul_end == nil then break end

	if (nxt_do_start or #text) < (nxt_dont_start or #text) and (nxt_do_start or #text) < (nxt_mul_start or #text) then
		enable = true
		search_start = (nxt_do_end or #text)
	elseif (nxt_dont_start or #text) < (nxt_do_start or #text) and (nxt_dont_start or #text) < (nxt_mul_start or #text) then
		enable = false
		search_start = (nxt_dont_end or #text)
	elseif (nxt_mul_start or #text) < (nxt_do_start or #text) and (nxt_mul_start or #text) < (nxt_dont_start or #text) then
		if enable == true then sum = sum + (d1 * d2) end
		search_start = (nxt_mul_end or #text)
	end
    end

    return sum
end

local file_path = "./input/day3.txt"
local sum1 = Part1(file_path)
print("Part 1 Sum = ", sum1)
local sum2 = Part2(file_path)
print("Part 2 Sum = ", sum2)
