function GetFile()
	print("Enter path to *.txt: (or drop text file in terminal)")
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

function RainbowText(text, colorbuffer)
	local newtext = ""
    local function getChar(index)
        return text:sub(index, index)
    end

    local color_buffer_length = #colorbuffer;
    local color_position = 0;
    local current_color;
    local function nextColor()
        color_position = color_position + 1
        if (color_position > color_buffer_length) then
            color_position = 1
        end
        current_color = colorbuffer[color_position];
    end
    nextColor()

    for index = 1, text:len() do
        local currentCharacter = getChar(index)
        if string.match(currentCharacter, "[^%s]") then
            newtext = newtext .. "[color="..current_color.hex().."]" .. currentCharacter .. "[/color]"
            nextColor()
        else
            newtext = newtext .. currentCharacter
        end
    end

    return newtext;
end

local function ReadColor()
	print("Red")
	local r = io.read()

	print("Green")
	local g = io.read()

	print("Blue")
	local b = io.read()

	return Color(r, g, b)
end

print("Rainbow Color")
print("Made by TehnoDragon (8/23/2021)")
print()

-- Getting and Reading file
local text = ReadFile(GetFile())

-- Getting First and Second Colors
local COLOR_BUFFER = {}

print("Select Input Color Type: (0 - RGB), (1 - HEX), (2 - \"RAINBOW\" (no) )")
local INPUT_COLOR_TYPE = tonumber(io.read())

if INPUT_COLOR_TYPE == 0 then
	while true do
        print("(RGB) Enter Color:")
	    table.insert(COLOR_BUFFER, ReadColor());

        print("*any* - next, S - stop")
        local char = io.read()
        if char == "S" then
            break
        end
    end
elseif INPUT_COLOR_TYPE == 1 then
	while true do
        print("(HEX) Enter Color:")
        table.insert(COLOR_BUFFER, HexToColor(io.read()));

        print("*any* - next, S - stop")
        local char = io.read()
        if char == "S" then
            break
        end
    end
elseif INPUT_COLOR_TYPE == 2 then
	table.insert(COLOR_BUFFER, Color(228, 2, 3))
	table.insert(COLOR_BUFFER, Color(255, 140, 0))
	table.insert(COLOR_BUFFER, Color(255, 237, 2))
	table.insert(COLOR_BUFFER, Color(1, 127, 39))
	table.insert(COLOR_BUFFER, Color(0, 77, 255))
	table.insert(COLOR_BUFFER, Color(117, 7, 135))
else
	print(INPUT_COLOR_TYPE .. ": Input Color Type unsupported")
	os.execute("pause")
	os.exit()
end

-- Removing Tags
text = DeleteTags(text)

-- Generating Rainbow
text = RainbowText(text, COLOR_BUFFER)

-- Creating new file
local file = io.open("rainbow_text.txt", "w")
file:write(text)
file:close()