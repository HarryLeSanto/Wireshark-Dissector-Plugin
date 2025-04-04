local data_field = Field.new("data")

local function NewDissector()
	local message = "Enter payload here.";

    local function DissectorMenu(name, protocol, port)
        local window = TextWindow.new("New Dissector - " .. name);

		local function GenerateDissector()
			local filename = protocol .. "_dissector.lua"
			local path = ("C:\\Users\\Harry\\AppData\\Roaming\\Wireshark\\plugins") .. "\\" .. filename
			local file = io.open(path, "w")
			file:write(window:get_text())
			file:close()
		end


        window:set(message);
		window:set_editable(true);

		window:add_button("Generate", GenerateDissector)
		window:add_button("Clear", function() window:clear() end)
		window:add_button("Cancel", function() window:close() end)
    end

    new_dialog("New Dissector", DissectorMenu, "Name", "Protocol", "Port")
end

-- Create the menu entry
register_menu("Dissector Generator", NewDissector, MENU_TOOLS_UNSORTED)
