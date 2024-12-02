
function Part1 (filename)
    local file = assert(io.open(filename,"r"), "failed to open file")
    local nextNum = file:read("*number")

    local left = {}
    local right = {}
    local index = 1

    while nextNum ~= nil do
	left[index] = nextNum

	nextNum = file:read("*number")
	right[index] = nextNum

	index = index + 1
	nextNum = file:read("*number")
    end

    file:close()

    table.sort(left)
    table.sort(right)

    local sum = 0
    for i, n in ipairs(left) do
	if n > right[i] then
	    sum = sum + (n - right[i])
	elseif n < right[i] then
	    sum = sum + (right[i] - n)
	end
    end

    return sum
end

function Part2 (filename)
    local file = assert(io.open(filename,"r"), "failed to open file")
    local nextNum = file:read("*number")

    local left = {}
    local right = {}
    local index = 1

    while nextNum ~= nil do
    	left[index] = nextNum

	nextNum = file:read("*number")
	right[index] = nextNum

	index = index + 1
	nextNum = file:read("*number")
    end

    file:close()

    local sum = 0
    for _, n in ipairs(left) do
    	local mult = 0

	for _, n2 in ipairs(right) do
	    if n2 == n then
		mult = mult + 1
	    end
	end

	sum = sum + (n * mult)
    end

    return sum
end


local sum1 = Part1("./day1_input.txt")
print("Part 1 Solution: "..sum1)
local sum2 = Part2("./day1_input.txt")
print("Part 2 Solution: "..sum2)
