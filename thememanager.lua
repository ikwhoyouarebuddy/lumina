local thememanager = {}
thememanager.__index = thememanager

local themes = {

	default = {
		name          = "Default",
		bg            = Color3.fromRGB(6,   8,   13),
		bgdark        = Color3.fromRGB(3,   4,   8),
		bgcard        = Color3.fromRGB(10,  13,  20),
		sidebar       = Color3.fromRGB(8,   10,  16),
		sidebarborder = Color3.fromRGB(20,  26,  40),
		border        = Color3.fromRGB(22,  30,  46),
		borderbright  = Color3.fromRGB(38,  52,  80),
		section       = Color3.fromRGB(10,  13,  20),
		sectionheader = Color3.fromRGB(13,  17,  26),
		text          = Color3.fromRGB(205, 215, 235),
		textdim       = Color3.fromRGB(72,  88,  118),
		textdark      = Color3.fromRGB(30,  40,  60),
		accent        = Color3.fromRGB(0,   200, 190),
		accentdim     = Color3.fromRGB(0,   120, 114),
		accentglow    = Color3.fromRGB(0,   200, 190),
		toggleon      = Color3.fromRGB(0,   200, 190),
		toggleoff     = Color3.fromRGB(12,  16,  24),
		toggleborder  = Color3.fromRGB(28,  36,  54),
		tabactive     = Color3.fromRGB(12,  17,  28),
		tabbar        = Color3.fromRGB(8,   10,  16),
		columnbg      = Color3.fromRGB(6,   8,   13),
		columndivider = Color3.fromRGB(16,  22,  34),
		scrollbar     = Color3.fromRGB(24,  32,  50),
		white         = Color3.fromRGB(255, 255, 255),
	},

	midnight = {
		name          = "Midnight",
		bg            = Color3.fromRGB(5,   7,   18),
		bgdark        = Color3.fromRGB(2,   3,   10),
		bgcard        = Color3.fromRGB(8,   11,  24),
		sidebar       = Color3.fromRGB(6,   8,   20),
		sidebarborder = Color3.fromRGB(18,  26,  56),
		border        = Color3.fromRGB(20,  28,  62),
		borderbright  = Color3.fromRGB(36,  50,  105),
		section       = Color3.fromRGB(8,   11,  24),
		sectionheader = Color3.fromRGB(11,  15,  32),
		text          = Color3.fromRGB(188, 200, 235),
		textdim       = Color3.fromRGB(64,  80,  132),
		textdark      = Color3.fromRGB(26,  36,  74),
		accent        = Color3.fromRGB(80,  140, 255),
		accentdim     = Color3.fromRGB(46,  88,  178),
		accentglow    = Color3.fromRGB(100, 160, 255),
		toggleon      = Color3.fromRGB(80,  140, 255),
		toggleoff     = Color3.fromRGB(8,   12,  30),
		toggleborder  = Color3.fromRGB(24,  36,  84),
		tabactive     = Color3.fromRGB(10,  15,  36),
		tabbar        = Color3.fromRGB(6,   8,   20),
		columnbg      = Color3.fromRGB(5,   7,   18),
		columndivider = Color3.fromRGB(14,  20,  48),
		scrollbar     = Color3.fromRGB(20,  28,  62),
		white         = Color3.fromRGB(255, 255, 255),
	},

	emerald = {
		name          = "Emerald",
		bg            = Color3.fromRGB(5,   14,  12),
		bgdark        = Color3.fromRGB(2,   8,   6),
		bgcard        = Color3.fromRGB(8,   18,  16),
		sidebar       = Color3.fromRGB(6,   16,  14),
		sidebarborder = Color3.fromRGB(16,  40,  34),
		border        = Color3.fromRGB(18,  44,  38),
		borderbright  = Color3.fromRGB(30,  72,  62),
		section       = Color3.fromRGB(8,   18,  16),
		sectionheader = Color3.fromRGB(11,  22,  20),
		text          = Color3.fromRGB(182, 224, 212),
		textdim       = Color3.fromRGB(58,  114, 100),
		textdark      = Color3.fromRGB(22,  54,  46),
		accent        = Color3.fromRGB(30,  220, 145),
		accentdim     = Color3.fromRGB(16,  142, 92),
		accentglow    = Color3.fromRGB(50,  240, 165),
		toggleon      = Color3.fromRGB(30,  220, 145),
		toggleoff     = Color3.fromRGB(8,   18,  15),
		toggleborder  = Color3.fromRGB(20,  50,  42),
		tabactive     = Color3.fromRGB(10,  24,  20),
		tabbar        = Color3.fromRGB(6,   16,  14),
		columnbg      = Color3.fromRGB(5,   14,  12),
		columndivider = Color3.fromRGB(12,  30,  25),
		scrollbar     = Color3.fromRGB(18,  44,  38),
		white         = Color3.fromRGB(255, 255, 255),
	},

	rose = {
		name          = "Rose",
		bg            = Color3.fromRGB(16,  6,   11),
		bgdark        = Color3.fromRGB(8,   2,   5),
		bgcard        = Color3.fromRGB(20,  8,   14),
		sidebar       = Color3.fromRGB(18,  7,   12),
		sidebarborder = Color3.fromRGB(50,  18,  32),
		border        = Color3.fromRGB(50,  18,  32),
		borderbright  = Color3.fromRGB(82,  30,  52),
		section       = Color3.fromRGB(20,  8,   14),
		sectionheader = Color3.fromRGB(25,  10,  18),
		text          = Color3.fromRGB(235, 192, 208),
		textdim       = Color3.fromRGB(122, 58,  86),
		textdark      = Color3.fromRGB(56,  22,  38),
		accent        = Color3.fromRGB(255, 65,  105),
		accentdim     = Color3.fromRGB(172, 36,  70),
		accentglow    = Color3.fromRGB(255, 90,  130),
		toggleon      = Color3.fromRGB(255, 65,  105),
		toggleoff     = Color3.fromRGB(24,  9,   16),
		toggleborder  = Color3.fromRGB(66,  24,  40),
		tabactive     = Color3.fromRGB(26,  10,  18),
		tabbar        = Color3.fromRGB(18,  7,   12),
		columnbg      = Color3.fromRGB(16,  6,   11),
		columndivider = Color3.fromRGB(34,  13,  22),
		scrollbar     = Color3.fromRGB(50,  18,  32),
		white         = Color3.fromRGB(255, 255, 255),
	},

	violet = {
		name          = "Violet",
		bg            = Color3.fromRGB(10,  6,   18),
		bgdark        = Color3.fromRGB(5,   2,   10),
		bgcard        = Color3.fromRGB(14,  8,   24),
		sidebar       = Color3.fromRGB(11,  7,   20),
		sidebarborder = Color3.fromRGB(34,  20,  60),
		border        = Color3.fromRGB(36,  20,  62),
		borderbright  = Color3.fromRGB(58,  36,  102),
		section       = Color3.fromRGB(14,  8,   24),
		sectionheader = Color3.fromRGB(18,  10,  30),
		text          = Color3.fromRGB(215, 198, 248),
		textdim       = Color3.fromRGB(96,  68,  148),
		textdark      = Color3.fromRGB(42,  28,  72),
		accent        = Color3.fromRGB(175, 80,  255),
		accentdim     = Color3.fromRGB(110, 46,  172),
		accentglow    = Color3.fromRGB(200, 110, 255),
		toggleon      = Color3.fromRGB(175, 80,  255),
		toggleoff     = Color3.fromRGB(16,  9,   30),
		toggleborder  = Color3.fromRGB(48,  28,  90),
		tabactive     = Color3.fromRGB(18,  11,  34),
		tabbar        = Color3.fromRGB(11,  7,   20),
		columnbg      = Color3.fromRGB(10,  6,   18),
		columndivider = Color3.fromRGB(24,  15,  44),
		scrollbar     = Color3.fromRGB(36,  20,  62),
		white         = Color3.fromRGB(255, 255, 255),
	},

	light = {
		name          = "Light",
		bg            = Color3.fromRGB(242, 244, 250),
		bgdark        = Color3.fromRGB(225, 228, 240),
		bgcard        = Color3.fromRGB(252, 253, 255),
		sidebar       = Color3.fromRGB(234, 236, 246),
		sidebarborder = Color3.fromRGB(198, 204, 224),
		border        = Color3.fromRGB(196, 204, 222),
		borderbright  = Color3.fromRGB(158, 170, 208),
		section       = Color3.fromRGB(252, 253, 255),
		sectionheader = Color3.fromRGB(236, 238, 250),
		text          = Color3.fromRGB(20,  26,  46),
		textdim       = Color3.fromRGB(95,  106, 142),
		textdark      = Color3.fromRGB(158, 168, 198),
		accent        = Color3.fromRGB(0,   140, 210),
		accentdim     = Color3.fromRGB(0,   96,  155),
		accentglow    = Color3.fromRGB(28,  162, 228),
		toggleon      = Color3.fromRGB(0,   140, 210),
		toggleoff     = Color3.fromRGB(208, 213, 230),
		toggleborder  = Color3.fromRGB(172, 180, 210),
		tabactive     = Color3.fromRGB(220, 225, 242),
		tabbar        = Color3.fromRGB(234, 236, 246),
		columnbg      = Color3.fromRGB(242, 244, 250),
		columndivider = Color3.fromRGB(207, 212, 230),
		scrollbar     = Color3.fromRGB(186, 194, 220),
		white         = Color3.fromRGB(255, 255, 255),
	},

	paint = {
		name          = "Paint",
		bg            = Color3.fromRGB(10,  10,  10),
		bgdark        = Color3.fromRGB(4,   4,   4),
		bgcard        = Color3.fromRGB(14,  14,  14),
		sidebar       = Color3.fromRGB(11,  11,  11),
		sidebarborder = Color3.fromRGB(30,  30,  30),
		border        = Color3.fromRGB(32,  32,  32),
		borderbright  = Color3.fromRGB(58,  58,  58),
		section       = Color3.fromRGB(14,  14,  14),
		sectionheader = Color3.fromRGB(20,  20,  20),
		text          = Color3.fromRGB(224, 224, 224),
		textdim       = Color3.fromRGB(104, 104, 104),
		textdark      = Color3.fromRGB(48,  48,  48),
		accent        = Color3.fromRGB(255, 186, 8),
		accentdim     = Color3.fromRGB(186, 136, 0),
		accentglow    = Color3.fromRGB(255, 210, 60),
		toggleon      = Color3.fromRGB(255, 186, 8),
		toggleoff     = Color3.fromRGB(20,  20,  20),
		toggleborder  = Color3.fromRGB(48,  48,  48),
		tabactive     = Color3.fromRGB(22,  22,  22),
		tabbar        = Color3.fromRGB(11,  11,  11),
		columnbg      = Color3.fromRGB(10,  10,  10),
		columndivider = Color3.fromRGB(24,  24,  24),
		scrollbar     = Color3.fromRGB(32,  32,  32),
		white         = Color3.fromRGB(255, 255, 255),
	},

	monokathon = {
		name          = "Monokathon",
		bg            = Color3.fromRGB(26,  24,  30),
		bgdark        = Color3.fromRGB(15,  13,  18),
		bgcard        = Color3.fromRGB(32,  29,  38),
		sidebar       = Color3.fromRGB(28,  26,  33),
		sidebarborder = Color3.fromRGB(48,  44,  58),
		border        = Color3.fromRGB(48,  44,  58),
		borderbright  = Color3.fromRGB(76,  70,  92),
		section       = Color3.fromRGB(32,  29,  38),
		sectionheader = Color3.fromRGB(38,  35,  46),
		text          = Color3.fromRGB(230, 220, 180),
		textdim       = Color3.fromRGB(118, 108, 80),
		textdark      = Color3.fromRGB(56,  50,  38),
		accent        = Color3.fromRGB(255, 205, 75),
		accentdim     = Color3.fromRGB(185, 146, 40),
		accentglow    = Color3.fromRGB(255, 225, 115),
		toggleon      = Color3.fromRGB(255, 205, 75),
		toggleoff     = Color3.fromRGB(38,  35,  46),
		toggleborder  = Color3.fromRGB(65,  58,  78),
		tabactive     = Color3.fromRGB(40,  37,  50),
		tabbar        = Color3.fromRGB(28,  26,  33),
		columnbg      = Color3.fromRGB(26,  24,  30),
		columndivider = Color3.fromRGB(42,  38,  52),
		scrollbar     = Color3.fromRGB(48,  44,  58),
		white         = Color3.fromRGB(255, 255, 255),
	},
}

