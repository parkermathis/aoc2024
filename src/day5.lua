function Check_Page_Order (file_path)
    local file = assert(io.open(file_path, "r"))
    local pages = {}
    local pages_or_updates = true
    local sum = 0

    for l in file:lines() do
	if l == "" then pages_or_updates = false end

	if pages_or_updates == true then
	    local _, _, pg1, pg2 = string.find(l, "(%d%d)%|(%d%d)")
	    table.insert(pages, pg1..pg2)
	else
	    if l ~= "" then
		local up = {}
		for number in string.gmatch(l, "%d%d") do
		    table.insert(up, number)
		end

		local fail_count = 0
		for i = 1, #up-1, 1 do
		    for j = i + 1, #up,1 do
			if Table_Contains_Num(up[i]..up[j], pages) == false then
			    if Table_Contains_Num(up[j]..up[i], pages) == true then
				fail_count = fail_count + 1
			    end
			end
		   end
		end

		if fail_count == 0 then
		    sum = sum + tonumber(up[math.ceil(#up/2)])
		end
	    end
	end
    end
    file:close()
    return sum
end

function Correct_Page_Order (file_path)
    local file = assert(io.open(file_path, "r"))
    local pages = {}
    local pages_or_updates = true
    local sum = 0

    for l in file:lines() do
	if l == "" then pages_or_updates = false end

	if pages_or_updates == true then
	    local _, _, pg1, pg2 = string.find(l, "(%d%d)%|(%d%d)")
	    table.insert(pages, pg1..pg2)
	else
	    if l ~= "" then
		local up = {}
		for number in string.gmatch(l, "%d%d") do
		    table.insert(up, number)
		end

		local is_ordered = false
		local has_bad_order = false
		local i, j = 1, 2

		while is_ordered == false do
		    if Table_Contains_Num(up[i]..up[j], pages) == true then
		    	i, j = Advance_Numbering(i, j, #up)
			if i >= #up then is_ordered = true end
		    else
			if Table_Contains_Num(up[j]..up[i], pages) == false then
			    i, j = Advance_Numbering(i, j, #up)
			    if i >= #up then is_ordered = true end
			else
			    has_bad_order = true
			    up[i], up[j] = up[j], up[i]
			    i, j = 1, 1
			end
		    end
		end

		if has_bad_order == true then
		    sum = sum + up[math.ceil(#up/2)]
		end
	    end
	end
    end
    file:close()
    return sum
end

function Advance_Numbering(a, b, len)
    b = b + 1 
    if b > len then
	a = a + 1 
	b = a + 1
    end

    return a, b
end

function Table_Contains_Num(num, tbl)
    for _, v in ipairs(tbl) do
    	if v == num then return true end
    end

    return false
end

local file_path = "./input/day5.txt"
print("Part 1 Sum: ", Check_Page_Order(file_path))
print("Part 2 Sum: ", Correct_Page_Order(file_path))
