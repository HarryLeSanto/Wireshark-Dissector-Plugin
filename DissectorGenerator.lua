local function NewDissector()
    local function DissectorMenu(name, protocol, port, format)
        local window = TextWindow.new("Dissector Generator - " .. name)

		-- Check all fields have been populated
		if protocol == "" or port == "" or not tonumber(port) then
			window:set("[Error] Invalid protocol or port.")
			return
		end

		format = string.lower(format)

		if format ~= "udp" and format ~= "tcp" then
			window:set("[Error] You must specify either UDP or TCP. " .. format)
			return
		end

        -- Placeholder text
        local payload_template = [[<field1>0101</field1>
<field2>01010101</field2>]]
        window:set(payload_template)
        window:set_editable(true)

        -- Read html-like tags
        local function ParseFieldsFromPayload(payload)
            local fields = {}
			-- gmatch finds each tag by looking for data surrounded by angle brackets
            for tag, value in payload:gmatch("<(.-)>(.-)</%1>") do
                table.insert(fields, {name = tag, value = value})
            end
            return fields
        end

        -- Code generation
        local function GenerateDissector()
			-- Ensure fields have been entered
            local fields = ParseFieldsFromPayload(window:get_text())
            if #fields == 0 then
                window:append("\n[Error] No valid fields found.")
                return
            end

			-- Generate the code
			-- Define the protocol name and create fields array
            local dissector = {}
            table.insert(dissector, ("local p = Proto(\"%s\", \"%s\")"):format(protocol, name))
            table.insert(dissector, "")
            table.insert(dissector, "local fields = {}")

			-- Generate line of code for each field
            for _, field in ipairs(fields) do
                table.insert(dissector, ("fields.%s = ProtoField.bytes(\"%s.%s\", \"%s\")"):format(
                    field.name, protocol, field.name, field.name))
            end

			-- Add fields to the code file
            table.insert(dissector, "")
            table.insert(dissector, "p.fields = fields")
            table.insert(dissector, "")
            table.insert(dissector, "function p.dissector(buffer, pinfo, tree)")
            table.insert(dissector, ("    pinfo.cols.protocol = \"%s\""):format(protocol))
            table.insert(dissector, "    local subtree = tree:add(p, buffer(), \"" .. protocol .. " Data\")")
            table.insert(dissector, "    local offset = 0")

			-- Each field needs to be added to the subtree after it is defined
            for _, field in ipairs(fields) do
                local length = math.floor(#field.value / 2)
                table.insert(dissector, ("    subtree:add(fields.%s, buffer(offset, %d))"):format(field.name, length))
                table.insert(dissector, ("    offset = offset + %d"):format(length))
            end

			-- Add protocol to the dissector table
            table.insert(dissector, "end")
            table.insert(dissector, "")
            table.insert(dissector, ("DissectorTable.get(\"%s.port\"):add(%s, p)"):format(format, port))

			-- Save the file to the plugins folder
            local filename = protocol:gsub("[^%w_]", "") .. "_dissector.lua"
            local sep = package.config:sub(1,1)
            local path = (os.getenv("APPDATA") or ".") .. sep .. "Wireshark" .. sep .. "plugins" .. sep .. filename

            local file = io.open(path, "w")
            file:write(table.concat(dissector, "\n"))
            file:close()

            window:append("\nDissector saved to: " .. path)
        end

        -- GUI Buttons
        window:add_button("Generate", GenerateDissector)
        window:add_button("Clear", function() window:set("") end)
        window:add_button("Cancel", function() window:close() end)
    end

    new_dialog("New Dissector", DissectorMenu, "Name", "Protocol", "Port", "UDP/TCP")
end

-- Add the button to the menu
register_menu("Dissector Generator", NewDissector, MENU_TOOLS_UNSORTED)