local function applytheme(menu, th)
	for k, v in pairs(th) do
		if k ~= "name" then menu.theme[k] = v end
	end
	th = menu.theme

	menu.root.BackgroundColor3 = th.bg

	if menu.titlebar then
		menu.titlebar.BackgroundColor3 = th.bgdark
		for _, child in ipairs(menu.titlebar:GetChildren()) do
			if child:IsA("Frame") then
				child.BackgroundColor3 = th.bgdark
			end
		end
		for _, child in ipairs(menu.titlebar:GetDescendants()) do
			if child:IsA("Frame") and child.Size == UDim2.new(0, 2, 0, 14) then
				child.BackgroundColor3 = th.accent
			elseif child:IsA("TextLabel") then
				if child.Font == Enum.Font.GothamBold then
					child.TextColor3 = th.text
				else
					child.TextColor3 = th.textdark
				end
			end
		end
	end

	if menu.titlesep then menu.titlesep.BackgroundColor3 = th.border end

	if menu.sidebar then
		menu.sidebar.BackgroundColor3 = th.sidebar
		if menu.sidebar.Parent then
			for _, child in ipairs(menu.sidebar.Parent:GetChildren()) do
				if child:IsA("Frame") and child.Size == UDim2.new(0, 1, 1, 0) then
					child.BackgroundColor3 = th.sidebarborder
				end
			end
		end
	end

	for _, tabdata in ipairs(menu.tabs) do
		local isactive = (menu.activetab == tabdata)
		if tabdata.btn then
			tabdata.btn.BackgroundColor3 = th.tabactive
			tabdata.btn.BackgroundTransparency = isactive and 0.82 or 1
		end
		if tabdata.btnlbl then
			tabdata.btnlbl.TextColor3 = isactive and th.text or th.textdim
		end
		if tabdata.accentbar then
			tabdata.accentbar.BackgroundColor3       = th.accent
			tabdata.accentbar.BackgroundTransparency = isactive and 0 or 1
		end

		if tabdata.container then
			for _, child in ipairs(tabdata.container:GetChildren()) do
				if child:IsA("Frame") and child.Size == UDim2.new(0, 1, 1, 0) then
					child.BackgroundColor3 = th.columndivider
				end
			end
		end

		for _, sec in ipairs(tabdata.sections) do
			if sec.frame then
				sec.frame.BackgroundColor3 = th.section
				local fs = sec.frame:FindFirstChildWhichIsA("UIStroke")
				if fs then fs.Color = th.border end
			end

			if sec.frame and sec.body then
				for _, child in ipairs(sec.frame:GetChildren()) do
					if child:IsA("Frame") and child ~= sec.body then
						child.BackgroundColor3 = th.sectionheader
						for _, sub in ipairs(child:GetChildren()) do
							if sub:IsA("Frame") and sub.Size == UDim2.new(0, 2, 0, 10) then
								sub.BackgroundColor3 = th.accent
							elseif sub:IsA("TextLabel") then
								sub.TextColor3 = th.textdim
							end
						end
					end
				end
			end

			for _, el in ipairs(sec.elements) do

				if el.type == "toggle" then
					if el.lbl then
						el.lbl.TextColor3 = el.state and th.text or th.textdim
					end
					if el.box then
						el.box.BackgroundColor3 = el.state and th.toggleon or th.toggleoff
						local ps = el.box:FindFirstChildWhichIsA("UIStroke")
						if ps then ps.Color = el.state and th.accent or th.toggleborder end
						local knob = el.box:FindFirstChildOfClass("Frame")
						if knob then knob.BackgroundColor3 = el.state and th.white or th.textdark end
					end
					if el.keybindbtn then
						el.keybindbtn.BackgroundColor3 = th.toggleoff
						el.keybindbtn.TextColor3       = th.textdim
						local ks = el.keybindbtn:FindFirstChildWhichIsA("UIStroke")
						if ks then ks.Color = th.toggleborder end
					end

				elseif el.type == "slider" then
					if el.valuelabel then el.valuelabel.TextColor3 = th.accent end
					if el.track then
						el.track.BackgroundColor3 = th.toggleoff
						local ts = el.track:FindFirstChildWhichIsA("UIStroke")
						if ts then ts.Color = th.toggleborder end
					end
					if el.fill then el.fill.BackgroundColor3 = th.accent end
					for _, child in ipairs(el.row:GetChildren()) do
						if child:IsA("TextLabel") and child.TextXAlignment ~= Enum.TextXAlignment.Right then
							child.TextColor3 = th.textdim
						end
					end

				elseif el.type == "colorpicker" then
					for _, child in ipairs(el.row:GetChildren()) do
						if child:IsA("TextLabel") then
							if child.TextXAlignment == Enum.TextXAlignment.Left then
								child.TextColor3 = th.textdim
							else
								child.TextColor3 = th.textdim
							end
						end
					end
					if el.preview then
						local ps = el.preview:FindFirstChildWhichIsA("UIStroke")
						if ps then ps.Color = th.toggleborder end
					end
					if el.popup then
						el.popup.BackgroundColor3 = th.bgdark
						local ps = el.popup:FindFirstChildWhichIsA("UIStroke")
						if ps then ps.Color = th.border end
						for _, child in ipairs(el.popup:GetChildren()) do
							if child:IsA("Frame") then
								local tb = child:FindFirstChildWhichIsA("TextBox")
								if tb then
									child.BackgroundColor3 = th.toggleoff
									local cs = child:FindFirstChildWhichIsA("UIStroke")
									if cs then cs.Color = th.toggleborder end
									tb.TextColor3        = th.text
									tb.PlaceholderColor3 = th.textdim
								end
							end
						end
					end

				elseif el.type == "dropdown" then
					if el.displaybg then
						el.displaybg.BackgroundColor3 = th.toggleoff
						local ds = el.displaybg:FindFirstChildWhichIsA("UIStroke")
						if ds then ds.Color = th.toggleborder end
						for _, child in ipairs(el.displaybg:GetChildren()) do
							if child:IsA("TextLabel") then child.TextColor3 = th.textdim end
						end
					end
					if el.displaylbl then el.displaylbl.TextColor3 = th.text end
					for _, child in ipairs(el.row:GetChildren()) do
						if child:IsA("TextLabel") then child.TextColor3 = th.textdim end
					end
					if el.popup then
						el.popup.BackgroundColor3     = th.bgdark
						el.popup.ScrollBarImageColor3 = th.scrollbar
						local ps = el.popup:FindFirstChildWhichIsA("UIStroke")
						if ps then ps.Color = th.border end
					end
					if el.itemhighlights then
						for choice, hl in pairs(el.itemhighlights) do
							local ison = el.selected == choice
							hl.BackgroundColor3       = th.accent
							hl.BackgroundTransparency = ison and 0.82 or 1
						end
					end

				elseif el.type == "multiselect" or el.type == "searchbox" then
					for _, child in ipairs(el.row:GetChildren()) do
						if child:IsA("TextLabel") then child.TextColor3 = th.textdim end
					end
					if el.input then
						el.input.TextColor3        = th.text
						el.input.PlaceholderColor3 = th.textdim
						local ibg = el.input.Parent
						if ibg and ibg:IsA("Frame") then
							ibg.BackgroundColor3 = th.toggleoff
							local st = ibg:FindFirstChildWhichIsA("UIStroke")
							if st then st.Color = th.toggleborder end
						end
					end
					if el.chipstrip then
						for _, chip in ipairs(el.chipstrip:GetChildren()) do
							if chip:IsA("Frame") then
								chip.BackgroundColor3 = th.accent
								for _, sub in ipairs(chip:GetChildren()) do
									if sub:IsA("TextLabel") then sub.TextColor3 = th.text end
									if sub:IsA("TextButton") then sub.TextColor3 = th.textdim end
								end
							end
						end
					end
					if el.popup then
						el.popup.BackgroundColor3     = th.bgdark
						el.popup.ScrollBarImageColor3 = th.scrollbar
						local ps = el.popup:FindFirstChildWhichIsA("UIStroke")
						if ps then ps.Color = th.border end
					end

				elseif el.type == "divider" then
					for _, child in ipairs(el.row:GetChildren()) do
						if child:IsA("Frame") then child.BackgroundColor3 = th.border end
						if child:IsA("TextLabel") then
							child.BackgroundColor3 = th.section
							child.TextColor3       = th.textdark
						end
					end

				elseif el.type == "textbox" then
					for _, child in ipairs(el.row:GetChildren()) do
						if child:IsA("TextLabel") then
							child.TextColor3 = th.textdim
						elseif child:IsA("Frame") then
							child.BackgroundColor3 = th.toggleoff
							local st = child:FindFirstChildWhichIsA("UIStroke")
							if st then st.Color = th.toggleborder end
							for _, sub in ipairs(child:GetChildren()) do
								if sub:IsA("TextBox") then
									sub.TextColor3        = th.text
									sub.PlaceholderColor3 = th.textdim
								end
							end
						end
					end

				elseif el.type == "button" then
					if el.btnbg then
						el.btnbg.BackgroundColor3 = th.toggleoff
						local st = el.btnbg:FindFirstChildWhichIsA("UIStroke")
						if st then st.Color = th.toggleborder end
						local lbl = el.btnbg:FindFirstChildWhichIsA("TextLabel")
						if lbl then lbl.TextColor3 = th.textdim end
					end

				elseif el.type == "label" then
					if el.lbl then el.lbl.TextColor3 = th.textdim end
				end
			end
		end
	end
