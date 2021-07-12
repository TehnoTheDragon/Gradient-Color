function GetFile()
	print("Enter path to *.txt:")
	local filepath = io.read()

	local file = io.open(filepath, 'r')

	if file == nil then
		while file == nil do
			filepath = io.read()
			if filepath == "stop" then
				return nil
			end
			file = io.open(filepath, 'r')
		end
	end

	return file
end

function ReadFile(file)
	local content = "No file"
	if file then
		content = file:read("*all")
		return content
	end
	return content
end

-- Lerp
local function Lerp(a, b, c)
	return a + c * (b - a)
end

-- Color
function Color(r, g, b)
	local color = {}
	color.r = math.floor(r)
	color.g = math.floor(g)
	color.b = math.floor(b)
	function color.lerp(o, a)
		return Color(Lerp(color.r, o.r, a), Lerp(color.g, o.g, a), Lerp(color.b, o.b, a))
	end
	function color.hex()
		local hex = (color.r * 0x10000) + (color.g * 0x100) + (color.b * 0x1)
		return "#" .. string.format("%02X", hex)
	end
	function color.tostring()
		return ("rgb(%d, %d, %d)"):format(color.r, color.g, color.b)
	end
	return color
end
-- Regex
function DeleteTags(text)
	text = text:gsub("%[center%]%s?", "")
	text = text:gsub("%[/center%]%s?", "")
	return text
end

function ColorMarks(text)
	text = text:gsub("\n", "(COLOR_END)\n(COLOR_BEGIN)")
	text = text:gsub("^", "(COLOR_BEGIN)")
	return text
end

function GradientText(text, _begin, _finish)
	text = ColorMarks(text)

	text = text:gsub("%(COLOR_END%)", "[/color]")

	local len = 0

	text:gsub("%(COLOR_BEGIN%)", function()
		len = len + 1
	end)

	local current_color = _begin
	local alpha = 1 / len

	text = text:gsub("%(COLOR_BEGIN%)", function()
		local color = "[color="..current_color.hex().."]"
		current_color = current_color.lerp(_finish, alpha)
		return color
	end)

	return text
end

print("Gradient Color")
print("Made by TehnoDragon (7/12/2021)")
print()

local text = ReadFile(GetFile())

text = DeleteTags(text)

print("Generate Text")

text = GradientText(text, Color(255, 255, 0), Color(255, 0, 255))

print("Creating new file")

local file = io.open("gradient_text.txt", "w")
file:write(text)
file:close()

print("Finish")