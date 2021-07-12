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

function HexToColor(hex)
	hex = hex:gsub("#", "")
	local r, g, b = hex:match("(%w%w)(%w%w)(%w%w)")
	local function convert(h)
		return tonumber("0x"..h)
	end
	return Color(convert(r), convert(g), convert(b))
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

	local position = 0
	text = text:gsub("%(COLOR_BEGIN%)", function()
		local color = "[color="..current_color.hex().."]"
		current_color = current_color.lerp(_finish, alpha)
		position = position + 1
		if position < len then
			return color
		else
			return ""
		end
	end)

	return text
end

local function ReadColor()
	print("Red")
	r = io.read()

	print("Green")
	g = io.read()

	print("Blue")
	b = io.read()

	return Color(r, g, b)
end

print("Gradient Color")
print("Made by TehnoDragon (7/12/2021)")
print()

-- Getting and Reading file
local text = ReadFile(GetFile())

-- Getting First and Second Colors
local FIRST_COLOR = Color(255, 255, 255)
local SECOND_COLOR = Color(0, 0, 0)

print("Select Input Color Type: (0 - RGB), (1 - HEX)")
local INPUT_COLOR_TYPE = tonumber(io.read())

if INPUT_COLOR_TYPE == 0 then
	print("(RGB) Enter First Color:")
	FIRST_COLOR = ReadColor()

	print("(RGB) Enter Second Color:")
	SECOND_COLOR = ReadColor()
elseif INPUT_COLOR_TYPE == 1 then
	print("(HEX) Enter First Color:")
	FIRST_COLOR = HexToColor(io.read())

	print("(HEX) Enter Second Color:")
	SECOND_COLOR = HexToColor(io.read())
else
	print(INPUT_COLOR_TYPE .. ": Input Color Type unsupported")
	os.execute("pause")
	exit()
end

-- Removing Tags
text = DeleteTags(text)

-- Generating Gradient
text = GradientText(text, FIRST_COLOR, SECOND_COLOR)

-- Creating new file
local file = io.open("gradient_text.txt", "w")
file:write(text)
file:close()