end

local function derivedimcolors(menu)
	local t        = menu.theme.text
	local h, s, v  = Color3.toHSV(t)
	menu.theme.textdim  = Color3.fromHSV(h, s, v * 0.50)
	menu.theme.textdark = Color3.fromHSV(h, s, v * 0.24)
end

local function syncel(el, color)
	if not el then return end
	if el.setcolor then
		el.setcolor(color)
		return
	end
	local hex = string.format("#%02X%02X%02X",
		math.round(color.R * 255),
		math.round(color.G * 255),
		math.round(color.B * 255))
	el.color = color
	if el.preview  then el.preview.BackgroundColor3 = color end
	if el.hexlabel then el.hexlabel.Text = hex end
	if el.popup then
		for _, child in ipairs(el.popup:GetChildren()) do
			if child:IsA("Frame") then
				local tb = child:FindFirstChildWhichIsA("TextBox")
				if tb then tb.Text = hex end
			end
		end
	end
end

function thememanager.inject(menu, tab, ontheme)
	local themeorder = {}
	for key, t in pairs(themes) do table.insert(themeorder, { key = key, name = t.name }) end
	table.sort(themeorder, function(a, b) return a.name < b.name end)

	local themenames = {}
	for _, entry in ipairs(themeorder) do table.insert(themenames, entry.name) end

	local themsec = menu:addsection(tab, "Theme",  "left")
	local colsec  = menu:addsection(tab, "Colors", "middle")

	local cpickers = {}
	local syncingpickers = false
	local pickerfiring   = false

	local function afterapply()
		derivedimcolors(menu)
		syncingpickers = true
		for _, cp in ipairs(cpickers) do syncel(cp.el, menu.theme[cp.key]) end
		syncingpickers = false
		if menu._themelisteners then
			for _, fn in ipairs(menu._themelisteners) do
				pcall(fn, menu.theme)
			end
		end
		if ontheme then ontheme(menu.theme) end
	end

	menu._themeafterApply = afterapply

	menu:adddropdown(themsec, "Theme", {
		choices  = themenames,
		default  = "Default",
		callback = function(chosen)
			for _, entry in ipairs(themeorder) do
				if entry.name == chosen then
					applytheme(menu, themes[entry.key])
					menu.theme._selectedthemename = chosen
					afterapply()
					break
				end
			end
		end,
	})

	local function makepicker(label, key, related)
		local el = menu:addcolorpicker(colsec, label, menu.theme[key], function(c)
			if syncingpickers then return end
			if pickerfiring   then return end
			pickerfiring = true
			menu.theme[key] = c
			if related then
				for _, rkey in ipairs(related) do menu.theme[rkey] = c end
			end
			applytheme(menu, menu.theme)
			afterapply()
			pickerfiring = false
		end)
		table.insert(cpickers, { el = el, key = key })
	end

	makepicker("Background",    "bg",        { "bgdark", "bgcard", "sidebar", "tabbar", "columnbg" })
	makepicker("Section",       "section",   { "sectionheader", "border", "borderbright", "sidebarborder", "columndivider" })
	makepicker("Accent",        "accent",    { "accentglow", "accentdim", "toggleon", "toggleborder" })
	makepicker("Interactables", "toggleoff", { "toggleborder" })
	makepicker("Text",          "text",      nil)
end

function thememanager.addtheme(key, t)
	themes[key] = t
end

function thememanager.apply(menu, key)
	if themes[key] then
		applytheme(menu, themes[key])
	end
end

function thememanager.applytheme(menu, t)
	applytheme(menu, t)
end

function thememanager.afterapply(menu)
	if menu._themeafterApply then
		menu._themeafterApply()
	end
end

return thememanager