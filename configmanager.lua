local configmanager = {}
configmanager.__index = configmanager

local httpService = game:GetService("HttpService")

local folder    = "lumina/aftermath"
local subfolder = "lumina/aftermath/settings"
local ignoreset = {}
local _thememanager = nil

local _internalignore = {
	["Config Name"]   = true,
	["Config List"]   = true,
	["Theme"]         = true,
	["Background"]    = true,
	["Section"]       = true,
	["Accent"]        = true,
	["Interactables"] = true,
	["Text"]          = true,
}

local function buildfolder()
	local paths = {
		"lumina",
		"lumina/aftermath",
		"lumina/aftermath/settings",
	}
	for _, path in ipairs(paths) do
		if not isfolder(path) then makefolder(path) end
	end
end

function configmanager.setfolder(name)
	folder    = name
	subfolder = name .. "/settings"
	local parts = {}
	local current = ""
	for segment in (name .. "\\settings"):gmatch("[^\\]+") do
		current = current == "" and segment or (current .. "\\" .. segment)
		table.insert(parts, current)
	end
	for _, path in ipairs(parts) do
		if not isfolder(path) then makefolder(path) end
	end
end

local function allelements(menu)
	local out = {}
	for _, tabdata in ipairs(menu.tabs) do
		for _, sec in ipairs(tabdata.sections) do
			for _, el in ipairs(sec.elements) do
				table.insert(out, el)
			end
		end
	end
	return out
end

local function colorToHex(c)
	return string.format("%02X%02X%02X",
		math.round(c.R * 255),
		math.round(c.G * 255),
		math.round(c.B * 255))
end

local function hexToColor(h)
	h = h:gsub("^#", "")
	local r = tonumber(h:sub(1,2), 16) or 0
	local g = tonumber(h:sub(3,4), 16) or 0
	local b = tonumber(h:sub(5,6), 16) or 0
	return Color3.fromRGB(r, g, b)
end

function configmanager.save(menu, name, options)
	if not name or name:gsub(" ", "") == "" then
		return false, "no config name given"
	end

	buildfolder()
	local savetheme = options == nil or options.savetheme ~= false
	local ignore    = options and options.ignore or {}
	local ignmap    = {}
	for _, v in ipairs(ignore) do ignmap[v] = true end
	for k in pairs(ignoreset) do ignmap[k] = true end

	local data = { objects = {} }

	for _, el in ipairs(allelements(menu)) do
		if not el.label or el.label == "" then continue end
		if ignmap[el.label] then continue end
		if _internalignore[el.label] then continue end

		local obj = nil

		if el.type == "toggle" then
			obj = {
				type  = "Toggle",
				idx   = el.label,
				value = el.state,
			}
			if el.keybind and el.boundkey then
				obj.boundkey = el.boundkey.Name
			end

		elseif el.type == "slider" then
			obj = {
				type  = "Slider",
				idx   = el.label,
				value = tostring(el.value),
			}

		elseif el.type == "colorpicker" then
			obj = {
				type  = "ColorPicker",
				idx   = el.label,
				value = colorToHex(el.color),
			}

		elseif el.type == "dropdown" then
			obj = {
				type  = "Dropdown",
				idx   = el.label,
				value = el.selected,
				multi = false,
			}

		elseif el.type == "multiselect" or el.type == "searchbox" then
			local vals = {}
			for k in pairs(el.selected) do table.insert(vals, k) end
			obj = {
				type  = "Dropdown",
				idx   = el.label,
				value = vals,
				multi = true,
			}

		elseif el.type == "textbox" then
			local tb = el.textbox
			obj = {
				type = "Input",
				idx  = el.label,
				text = tb and tb.Text or "",
			}
		end

		if obj then table.insert(data.objects, obj) end
	end
	if savetheme then
		local t = menu.theme
		local themekeys = {
			"bg", "bgdark", "bgcard", "sidebar", "sidebarborder", "border", "borderbright",
			"section", "sectionheader", "text", "textdim", "textdark", "accent", "accentdim",
			"accentglow", "toggleon", "toggleoff", "toggleborder", "tabactive", "tabbar",
			"columnbg", "columndivider", "scrollbar", "white",
		}
		local themeobj = { type = "Theme", idx = "__theme__", themename = t._selectedthemename or "" }
		for _, key in ipairs(themekeys) do
			if t[key] then themeobj[key] = colorToHex(t[key]) end
		end
		table.insert(data.objects, themeobj)
	end
	if menu._positionables then
		for _, entry in ipairs(menu._positionables) do
			local ok2, pos = pcall(entry.getpos)
			if ok2 and pos then
				table.insert(data.objects, {
					type = "Position",
					idx  = entry.key,
					x    = pos.x, y = pos.y,
					xs   = pos.xs or 0, ys = pos.ys or 0,
				})
			end
		end
	end
	local ok, encoded = pcall(httpService.JSONEncode, httpService, data)
	if not ok then return false, "failed to encode: " .. tostring(encoded) end
	local path = subfolder .. "/" .. name .. ".json"
	writefile(path, encoded)
	return true
