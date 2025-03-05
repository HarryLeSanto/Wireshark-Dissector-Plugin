local function NewDissector()
    local function DissectorMenu(name, description, protocol)
        local window = TextWindow.new("New Dissector - " .. name);
        local message = "Enter payload here.";
        window:set(message);
		window:set_editable(true);
    end

    new_dialog("New Dissector", DissectorMenu, "Name", "Description", "Protocol")
end

-- Create the menu entry
register_menu("Dissector Generator", NewDissector, MENU_TOOLS_UNSORTED)