end

function configmanager.load(menu, name, options)
	if not name or name:gsub(" ", "") == "" then
		return false, "no config name given"
	end
	local path = subfolder .. "/" .. name .. ".json"
	if not isfile(path) then return false, "config not found: " .. name end
	local ok, decoded = pcall(httpService.JSONDecode, httpService, readfile(path))
	if not ok then return false, "failed to decode: " .. tostring(decoded) end
	local elmap = {}
	for _, el in ipairs(allelements(menu)) do
		if el.label and el.label ~= "" then
			elmap[el.label] = el
		end
	end
	local savetheme = options == nil or options.savetheme ~= false
	for _, obj in ipairs(decoded.objects or {}) do
		if obj.type == "Theme" and obj.idx == "__theme__" and savetheme and _thememanager then
			local themekeys = {
				"bg", "bgdark", "bgcard", "sidebar", "sidebarborder", "border", "borderbright",
				"section", "sectionheader", "text", "textdim", "textdark", "accent", "accentdim",
				"accentglow", "toggleon", "toggleoff", "toggleborder", "tabactive", "tabbar",
				"columnbg", "columndivider", "scrollbar", "white",
			}
			local patch = {}
			for _, key in ipairs(themekeys) do
				if obj[key] then patch[key] = hexToColor(obj[key]) end
			end
			_thememanager.applytheme(menu, patch)
			if obj.themename and obj.themename ~= "" then
				menu.theme._selectedthemename = obj.themename
			end
			_thememanager.afterapply(menu)
			for _, tabdata in ipairs(menu.tabs) do
				for _, sec in ipairs(tabdata.sections) do
					for _, el in ipairs(sec.elements) do
						if el.type == "dropdown" and el.label == "Theme" and obj.themename and obj.themename ~= "" then
							el.selected = obj.themename
							if el.displaylbl then el.displaylbl.Text = obj.themename end
						end
					end
				end
			end
			break
		end
	end
	for _, obj in ipairs(decoded.objects or {}) do
		if obj.type == "Theme" then continue end
		task.spawn(function()
			local el = elmap[obj.idx]
			if not el then return end
			if obj.type == "Toggle" and el.type == "toggle" then
				local newstate = obj.value == true
				if el.setstate then
					el.setstate(newstate, true)
				else
					el.state = newstate
					if el.callback then el.callback(newstate) end
				end
				if obj.boundkey and el.keybindbtn then
					local ok3, kc = pcall(function() return Enum.KeyCode[obj.boundkey] end)
					if ok3 and kc then
						el.boundkey = kc
						el.keybindbtn.Text = obj.boundkey
					end
				end
			elseif obj.type == "Slider" and el.type == "slider" then
				local num = tonumber(obj.value)
				if num then
					local stepped = math.round((num - el.min) / el.step) * el.step + el.min
					el.value = math.clamp(stepped, el.min, el.max)
					el.valuelabel.Text = tostring(el.value)
					local scale = (el.value - el.min) / (el.max - el.min)
					el.fill.Size = UDim2.new(scale, 0, 1, 0)
					if el.callback then el.callback(el.value) end
				end
			elseif obj.type == "ColorPicker" and el.type == "colorpicker" then
				local c = hexToColor(obj.value)
				if el.setcolor then
					el.setcolor(c)
				else
					el.color = c
					if el.preview  then el.preview.BackgroundColor3 = c end
					if el.hexlabel then el.hexlabel.Text = "#" .. obj.value end
					if el.callback then el.callback(c, math.round(c.R*255), math.round(c.G*255), math.round(c.B*255)) end
				end
			elseif obj.type == "Dropdown" then
				local ismulti = obj.multi == true
				if not ismulti and el.type == "dropdown" then
					el.selected = obj.value
					if el.displaylbl then el.displaylbl.Text = tostring(obj.value or "") end
					if el.callback then el.callback(obj.value) end
				elseif ismulti and (el.type == "multiselect" or el.type == "searchbox") then
					local vals = type(obj.value) == "table" and obj.value or {}
					if el.removechip then
						local existing = {}
						for k in pairs(el.selected) do table.insert(existing, k) end
						for _, k in ipairs(existing) do el.removechip(k) end
					else
						for k in pairs(el.selected) do el.selected[k] = nil end
						if el.chipstrip then
							for _, chip in ipairs(el.chipstrip:GetChildren()) do
								if chip:IsA("Frame") then chip:Destroy() end
							end
						end
					end
					local newvals = {}
					for _, v in ipairs(vals) do
						el.selected[v] = true
						table.insert(newvals, v)
						if el.addchip then el.addchip(v) end
					end
					if el.callback then el.callback(newvals) end
				end
			elseif obj.type == "Input" and el.type == "textbox" then
				if el.textbox and type(obj.text) == "string" then
					el.textbox.Text = obj.text
					if el.callback then el.callback(obj.text, false) end
				end
			end
		end)
	end
	if menu._positionables then
		local posmap = {}
		for _, obj in ipairs(decoded.objects or {}) do
			if obj.type == "Position" and obj.idx then
				posmap[obj.idx] = obj
			end
		end
		for _, entry in ipairs(menu._positionables) do
			local p = posmap[entry.key]
			if p then pcall(entry.setpos, p) end
		end
	end

	return true
end

function configmanager.list()
	buildfolder()
	local files = listfiles(subfolder)
	local out = {}
	for _, f in ipairs(files) do
		if f:sub(-5) == ".json" then
			local bare = f:match("[/\\]([^/\\]+)\.json$") or f:sub(1, -6)
			table.insert(out, bare)
		end
	end
	return out
end

function configmanager.delete(name)
	local path = subfolder .. "/" .. name .. ".json"
	if isfile(path) then
		delfile(path)
		return true
	end
	return false, "file not found"
end

function configmanager.setautoload(name)
	buildfolder()
	writefile(subfolder .. "/autoload.txt", name)
end

function configmanager.getautoload()
	local path = subfolder .. "/autoload.txt"
	if isfile(path) then return readfile(path) end
	return nil
end

function configmanager.loadautoload(menu, options)
	local name = configmanager.getautoload()
	if name then
		local ok, err = configmanager.load(menu, name, options)
		return ok, err, name
	end
	return false, "no autoload set", nil
end

function configmanager.setignore(list)
	for _, k in ipairs(list) do ignoreset[k] = true end
end

function configmanager.setthememanager(tm)
	_thememanager = tm
end

function configmanager.inject(menu, tab, options)
	options = options or {}
	if options.folder       then configmanager.setfolder(options.folder) end
	if options.ignore       then configmanager.setignore(options.ignore) end
	if options.thememanager then configmanager.setthememanager(options.thememanager) end
	local savetheme = options.savetheme ~= false
	local notiflib  = options.notiflib
	pcall(buildfolder)
	local sec = menu:addsection(tab, "Config", "left")
	local namebox = menu:addtextbox(sec, "Config Name", { placeholder = "Enter name..." })
	local listdrop = menu:adddropdown(sec, "Config List", {
		choices = configmanager.list(),
		default = "",
	})
	menu:adddivider(sec, "")
	local function refreshlist()
		local newlist = configmanager.list()
		listdrop.choices  = newlist
		listdrop.selected = newlist[1] or ""
		if listdrop.displaylbl then
			listdrop.displaylbl.Text = listdrop.selected
		end
	end
	local function notify(opts)
		if notiflib then notiflib.notify(opts) end
	end
	menu:addbutton(sec, "Save Config", {
		callback = function()
			local name = namebox.textbox and namebox.textbox.Text or ""
			if name:gsub(" ", "") == "" then
				notify({ title = "Config", message = "Enter a config name first.", type = "error", duration = 3 })
				return
			end
			local ok, err = configmanager.save(menu, name, { savetheme = savetheme })
			if ok then
				notify({ title = "Config", message = "Saved \"" .. name .. "\"", type = "success", duration = 3 })
				refreshlist()
				listdrop.selected = name
				if listdrop.displaylbl then listdrop.displaylbl.Text = name end
			else
				notify({ title = "Config", message = "Save failed: " .. (err or "?"), type = "error", duration = 4 })
			end
		end,
	})
	menu:addbutton(sec, "Load Config", {
		callback = function()
			local name = listdrop.selected
			if not name or name == "" then
				notify({ title = "Config", message = "Select a config from the list first.", type = "error", duration = 3 })
				return
			end
			local ok, err = configmanager.load(menu, name, { savetheme = savetheme })
			if ok then
				notify({ title = "Config", message = "Loaded \"" .. name .. "\"", type = "success", duration = 3 })
			else
				notify({ title = "Config", message = "Load failed: " .. (err or "?"), type = "error", duration = 4 })
			end
		end,
	})
	menu:addbutton(sec, "Overwrite Config", {
		callback = function()
			local name = listdrop.selected
			if not name or name == "" then
				notify({ title = "Config", message = "Select a config to overwrite.", type = "error", duration = 3 })
				return
			end
			local ok, err = configmanager.save(menu, name, { savetheme = savetheme })
			if ok then
				notify({ title = "Config", message = "Overwrote \"" .. name .. "\"", type = "success", duration = 3 })
			else
				notify({ title = "Config", message = "Overwrite failed: " .. (err or "?"), type = "error", duration = 4 })
			end
		end,
	})
	menu:addbutton(sec, "Delete Config", {
		callback = function()
			local name = listdrop.selected
			if not name or name == "" then
				notify({ title = "Config", message = "Select a config to delete.", type = "error", duration = 3 })
				return
			end
			local ok = configmanager.delete(name)
			if ok then
				notify({ title = "Config", message = "Deleted \"" .. name .. "\"", type = "warning", duration = 3 })
				refreshlist()
			else
				notify({ title = "Config", message = "Delete failed.", type = "error", duration = 3 })
			end
		end,
	})
	menu:addbutton(sec, "Refresh List", {
		callback = function()
			refreshlist()
			notify({ title = "Config", message = "List refreshed.", type = "info", duration = 2 })
		end,
	})
	menu:adddivider(sec, "Autoload")
	menu:addbutton(sec, "Set as Autoload", {
		callback = function()
			local name = listdrop.selected
			if not name or name == "" then
				notify({ title = "Config", message = "Select a config first.", type = "error", duration = 3 })
				return
			end
			configmanager.setautoload(name)
			notify({ title = "Config", message = "\"" .. name .. "\" will autoload on next run.", type = "info", duration = 4 })
		end,
	})
	menu:addbutton(sec, "Load Autoload", {
		callback = function()
			local ok, err, name = configmanager.loadautoload(menu, { savetheme = savetheme })
			if ok then
				notify({ title = "Config", message = "Loaded autoload \"" .. name .. "\"", type = "success", duration = 3 })
			else
				notify({ title = "Config", message = "No autoload config set.", type = "info", duration = 3 })
			end
		end,
	})
	task.spawn(function()
		if not game:IsLoaded() then
			game.Loaded:Wait()
		end
		task.wait(1)
		configmanager.loadautoload(menu, { savetheme = savetheme })
	end)
end

buildfolder()
return configmanager
