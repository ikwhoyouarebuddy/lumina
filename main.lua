local menulib = {}
menulib.__index = menulib

local services = {
	players   = game:GetService("Players"),
	userinput = game:GetService("UserInputService"),
	tween     = game:GetService("TweenService"),
}

local localplayer = services.players.LocalPlayer
local playergui   = localplayer:WaitForChild("PlayerGui")

local defaulttheme = {
	bg             = Color3.fromRGB(6,   8,   13),
	bgdark         = Color3.fromRGB(3,   4,   8),
	bgcard         = Color3.fromRGB(10,  13,  20),
	sidebar        = Color3.fromRGB(8,   10,  16),
	sidebarborder  = Color3.fromRGB(20,  26,  40),
	border         = Color3.fromRGB(22,  30,  46),
	borderbright   = Color3.fromRGB(38,  52,  80),
	section        = Color3.fromRGB(10,  13,  20),
	sectionheader  = Color3.fromRGB(13,  17,  26),
	text           = Color3.fromRGB(205, 215, 235),
	textdim        = Color3.fromRGB(72,  88,  118),
	textdark       = Color3.fromRGB(30,  40,  60),
	accent         = Color3.fromRGB(0,   200, 190),
	accentdim      = Color3.fromRGB(0,   120, 114),
	accentglow     = Color3.fromRGB(0,   200, 190),
	toggleon       = Color3.fromRGB(0,   200, 190),
	toggleoff      = Color3.fromRGB(12,  16,  24),
	toggleborder   = Color3.fromRGB(28,  36,  54),
	columnbg       = Color3.fromRGB(6,   8,   13),
	columndivider  = Color3.fromRGB(16,  22,  34),
	scrollbar      = Color3.fromRGB(24,  32,  50),
	white          = Color3.fromRGB(255, 255, 255),
	tabactive      = Color3.fromRGB(12,  17,  28),
	tabbar         = Color3.fromRGB(8,   10,  16),
}

local fonts = {
	regular = Enum.Font.Gotham,
	bold    = Enum.Font.GothamBold,
	semi    = Enum.Font.GothamSemibold,
}

local ti = {
	fast   = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	medium = TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
}

local function makeinst(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props) do inst[k] = v end
	return inst
end

local function tw(inst, props, speed)
	services.tween:Create(inst, speed or ti.fast, props):Play()
end

function menulib.new(title, subtext)
	local self = setmetatable({}, menulib)

	self.theme = {}
	for k, v in pairs(defaulttheme) do self.theme[k] = v end
	local theme = self.theme

	self.tabs       = {}
	self.activetab  = nil
	self.openpopups = {}
	self._positionables  = {}
	self._themelisteners = {}

	self.gui = makeinst("ScreenGui", {
		Parent         = playergui,
		Name           = "luminamenu",
		ResetOnSpawn   = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
	})

	self.root = makeinst("Frame", {
		Parent           = self.gui,
		Size             = UDim2.new(0, 640, 0, 460),
		Position         = UDim2.new(0.5, -320, 0.5, -230),
		BackgroundColor3 = theme.bg,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
	})
	self.titlebar = makeinst("Frame", {
		Parent           = self.root,
		Size             = UDim2.new(1, 0, 0, 36),
		BackgroundColor3 = theme.bgdark,
		BorderSizePixel  = 0,
		ZIndex           = 3,
	})

	self.titlesep = makeinst("Frame", {
		Parent           = self.root,
		Size             = UDim2.new(1, 0, 0, 1),
		Position         = UDim2.new(0, 0, 0, 36),
		BackgroundColor3 = theme.border,
		BorderSizePixel  = 0,
		ZIndex           = 4,
	})

	local titlerow = makeinst("Frame", {
		Parent               = self.titlebar,
		Size                 = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex               = 5,
	})
	makeinst("UIListLayout", {
		Parent            = titlerow,
		FillDirection     = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding           = UDim.new(0, 8),
	})
	makeinst("UIPadding", { Parent = titlerow, PaddingLeft = UDim.new(0, 14) })

	local marker = makeinst("Frame", {
		Parent           = titlerow,
		Size             = UDim2.new(0, 2, 0, 14),
		BackgroundColor3 = theme.accent,
		BorderSizePixel  = 0,
		ZIndex           = 5,
	})
	makeinst("UICorner", { Parent = marker, CornerRadius = UDim.new(1, 0) })

	makeinst("TextLabel", {
		Parent               = titlerow,
		Size                 = UDim2.new(0, 0, 1, 0),
		AutomaticSize        = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Text                 = title,
		TextColor3           = theme.text,
		Font                 = fonts.bold,
		TextSize             = 12,
		ZIndex               = 5,
	})
	if subtext and subtext ~= "" then
		makeinst("TextLabel", {
			Parent               = titlerow,
			Size                 = UDim2.new(0, 0, 1, 0),
			AutomaticSize        = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Text                 = subtext,
			TextColor3           = theme.textdark,
			Font                 = fonts.regular,
			TextSize             = 10,
			ZIndex               = 5,
		})
	end

	local body = makeinst("Frame", {
		Parent               = self.root,
		Size                 = UDim2.new(1, 0, 1, -37),
		Position             = UDim2.new(0, 0, 0, 37),
		BackgroundTransparency = 1,
		ClipsDescendants     = true,
	})

	self.sidebar = makeinst("Frame", {
		Parent           = body,
		Size             = UDim2.new(0, 110, 1, 0),
		BackgroundColor3 = theme.sidebar,
		BorderSizePixel  = 0,
	})
	makeinst("Frame", {
		Parent           = body,
		Size             = UDim2.new(0, 1, 1, 0),
		Position         = UDim2.new(0, 110, 0, 0),
		BackgroundColor3 = theme.sidebarborder,
		BorderSizePixel  = 0,
		ZIndex           = 2,
	})

	self.tablist = makeinst("Frame", {
		Parent               = self.sidebar,
		Size                 = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
	})
	makeinst("UIListLayout", {
		Parent            = self.tablist,
		FillDirection     = Enum.FillDirection.Vertical,
		SortOrder         = Enum.SortOrder.LayoutOrder,
		Padding           = UDim.new(0, 2),
	})
	makeinst("UIPadding", {
		Parent       = self.tablist,
		PaddingTop   = UDim.new(0, 10),
		PaddingLeft  = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
	})

	self.content = makeinst("Frame", {
		Parent               = body,
		Size                 = UDim2.new(1, -111, 1, 0),
		Position             = UDim2.new(0, 111, 0, 0),
		BackgroundTransparency = 1,
		ClipsDescendants     = true,
	})

	self:makedraggable()
	self:makekeytoggle()

	return self
end

function menulib:makekeytoggle()
	local visible   = true
	local animating = false

	local function show()
		if animating then return end
		animating = true
		self.root.ClipsDescendants = true
		self.root.Size             = UDim2.new(0, 640, 0, 0)
		self.root.Visible          = true
		tw(self.root, { Size = UDim2.new(0, 640, 0, 460) }, ti.medium)
		task.delay(0.20, function()
			self.root.ClipsDescendants = false
			animating = false
		end)
	end

	local function hide()
		if animating then return end
		animating = true
		for _, fn in ipairs(self.openpopups) do pcall(fn) end
		self.openpopups = {}
		self.root.ClipsDescendants = true
		local t = services.tween:Create(
			self.root,
			TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ Size = UDim2.new(0, 640, 0, 0) }
		)
		t:Play()
		t.Completed:Connect(function()
			self.root.Visible          = false
			self.root.Size             = UDim2.new(0, 640, 0, 460)
			self.root.ClipsDescendants = false
			animating = false
		end)
	end

	services.userinput.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.KeyCode == Enum.KeyCode.RightAlt then
			visible = not visible
			if visible then show() else hide() end
		end
	end)
end

function menulib:makedraggable()
	local dragging, dragstart, startpos = false, Vector2.new(), Vector2.new()

	self.titlebar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging  = true
			dragstart = input.Position
			startpos  = self.root.Position
		end
	end)
	services.userinput.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragstart
			local newpos = UDim2.new(
				startpos.X.Scale, startpos.X.Offset + delta.X,
				startpos.Y.Scale, startpos.Y.Offset + delta.Y
			)
			self.root.Position = newpos
			for _, tabdata in ipairs(self.tabs) do
				for _, sec in ipairs(tabdata.sections) do
					for _, el in ipairs(sec.elements) do
						if el.positionfn and el.popup and el.popup.Visible then
							el.positionfn()
						end
					end
				end
			end
		end
	end)
	services.userinput.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

function menulib:addtab(name)
	local theme   = self.theme
	local tabdata = {
		name      = name,
		sections  = {},
		btn       = nil,
		container = nil,
		columns   = { left = nil, middle = nil, right = nil },
	}

	local btn = makeinst("TextButton", {
		Parent               = self.tablist,
		Size                 = UDim2.new(1, 0, 0, 30),
		BackgroundColor3     = theme.tabactive,
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		Text                 = "",
		AutoButtonColor      = false,
		LayoutOrder          = #self.tabs + 1,
	})
	makeinst("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 6) })

	local accentbar = makeinst("Frame", {
		Parent               = btn,
		Size                 = UDim2.new(0, 2, 0, 14),
		Position             = UDim2.new(0, -0, 0.5, -7),
		BackgroundColor3     = theme.accent,
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		ZIndex               = 3,
	})
	makeinst("UICorner", { Parent = accentbar, CornerRadius = UDim.new(1, 0) })

	local btnlbl = makeinst("TextLabel", {
		Parent               = btn,
		Size                 = UDim2.new(1, -10, 1, 0),
		Position             = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Text                 = name,
		TextColor3           = theme.textdim,
		Font                 = fonts.semi,
		TextSize             = 11,
		TextXAlignment       = Enum.TextXAlignment.Left,
		ZIndex               = 3,
	})

	local container = makeinst("Frame", {
		Parent               = self.content,
		Size                 = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		Visible              = false,
	})

	local function makecolumn(xpos, xsize)
		local col = makeinst("ScrollingFrame", {
			Parent               = container,
			Size                 = UDim2.new(xsize, 0, 1, 0),
			Position             = UDim2.new(xpos, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel      = 0,
			ScrollBarThickness   = 0,
			ScrollBarImageColor3 = theme.scrollbar,
			CanvasSize           = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize  = Enum.AutomaticSize.Y,
		})
		makeinst("UIListLayout", {
			Parent    = col,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding   = UDim.new(0, 7),
		})
		makeinst("UIPadding", {
			Parent        = col,
			PaddingTop    = UDim.new(0, 10),
			PaddingLeft   = UDim.new(0, 10),
			PaddingRight  = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10),
		})
		return col
	end

	tabdata.columns.left   = makecolumn(0,   0.5)
	tabdata.columns.middle = makecolumn(0.5, 0.5)
	tabdata.columns.right  = tabdata.columns.middle

	makeinst("Frame", {
		Parent           = container,
		Size             = UDim2.new(0, 1, 1, 0),
		Position         = UDim2.new(0.5, 0, 0, 0),
		BackgroundColor3 = theme.columndivider,
		BorderSizePixel  = 0,
	})

	tabdata.btn       = btn
	tabdata.btnlbl    = btnlbl
	tabdata.accentbar = accentbar
	tabdata.container = container

	btn.MouseButton1Click:Connect(function() self:selecttab(tabdata) end)
	btn.MouseEnter:Connect(function()
		if self.activetab ~= tabdata then
			tw(btnlbl, { TextColor3 = theme.text })
			tw(btn,    { BackgroundTransparency = 0.88 })
		end
	end)
	btn.MouseLeave:Connect(function()
		if self.activetab ~= tabdata then
			tw(btnlbl, { TextColor3 = theme.textdim })
			tw(btn,    { BackgroundTransparency = 1 })
		end
	end)

	table.insert(self.tabs, tabdata)
	if #self.tabs == 1 then self:selecttab(tabdata) end
	return tabdata
end

function menulib:selecttab(tabdata)
	local theme = self.theme
	for _, fn in ipairs(self.openpopups) do fn() end
	self.openpopups = {}

	if self.activetab then
		local p = self.activetab
		tw(p.btn,       { BackgroundTransparency = 1 })
		tw(p.btnlbl,    { TextColor3 = theme.textdim })
		tw(p.accentbar, { BackgroundTransparency = 1 })
		p.container.Visible = false
	end

	self.activetab = tabdata
	tw(tabdata.btn,       { BackgroundTransparency = 0.82 })
	tw(tabdata.btnlbl,    { TextColor3 = theme.text })
	tw(tabdata.accentbar, { BackgroundTransparency = 0 })
	tabdata.container.Visible = true
end

function menulib:addsection(tabdata, name, side)
	local theme  = self.theme
	local column = tabdata.columns[side] or tabdata.columns.left
	local sectiondata = { name = name, side = side, elements = {}, body = nil }

	local frame = makeinst("Frame", {
		Parent           = column,
		Size             = UDim2.new(1, 0, 0, 0),
		AutomaticSize    = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.section,
		BorderSizePixel  = 0,
		LayoutOrder      = #tabdata.sections + 1,
	})
	makeinst("UIStroke", {
		Parent       = frame,
		Color        = theme.border,
		Thickness    = 1,
		Transparency = 0,
	})

	local header = makeinst("Frame", {
		Parent           = frame,
		Size             = UDim2.new(1, 0, 0, 28),
		BackgroundColor3 = theme.sectionheader,
		BorderSizePixel  = 0,
	})

	local pip = makeinst("Frame", {
		Parent           = header,
		Size             = UDim2.new(0, 2, 0, 10),
		Position         = UDim2.new(0, 10, 0.5, -5),
		BackgroundColor3 = theme.accent,
		BorderSizePixel  = 0,
	})
	makeinst("UICorner", { Parent = pip, CornerRadius = UDim.new(1, 0) })

	makeinst("TextLabel", {
		Parent               = header,
		Size                 = UDim2.new(1, -24, 1, 0),
		Position             = UDim2.new(0, 18, 0, 0),
		BackgroundTransparency = 1,
		Text                 = string.upper(name),
		TextColor3           = theme.textdim,
		Font                 = fonts.semi,
		TextSize             = 9,
		TextXAlignment       = Enum.TextXAlignment.Left,
	})

	local body = makeinst("Frame", {
		Parent            = frame,
		Size              = UDim2.new(1, 0, 0, 0),
		Position          = UDim2.new(0, 0, 0, 28),
		AutomaticSize     = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	})
	makeinst("UIListLayout", {
		Parent    = body,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding   = UDim.new(0, 0),
	})
	makeinst("UIPadding", {
		Parent        = body,
		PaddingBottom = UDim.new(0, 8),
	})

	sectiondata.frame = frame
	sectiondata.body  = body
	table.insert(tabdata.sections, sectiondata)
	return sectiondata
end

function menulib:addtoggle(sectiondata, label, default, options)
	local theme    = self.theme
	local state    = default or false
	local keybind  = options and options.keybind or false
	local callback = options and options.callback or nil
	local keybindcallback = options and options.keybindcallback or nil

	local elementdata = {
		type = "toggle", label = label, state = state,
		keybind = keybind, boundkey = nil, callback = callback,
	}

	local row = makeinst("Frame", {
		Parent               = sectiondata.body,
		Size                 = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		LayoutOrder          = #sectiondata.elements + 1,
	})

	local rowbg = makeinst("Frame", {
		Parent               = row,
		Size                 = UDim2.new(1, 0, 1, 0),
		BackgroundColor3     = theme.accent,
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
	})

	local lblright = keybind and -86 or -44
	local lbl = makeinst("TextLabel", {
		Parent               = row,
		Size                 = UDim2.new(1, lblright, 1, 0),
		Position             = UDim2.new(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text                 = label,
		TextColor3           = state and theme.text or theme.textdim,
		Font                 = fonts.regular,
		TextSize             = 11,
		TextXAlignment       = Enum.TextXAlignment.Left,
	})

	local pill = makeinst("Frame", {
		Parent           = row,
		Size             = UDim2.new(0, 30, 0, 16),
		Position         = UDim2.new(1, -40, 0.5, -8),
		BackgroundColor3 = state and theme.toggleon or theme.toggleoff,
		BorderSizePixel  = 0,
	})
	makeinst("UICorner", { Parent = pill, CornerRadius = UDim.new(1, 0) })
	local pillstroke = makeinst("UIStroke", {
		Parent    = pill,
		Color     = state and theme.accent or theme.toggleborder,
		Thickness = 1,
	})
	local knob = makeinst("Frame", {
		Parent           = pill,
		Size             = UDim2.new(0, 10, 0, 10),
		Position         = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5),
		BackgroundColor3 = state and theme.white or theme.textdark,
		BorderSizePixel  = 0,
	})
	makeinst("UICorner", { Parent = knob, CornerRadius = UDim.new(1, 0) })

	local function applystate()
		local t = self.theme
		if state then
			tw(pill,       { BackgroundColor3 = t.toggleon })
			tw(pillstroke, { Color = t.accent })
			tw(knob,       { Position = UDim2.new(1, -13, 0.5, -5), BackgroundColor3 = t.white })
			tw(lbl,        { TextColor3 = t.text })
		else
			tw(pill,       { BackgroundColor3 = t.toggleoff })
			tw(pillstroke, { Color = t.toggleborder })
			tw(knob,       { Position = UDim2.new(0, 3, 0.5, -5), BackgroundColor3 = t.textdark })
			tw(lbl,        { TextColor3 = t.textdim })
		end
	end

	if keybind then
		local listening = false
		local kbchip = makeinst("TextButton", {
			Parent           = row,
			Size             = UDim2.new(0, 38, 0, 16),
			Position         = UDim2.new(1, -82, 0.5, -8),
			BackgroundColor3 = theme.toggleoff,
			BorderSizePixel  = 0,
			Text             = "---",
			TextColor3       = theme.textdim,
			Font             = fonts.regular,
			TextSize         = 9,
			AutoButtonColor  = false,
			ZIndex           = 6,
		})
		makeinst("UICorner", { Parent = kbchip, CornerRadius = UDim.new(0, 4) })
		local kbstroke = makeinst("UIStroke", { Parent = kbchip, Color = theme.toggleborder, Thickness = 1 })
		elementdata.keybindbtn = kbchip

		kbchip.MouseButton1Click:Connect(function()
			if listening then return end
			listening = true
			kbchip.Text = "..."
			tw(kbchip,  { TextColor3 = theme.accent })
			tw(kbstroke, { Color = theme.accent })
			local conn
			conn = services.userinput.InputBegan:Connect(function(input, gpe)
				if gpe then return end
				if input.UserInputType == Enum.UserInputType.Keyboard then
					elementdata.boundkey = input.KeyCode
					kbchip.Text          = input.KeyCode.Name
					tw(kbchip,  { TextColor3 = theme.text })
					tw(kbstroke, { Color = theme.toggleborder })
					listening = false
					conn:Disconnect()
				end
			end)
		end)

		services.userinput.InputBegan:Connect(function(input, gpe)
			if gpe then return end
			if elementdata.boundkey and input.KeyCode == elementdata.boundkey then
				state = not state
				elementdata.state = state
				applystate()
				if keybindcallback then keybindcallback(state)
				else print(label .. " keybind:", elementdata.boundkey.Name, "→", state) end
				if callback then callback(state) end
			end
		end)
	end

	local btn = makeinst("TextButton", {
		Parent               = row,
		Size                 = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text                 = "",
		ZIndex               = 5,
		AutoButtonColor      = false,
	})

	btn.MouseEnter:Connect(function()  tw(rowbg, { BackgroundColor3 = self.theme.accent, BackgroundTransparency = 0.93 }) end)
	btn.MouseLeave:Connect(function()  tw(rowbg, { BackgroundTransparency = 1 })    end)
	btn.MouseButton1Click:Connect(function()
		state = not state
		elementdata.state = state
		applystate()
		if callback then callback(state) end
	end)

	elementdata.row = row
	elementdata.box = pill
	elementdata.lbl = lbl
	elementdata.setstate = function(newstate, fire)
		state             = newstate
		elementdata.state = newstate
		applystate()
		if fire and callback then callback(state) end
	end
	table.insert(sectiondata.elements, elementdata)
	return elementdata
end

function menulib:adddivider(sectiondata, text)
	local theme       = self.theme
	local layoutorder = #sectiondata.elements + 1

	local row = makeinst("Frame", {
		Parent               = sectiondata.body,
		Size                 = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		LayoutOrder          = layoutorder,
	})

	local segments   = 24
	local segw       = 0.9 / segments
	for i = 1, segments do
		local t     = (i - 0.5) / segments
		local dist  = math.abs(t - 0.5) * 2
		local alpha = math.max(0, 1 - dist ^ 1.4)
		makeinst("Frame", {
			Parent               = row,
			Size                 = UDim2.new(segw, 0, 0, 1),
			Position             = UDim2.new(0.05 + segw * (i-1), 0, 0.5, 0),
			BackgroundColor3     = theme.border,
			BackgroundTransparency = 1 - alpha,
			BorderSizePixel      = 0,
		})
	end

	if text and text ~= "" then
		makeinst("TextLabel", {
			Parent               = row,
			Size                 = UDim2.new(0, 0, 0, 14),
			Position             = UDim2.new(0.5, 0, 0.5, -7),
			AnchorPoint          = Vector2.new(0.5, 0),
			AutomaticSize        = Enum.AutomaticSize.X,
			BackgroundColor3     = theme.section,
			BackgroundTransparency = 0,
			BorderSizePixel      = 0,
			Text                 = "  " .. string.upper(text) .. "  ",
			TextColor3           = theme.textdark,
			Font                 = fonts.semi,
			TextSize             = 9,
			ZIndex               = 2,
		})
	end

	local dividerdata = { type = "divider", text = text, row = row }
	table.insert(sectiondata.elements, dividerdata)
	return dividerdata
end

function menulib:addslider(sectiondata, label, options)
	local theme    = self.theme
	local min      = options.min     or 0
	local max      = options.max     or 100
	local step     = options.step    or 1
	local default  = options.default or min
	local callback = options.callback or nil
	local value    = math.clamp(default, min, max)

	local elementdata = {
		type = "slider", label = label,
		value = value, min = min, max = max, step = step, callback = callback,
	}

	local row = makeinst("Frame", {
		Parent               = sectiondata.body,
		Size                 = UDim2.new(1, 0, 0, 38),
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		LayoutOrder          = #sectiondata.elements + 1,
	})
	local rowbg = makeinst("Frame", {
		Parent               = row,
		Size                 = UDim2.new(1, 0, 1, 0),
		BackgroundColor3     = theme.accent,
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
	})

	makeinst("TextLabel", {
		Parent               = row,
		Size                 = UDim2.new(0.65, 0, 0, 18),
		Position             = UDim2.new(0, 12, 0, 2),
		BackgroundTransparency = 1,
		Text                 = label,
		TextColor3           = theme.textdim,
		Font                 = fonts.regular,
		TextSize             = 11,
		TextXAlignment       = Enum.TextXAlignment.Left,
	})
	local valuelabel = makeinst("TextLabel", {
		Parent               = row,
		Size                 = UDim2.new(0.35, -12, 0, 18),
		Position             = UDim2.new(0.65, 0, 0, 2),
		BackgroundTransparency = 1,
		Text                 = tostring(value),
		TextColor3           = theme.accent,
		Font                 = fonts.semi,
		TextSize             = 11,
		TextXAlignment       = Enum.TextXAlignment.Right,
	})

	local track = makeinst("Frame", {
		Parent           = row,
		Size             = UDim2.new(1, -24, 0, 3),
		Position         = UDim2.new(0, 12, 0, 24),
		BackgroundColor3 = theme.toggleoff,
		BorderSizePixel  = 0,
	})
	makeinst("UICorner", { Parent = track, CornerRadius = UDim.new(1, 0) })
	makeinst("UIStroke", { Parent = track, Color = theme.toggleborder, Thickness = 1 })

	local function fillscale() return (value - min) / (max - min) end

	local fill = makeinst("Frame", {
		Parent           = track,
		Size             = UDim2.new(fillscale(), 0, 1, 0),
		BackgroundColor3 = theme.accent,
		BorderSizePixel  = 0,
	})
	makeinst("UICorner", { Parent = fill, CornerRadius = UDim.new(1, 0) })

	local function setvalue(newval)
		local stepped = math.round((newval - min) / step) * step + min
		value = math.clamp(stepped, min, max)
		elementdata.value = value
		valuelabel.Text   = tostring(value)
		tw(fill, { Size = UDim2.new(fillscale(), 0, 1, 0) })
		if callback then callback(value) end
	end

	local dragging = false
	local dragger  = makeinst("TextButton", {
		Parent               = row,
		Size                 = UDim2.new(1, -24, 0, 14),
		Position             = UDim2.new(0, 12, 0, 18),
		BackgroundTransparency = 1,
		Text                 = "",
		ZIndex               = 6,
		AutoButtonColor      = false,
	})

	dragger.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
	end)
	services.userinput.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			setvalue(min + rel * (max - min))
		end
	end)
	services.userinput.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)

	row.MouseEnter:Connect(function() tw(rowbg, { BackgroundColor3 = self.theme.accent, BackgroundTransparency = 0.93 }) end)
	row.MouseLeave:Connect(function() tw(rowbg, { BackgroundTransparency = 1 })    end)

	elementdata.row        = row
	elementdata.fill       = fill
	elementdata.track      = track
	elementdata.valuelabel = valuelabel
	table.insert(sectiondata.elements, elementdata)
	return elementdata
end

function menulib:addcolorpicker(sectiondata, label, defaultcolor, callback)
	local theme = self.theme
	local hue, sat, val = Color3.toHSV(defaultcolor or Color3.fromRGB(0, 200, 190))

	local elementdata = {
		type = "colorpicker", label = label,
		color = defaultcolor or Color3.fromRGB(0, 200, 190),
		callback = callback,
	}

	local row = makeinst("Frame", {
		Parent               = sectiondata.body,
		Size                 = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		LayoutOrder          = #sectiondata.elements + 1,
	})
	local rowbg = makeinst("Frame", {
		Parent               = row,
		Size                 = UDim2.new(1, 0, 1, 0),
		BackgroundColor3     = theme.accent,
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
	})

	local function tohex(c)
		return string.format("#%02X%02X%02X",
			math.round(c.R * 255), math.round(c.G * 255), math.round(c.B * 255))
	end

	local namelabel = makeinst("TextLabel", {
		Parent               = row,
		Size                 = UDim2.new(1, -86, 1, 0),
		Position             = UDim2.new(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text                 = label,
		TextColor3           = theme.textdim,
		Font                 = fonts.regular,
		TextSize             = 11,
		TextXAlignment       = Enum.TextXAlignment.Left,
	})

	local hexlabel = makeinst("TextLabel", {
		Parent               = row,
		Size                 = UDim2.new(0, 56, 1, 0),
		Position             = UDim2.new(1, -82, 0, 0),
		BackgroundTransparency = 1,
		Text                 = tohex(elementdata.color),
		TextColor3           = theme.textdim,
		Font                 = fonts.regular,
		TextSize             = 10,
		TextXAlignment       = Enum.TextXAlignment.Right,
	})

	local preview = makeinst("Frame", {
		Parent           = row,
		Size             = UDim2.new(0, 18, 0, 18),
		Position         = UDim2.new(1, -24, 0.5, -9),
		BackgroundColor3 = elementdata.color,
		BorderSizePixel  = 0,
	})
	local prevstroke = makeinst("UIStroke", { Parent = preview, Color = theme.toggleborder, Thickness = 1 })

	local svsize   = 100
	local huebarw  = 12
	local pad      = 8
	local gap      = 5
	local hexh     = 20
	local popupw   = pad + svsize + gap + huebarw + pad
	local popuph   = pad + svsize + gap + hexh     + pad

	local popup = makeinst("Frame", {
		Parent           = self.gui,
		Size             = UDim2.new(0, popupw, 0, popuph),
		BackgroundColor3 = theme.bgdark,
		BorderSizePixel  = 0,
		Visible          = false,
		ZIndex           = 150,
		Active           = true,
	})
	makeinst("UIStroke", { Parent = popup, Color = theme.border, Thickness = 1 })

	local svsquare = makeinst("Frame", {
		Parent           = popup,
		Size             = UDim2.new(0, svsize, 0, svsize),
		Position         = UDim2.new(0, pad, 0, pad),
		BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
		BorderSizePixel  = 0,
		ZIndex           = 160,
		ClipsDescendants = true,
	})

	local svbase = makeinst("Frame", { Parent = svsquare, Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0, ZIndex = 161 })
	makeinst("UIGradient", { Parent = svbase, Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)), Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1) }), Rotation = 0 })
	local svdark = makeinst("Frame", { Parent = svsquare, Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(0,0,0), BorderSizePixel = 0, ZIndex = 162 })
	makeinst("UIGradient", { Parent = svdark, Color = ColorSequence.new(Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0)), Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0) }), Rotation = 90 })

	local huebar = makeinst("Frame", {
		Parent           = popup,
		Size             = UDim2.new(0, huebarw, 0, svsize),
		Position         = UDim2.new(0, pad + svsize + gap, 0, pad),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel  = 0,
		ZIndex           = 160,
		ClipsDescendants = true,
	})
	makeinst("UIStroke", { Parent = huebar, Color = theme.border, Thickness = 1 })
	makeinst("UIGradient", {
		Parent = huebar,
		Color  = ColorSequence.new({
			ColorSequenceKeypoint.new(0,    Color3.fromRGB(255,0,0)),
			ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
			ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0,255,255)),
			ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
			ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
			ColorSequenceKeypoint.new(1,    Color3.fromRGB(255,0,0)),
		}),
		Rotation = 90,
	})

	local huecursor = makeinst("Frame", { Parent = huebar, Size = UDim2.new(1,0,0,2), Position = UDim2.new(0,0,hue,0), BackgroundColor3 = theme.white, BorderSizePixel = 0, ZIndex = 163 })
	local svcursor  = makeinst("Frame", { Parent = svsquare, Size = UDim2.new(0,6,0,6), Position = UDim2.new(sat,-3,1-val,-3), BackgroundColor3 = theme.white, BorderSizePixel = 0, ZIndex = 164 })
	makeinst("UICorner", { Parent = svcursor, CornerRadius = UDim.new(1,0) })
	makeinst("UIStroke", { Parent = svcursor, Color = theme.bgdark, Thickness = 1 })

	local hexinput = nil
	local function applycolor()
		local ok, c = pcall(Color3.fromHSV, hue, sat, val)
		if not ok then return end
		elementdata.color = c
		if preview  and preview.Parent  then preview.BackgroundColor3 = c end
		if hexlabel and hexlabel.Parent then hexlabel.Text = tohex(c) end
		if svsquare and svsquare.Parent then
			local ok2, hc = pcall(Color3.fromHSV, hue, 1, 1)
			if ok2 then svsquare.BackgroundColor3 = hc end
		end
		if hexinput and hexinput.Parent then hexinput.Text = tohex(c) end

		if callback then
			pcall(callback, c, math.round(c.R*255), math.round(c.G*255), math.round(c.B*255))
		end
	end

	local hexinputbg = makeinst("Frame", {
		Parent = popup,
		Size   = UDim2.new(0, svsize + gap + huebarw, 0, hexh),
		Position = UDim2.new(0, pad, 0, pad + svsize + gap),
		BackgroundColor3 = theme.toggleoff, BorderSizePixel = 0, ZIndex = 160,
	})
	makeinst("UIStroke", { Parent = hexinputbg, Color = theme.toggleborder, Thickness = 1 })

	hexinput = makeinst("TextBox", {
		Parent = hexinputbg, Size = UDim2.new(1,-8,1,0), Position = UDim2.new(0,4,0,0),
		BackgroundTransparency = 1, Text = tohex(elementdata.color),
		TextColor3 = theme.text, PlaceholderText = "#RRGGBB",
		PlaceholderColor3 = theme.textdim, Font = fonts.regular, TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ZIndex = 165,
	})
	hexinput.FocusLost:Connect(function()
		local raw = hexinput.Text:match("^#?(%x%x%x%x%x%x)$")
		if raw then
			local r = tonumber(raw:sub(1,2), 16) / 255
			local g = tonumber(raw:sub(3,4), 16) / 255
			local b = tonumber(raw:sub(5,6), 16) / 255
			hue, sat, val = Color3.toHSV(Color3.new(r,g,b))
			huecursor.Position = UDim2.new(0,0,hue,0)
			svcursor.Position  = UDim2.new(sat,-3,1-val,-3)
			applycolor()
		else hexinput.Text = tohex(elementdata.color) end
	end)

	local function positionpopup()
		local ap = row.AbsolutePosition; local as = row.AbsoluteSize
		local px = ap.X + as.X - popupw
		local py = ap.Y + as.Y + 2
		local sh = self.gui.AbsoluteSize.Y; local sw = self.gui.AbsoluteSize.X
		if py + popuph > sh then py = ap.Y - popuph - 2 end
		if px + popupw > sw then px = sw - popupw - 4 end
		if px < 0 then px = 4 end
		popup.Position = UDim2.new(0, px, 0, py)
	end

	local svdragging, huedragging = false, false
	local svbtn = makeinst("TextButton", { Parent = svsquare, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", ZIndex = 165, AutoButtonColor = false })
	svbtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			svdragging = true
			local rel = svsquare.AbsolutePosition; local sz = svsquare.AbsoluteSize
			sat = math.clamp((input.Position.X - rel.X) / sz.X, 0, 1)
			val = math.clamp(1 - (input.Position.Y - rel.Y) / sz.Y, 0, 1)
			svcursor.Position = UDim2.new(sat,-3,1-val,-3); applycolor()
		end
	end)
	local huebtn = makeinst("TextButton", { Parent = huebar, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", ZIndex = 165, AutoButtonColor = false })
	huebtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			huedragging = true
			local rel = huebar.AbsolutePosition; local sz = huebar.AbsoluteSize
			hue = math.clamp((input.Position.Y - rel.Y) / sz.Y, 0, 1)
			huecursor.Position = UDim2.new(0,0,hue,0); applycolor()
		end
	end)
	services.userinput.InputChanged:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
		if svdragging then
			local rel = svsquare.AbsolutePosition; local sz = svsquare.AbsoluteSize
			sat = math.clamp((input.Position.X - rel.X) / sz.X, 0, 1)
			val = math.clamp(1 - (input.Position.Y - rel.Y) / sz.Y, 0, 1)
			svcursor.Position = UDim2.new(sat,-3,1-val,-3); applycolor()
		end
		if huedragging then
			local rel = huebar.AbsolutePosition; local sz = huebar.AbsoluteSize
			hue = math.clamp((input.Position.Y - rel.Y) / sz.Y, 0, 1)
			huecursor.Position = UDim2.new(0,0,hue,0); applycolor()
		end
	end)
	services.userinput.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			svdragging = false; huedragging = false
		end
	end)

	local popupopen = false
	local function closepopupcp()
		popupopen = false; popup.Visible = false
		tw(prevstroke, { Color = theme.toggleborder })
	end

	local openbtn = makeinst("TextButton", {
		Parent = row, Size = UDim2.new(1,0,1,0),
		BackgroundTransparency = 1, Text = "", ZIndex = 5, AutoButtonColor = false,
	})
	openbtn.MouseEnter:Connect(function() tw(rowbg, { BackgroundColor3 = self.theme.accent, BackgroundTransparency = 0.93 }) end)
	openbtn.MouseLeave:Connect(function() tw(rowbg, { BackgroundTransparency = 1 })    end)
	openbtn.MouseButton1Click:Connect(function()
		if popupopen then closepopupcp()
		else
			for _, fn in ipairs(self.openpopups) do pcall(fn) end
			self.openpopups = {}
			positionpopup(); popup.Visible = true; popupopen = true
			tw(prevstroke, { Color = theme.accent })
			table.insert(self.openpopups, closepopupcp)
		end
	end)

	elementdata.row          = row
	elementdata.preview      = preview
	elementdata.hexlabel     = hexlabel
	elementdata.popup        = popup
	elementdata.positionfn   = positionpopup
	elementdata.setcolor = function(c)
		if typeof(c) ~= "Color3" then return end
		local ok, h, s, v2 = pcall(Color3.toHSV, c)
		if not ok then return end
		hue, sat, val = h, s, v2
		if huecursor and huecursor.Parent then huecursor.Position = UDim2.new(0, 0, hue, 0) end
		if svcursor  and svcursor.Parent  then svcursor.Position  = UDim2.new(sat, -3, 1 - val, -3) end
		applycolor()
	end
	table.insert(sectiondata.elements, elementdata)
	return elementdata
end

function menulib:adddropdown(sectiondata, label, options)
	local theme   = self.theme
	local choices = options.choices or {}
	local default = options.default or (choices[1] or "")
	local callback = options.callback or nil

	local elementdata = {
		type = "dropdown", label = label, selected = default,
		choices = choices, callback = callback,
	}

	local row = makeinst("Frame", {
		Parent               = sectiondata.body,
		Size                 = UDim2.new(1, 0, 0, 46),
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		LayoutOrder          = #sectiondata.elements + 1,
	})
	local rowbg = makeinst("Frame", {
		Parent               = row,
		Size                 = UDim2.new(1, 0, 1, 0),
		BackgroundColor3     = theme.accent,
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
	})

	makeinst("TextLabel", {
		Parent               = row,
		Size                 = UDim2.new(1, -20, 0, 20),
		Position             = UDim2.new(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text                 = label,
		TextColor3           = theme.textdim,
		Font                 = fonts.semi,
		TextSize             = 10,
		TextXAlignment       = Enum.TextXAlignment.Left,
	})

	local displaybg = makeinst("Frame", {
		Parent           = row,
		Size             = UDim2.new(1, -24, 0, 22),
		Position         = UDim2.new(0, 12, 0, 21),
		BackgroundColor3 = theme.toggleoff,
		BorderSizePixel  = 0,
	})
	local displaystroke = makeinst("UIStroke", { Parent = displaybg, Color = theme.toggleborder, Thickness = 1 })

	local displaylbl = makeinst("TextLabel", {
		Parent               = displaybg,
		Size                 = UDim2.new(1, -26, 1, 0),
		Position             = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1,
		Text                 = default,
		TextColor3           = theme.text,
		Font                 = fonts.regular,
		TextSize             = 11,
		TextXAlignment       = Enum.TextXAlignment.Left,
	})
	makeinst("TextLabel", {
		Parent               = displaybg,
		Size                 = UDim2.new(0, 16, 1, 0),
		Position             = UDim2.new(1, -18, 0, 0),
		BackgroundTransparency = 1,
		Text                 = "▾",
		TextColor3           = theme.textdim,
		Font                 = fonts.regular,
		TextSize             = 10,
	})

	local itemheight = 24; local maxvisible = 6

	local popup = makeinst("ScrollingFrame", {
		Parent               = self.gui,
		Size                 = UDim2.new(0, 1, 0, 0),
		BackgroundColor3     = theme.bgdark,
		BorderSizePixel      = 0,
		Visible              = false,
		ZIndex               = 100,
		ScrollBarThickness   = 0,
		ScrollBarImageColor3 = theme.scrollbar,
		ClipsDescendants     = true,
	})
	makeinst("UIStroke", { Parent = popup, Color = theme.border, Thickness = 1 })

	local popuplist = makeinst("Frame", {
		Parent               = popup,
		Size                 = UDim2.new(1, 0, 0, 0),
		AutomaticSize        = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	})
	makeinst("UIListLayout", { Parent = popuplist, SortOrder = Enum.SortOrder.LayoutOrder })

	local popupopen = false
	local itemhighlights = {}

	local function closepopup()
		popupopen = false; popup.Visible = false
		tw(displaystroke, { Color = theme.toggleborder })
	end

	local function buildpopup()
		for _, child in ipairs(popuplist:GetChildren()) do
			if not child:IsA("UIListLayout") then child:Destroy() end
		end
		itemhighlights = {}
		for idx, choice in ipairs(elementdata.choices) do
			local itembg = makeinst("Frame", {
				Parent = popuplist, Size = UDim2.new(1,0,0,itemheight),
				BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 101, LayoutOrder = idx,
			})
			local isselected = (choice == elementdata.selected)
			local hl = makeinst("Frame", {
				Parent = itembg, Size = UDim2.new(1,0,1,0),
				BackgroundColor3 = theme.accent, BackgroundTransparency = isselected and 0.82 or 1,
				BorderSizePixel = 0, ZIndex = 101,
			})
			makeinst("TextLabel", {
				Parent = itembg, Size = UDim2.new(1,-16,1,0), Position = UDim2.new(0,10,0,0),
				BackgroundTransparency = 1, Text = choice,
				TextColor3 = isselected and theme.text or theme.textdim,
				Font = fonts.regular, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 102,
			})
			local itembtn = makeinst("TextButton", {
				Parent = itembg, Size = UDim2.new(1,0,1,0),
				BackgroundTransparency = 1, Text = "", ZIndex = 200, AutoButtonColor = false,
			})
			itembtn.MouseEnter:Connect(function()
				if choice ~= elementdata.selected then tw(hl, { BackgroundTransparency = 0.92 }) end
			end)
			itembtn.MouseLeave:Connect(function()
				tw(hl, { BackgroundTransparency = choice == elementdata.selected and 0.82 or 1 })
			end)
			itembtn.MouseButton1Click:Connect(function()
				elementdata.selected = choice; displaylbl.Text = choice
				closepopup()
				if callback then callback(choice) end
			end)
			itemhighlights[choice] = hl
		end
		task.defer(function()
			local abs = displaybg.AbsolutePosition; local sz = displaybg.AbsoluteSize
			local sh  = self.gui.AbsoluteSize.Y
			local ph  = math.min(#elementdata.choices, maxvisible) * itemheight + 2
			local py  = abs.Y + sz.Y + 2
			if py + ph > sh then py = abs.Y - ph - 2 end
			popup.Position   = UDim2.new(0, abs.X, 0, py)
			popup.Size       = UDim2.new(0, sz.X,  0, ph)
			popup.CanvasSize = UDim2.new(0, 0,      0, #elementdata.choices * itemheight)
			popup.Visible    = true
			tw(displaystroke, { Color = theme.accent })
		end)
	end

	local function repositiondropdown()
		local abs = displaybg.AbsolutePosition; local sz = displaybg.AbsoluteSize
		local sh  = self.gui.AbsoluteSize.Y
		local ph  = popup.Size.Y.Offset
		local py  = abs.Y + sz.Y + 2
		if py + ph > sh then py = abs.Y - ph - 2 end
		popup.Position = UDim2.new(0, abs.X, 0, py)
	end

	local openbtn = makeinst("TextButton", {
		Parent = row, Size = UDim2.new(1,0,1,0),
		BackgroundTransparency = 1, Text = "", ZIndex = 5, AutoButtonColor = false,
	})
	openbtn.MouseEnter:Connect(function() tw(rowbg, { BackgroundColor3 = self.theme.accent, BackgroundTransparency = 0.93 }) end)
	openbtn.MouseLeave:Connect(function() tw(rowbg, { BackgroundTransparency = 1 })    end)
	openbtn.MouseButton1Click:Connect(function()
		if popupopen then closepopup()
		else
			for _, fn in ipairs(self.openpopups) do pcall(fn) end
			self.openpopups = {}; buildpopup(); popupopen = true
			table.insert(self.openpopups, closepopup)
		end
	end)

	elementdata.row            = row
	elementdata.displaybg      = displaybg
	elementdata.displaylbl     = displaylbl
	elementdata.popup          = popup
	elementdata.itemhighlights = itemhighlights
	elementdata.positionfn     = repositiondropdown
	table.insert(sectiondata.elements, elementdata)
	return elementdata
end

function menulib:addmultiselect(sectiondata, label, options)
	local theme      = self.theme
	local getchoices = type(options.choices) == "function" and options.choices or function() return options.choices or {} end
	local callback   = options.callback or nil
	local selected   = {}
	local chips      = {}

	local elementdata = {
		type = "multiselect", label = label, selected = selected, callback = callback,
	}

	local row = makeinst("Frame", {
		Parent            = sectiondata.body,
		Size              = UDim2.new(1, 0, 0, 0),
		AutomaticSize     = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel   = 0,
		LayoutOrder       = #sectiondata.elements + 1,
	})

	makeinst("TextLabel", {
		Parent               = row,
		Size                 = UDim2.new(1, -20, 0, 22),
		Position             = UDim2.new(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text                 = label,
		TextColor3           = theme.textdim,
		Font                 = fonts.semi,
		TextSize             = 10,
		TextXAlignment       = Enum.TextXAlignment.Left,
	})

	local chipstrip = makeinst("Frame", {
		Parent            = row,
		Size              = UDim2.new(1, -24, 0, 0),
		Position          = UDim2.new(0, 12, 0, 22),
		AutomaticSize     = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	})
	makeinst("UIListLayout", {
		Parent        = chipstrip,
		FillDirection = Enum.FillDirection.Horizontal,
		Wraps         = true,
		Padding       = UDim.new(0, 4),
		SortOrder     = Enum.SortOrder.LayoutOrder,
	})

	local inputbg = makeinst("Frame", {
		Parent           = row,
		Size             = UDim2.new(1, -24, 0, 22),
		Position         = UDim2.new(0, 12, 0, 22),
		BackgroundColor3 = theme.toggleoff,
		BorderSizePixel  = 0,
	})
	local inputstroke = makeinst("UIStroke", { Parent = inputbg, Color = theme.toggleborder, Thickness = 1 })

	local input = makeinst("TextBox", {
		Parent               = inputbg,
		Size                 = UDim2.new(1, -8, 1, 0),
		Position             = UDim2.new(0, 6, 0, 0),
		BackgroundTransparency = 1,
		Text                 = "",
		PlaceholderText      = "Search…",
		PlaceholderColor3    = theme.textdim,
		TextColor3           = theme.text,
		Font                 = fonts.regular,
		TextSize             = 11,
		TextXAlignment       = Enum.TextXAlignment.Left,
		ClearTextOnFocus     = false,
	})

	chipstrip:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		local h = chipstrip.AbsoluteSize.Y
		inputbg.Position = UDim2.new(0, 12, 0, 22 + (h > 0 and h + 4 or 0))
	end)

	local function removechip(choice)
		if chips[choice] then chips[choice]:Destroy(); chips[choice] = nil end
		selected[choice] = nil
		if callback then
			local vals = {}; for k in pairs(selected) do table.insert(vals, k) end; callback(vals)
		end
	end

	local function addchip(choice)
		if chips[choice] then return end
		local chip = makeinst("Frame", {
			Parent = chipstrip, Size = UDim2.new(0, 0, 0, 16),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = theme.accent, BackgroundTransparency = 0.75, BorderSizePixel = 0,
		})
		makeinst("UIListLayout", {
			Parent = chip, FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder,
		})
		makeinst("UIPadding", { Parent = chip, PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 4) })
		makeinst("TextLabel", {
			Parent = chip, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1, Text = choice, TextColor3 = theme.text, Font = fonts.semi, TextSize = 10,
			LayoutOrder = 2,
		})
		local xbtn = makeinst("TextButton", {
			Parent = chip, Size = UDim2.new(0, 12, 1, 0),
			BackgroundTransparency = 1, Text = "×", TextColor3 = theme.textdim,
			Font = fonts.bold, TextSize = 11, AutoButtonColor = false, LayoutOrder = 1,
		})
		xbtn.MouseButton1Click:Connect(function() removechip(choice) end)
		chips[choice] = chip
	end

	local itemheight = 24; local maxvisible = 5
	local popup = makeinst("ScrollingFrame", {
		Parent = self.gui, Size = UDim2.new(0, 1, 0, 0),
		BackgroundColor3 = theme.bgdark, BorderSizePixel = 0,
		Visible = false, ZIndex = 100, ScrollBarThickness = 0,
		ScrollBarImageColor3 = theme.scrollbar, ClipsDescendants = true,
	})
	makeinst("UIStroke", { Parent = popup, Color = theme.border, Thickness = 1 })

	local popuplist = makeinst("Frame", {
		Parent = popup, Size = UDim2.new(1,0,0,0),
		AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
	})
	makeinst("UIListLayout", { Parent = popuplist, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,0) })

	local function closepopupsb()
		popup.Visible = false; tw(inputstroke, { Color = theme.toggleborder })
	end

	local function refreshpopup()
		local allchoices = getchoices(); local q = input.Text:lower()
		local filtered = {}
		for _, c in ipairs(allchoices) do
			local s = tostring(c)
			if q == "" or s:lower():find(q, 1, true) then table.insert(filtered, s) end
		end
		for _, child in ipairs(popuplist:GetChildren()) do
			if not child:IsA("UIListLayout") then child:Destroy() end
		end
		if #filtered == 0 then closepopupsb(); return end

		for idx, choicestr in ipairs(filtered) do
			local itembg = makeinst("Frame", {
				Parent = popuplist, Size = UDim2.new(1,0,0,itemheight),
				BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 101, LayoutOrder = idx,
			})
			local ssel = selected[choicestr]
			local hl   = makeinst("Frame", {
				Parent = itembg, Size = UDim2.new(1,0,1,0),
				BackgroundColor3 = theme.accent, BackgroundTransparency = ssel and 0.82 or 1,
				BorderSizePixel = 0, ZIndex = 101,
			})
			makeinst("TextLabel", {
				Parent = itembg, Size = UDim2.new(1,-10,1,0), Position = UDim2.new(0,10,0,0),
				BackgroundTransparency = 1, Text = choicestr,
				TextColor3 = ssel and theme.text or theme.textdim,
				Font = fonts.regular, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 102,
			})
			local itembtn = makeinst("TextButton", {
				Parent = itembg, Size = UDim2.new(1,0,1,0),
				BackgroundTransparency = 1, Text = "", ZIndex = 200, AutoButtonColor = false,
			})
			itembtn.MouseEnter:Connect(function()
				if not selected[choicestr] then tw(hl, { BackgroundTransparency = 0.92 }) end
			end)
			itembtn.MouseLeave:Connect(function()
				tw(hl, { BackgroundTransparency = selected[choicestr] and 0.82 or 1 })
			end)
			itembtn.MouseButton1Click:Connect(function()
				if selected[choicestr] then
					selected[choicestr] = nil; removechip(choicestr)
				else
					selected[choicestr] = true; addchip(choicestr)
					if callback then
						local vals = {}; for k in pairs(selected) do table.insert(vals, k) end; callback(vals)
					end
				end
				input.Text = ""; refreshpopup()
			end)
		end

		task.defer(function()
			local abs  = inputbg.AbsolutePosition; local sz = inputbg.AbsoluteSize
			local sh   = self.gui.AbsoluteSize.Y
			local ph   = math.min(#filtered, maxvisible) * itemheight + 2
			local py   = abs.Y + sz.Y + 2
			if py + ph > sh then py = abs.Y - ph - 2 end
			popup.Position   = UDim2.new(0, abs.X, 0, py)
			popup.Size       = UDim2.new(0, sz.X,  0, ph)
			popup.CanvasSize = UDim2.new(0, 0,      0, #filtered * itemheight)
			popup.Visible    = true
			tw(inputstroke, { Color = theme.accent })
		end)
	end

	input.Focused:Connect(function()
		refreshpopup(); table.insert(self.openpopups, closepopupsb)
	end)
	input.FocusLost:Connect(function()
		task.delay(0.15, function() if not input:IsFocused() then closepopupsb() end end)
	end)
	input:GetPropertyChangedSignal("Text"):Connect(function()
		if input:IsFocused() then refreshpopup() end
	end)

	local function repositionmulti()
		if not popup.Visible then return end
		local abs = inputbg.AbsolutePosition; local sz = inputbg.AbsoluteSize
		local sh  = self.gui.AbsoluteSize.Y
		local ph  = popup.Size.Y.Offset
		local py  = abs.Y + sz.Y + 2
		if py + ph > sh then py = abs.Y - ph - 2 end
		popup.Position = UDim2.new(0, abs.X, 0, py)
	end

	elementdata.row        = row
	elementdata.input      = input
	elementdata.chipstrip  = chipstrip
	elementdata.popup      = popup
	elementdata.positionfn = repositionmulti
	elementdata.addchip    = addchip
	elementdata.removechip = removechip
	table.insert(sectiondata.elements, elementdata)
	return elementdata
end

function menulib:addtextbox(sectiondata, label, options)
	local theme       = self.theme
	local placeholder = (options and options.placeholder) or ""
	local callback    = (options and options.callback) or nil
	local live        = (options and options.live) or false
	local elementdata = { type = "textbox", label = label }

	local row = makeinst("Frame", {
		Parent               = sectiondata.body,
		Size                 = UDim2.new(1, 0, 0, 46),
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		LayoutOrder          = #sectiondata.elements + 1,
	})

	makeinst("TextLabel", {
		Parent               = row,
		Size                 = UDim2.new(1, -20, 0, 20),
		Position             = UDim2.new(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text                 = label,
		TextColor3           = theme.textdim,
		Font                 = fonts.regular,
		TextSize             = 11,
		TextXAlignment       = Enum.TextXAlignment.Left,
	})

	local inputbg = makeinst("Frame", {
		Parent           = row,
		Size             = UDim2.new(1, -24, 0, 22),
		Position         = UDim2.new(0, 12, 0, 22),
		BackgroundColor3 = theme.toggleoff,
		BorderSizePixel  = 0,
	})
	local inputstroke = makeinst("UIStroke", { Parent = inputbg, Color = theme.toggleborder, Thickness = 1 })

	local textbox = makeinst("TextBox", {
		Parent               = inputbg,
		Size                 = UDim2.new(1, -10, 1, 0),
		Position             = UDim2.new(0, 6, 0, 0),
		BackgroundTransparency = 1,
		Text                 = "",
		PlaceholderText      = placeholder,
		PlaceholderColor3    = theme.textdim,
		TextColor3           = theme.text,
		Font                 = fonts.regular,
		TextSize             = 11,
		TextXAlignment       = Enum.TextXAlignment.Left,
		ClearTextOnFocus     = false,
	})

	textbox.Focused:Connect(function() tw(inputstroke, { Color = theme.accent }) end)
	textbox.FocusLost:Connect(function(enter)
		tw(inputstroke, { Color = theme.toggleborder })
		if not live and callback then callback(textbox.Text, enter) end
	end)
	if live then
		textbox:GetPropertyChangedSignal("Text"):Connect(function()
			if callback then callback(textbox.Text) end
		end)
	end

	elementdata.row     = row
	elementdata.inputbg = inputbg
	elementdata.textbox = textbox
	table.insert(sectiondata.elements, elementdata)
	return elementdata
end

function menulib:addsearchbox(sectiondata, label, options)
	local theme      = self.theme
	local getchoices = type(options.choices) == "function" and options.choices or function() return options.choices or {} end
	local callback   = options.callback or nil
	local placeholder = options.placeholder or "Search…"
	local selected   = {}
	local chips      = {}

	if options.default then
		for _, v in ipairs(options.default) do selected[v] = true end
	end

	local elementdata = {
		type = "searchbox", label = label, selected = selected, callback = callback,
	}

	local row = makeinst("Frame", {
		Parent            = sectiondata.body,
		Size              = UDim2.new(1, 0, 0, 0),
		AutomaticSize     = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel   = 0,
		LayoutOrder       = #sectiondata.elements + 1,
	})

	makeinst("TextLabel", {
		Parent               = row,
		Size                 = UDim2.new(1, -20, 0, 22),
		Position             = UDim2.new(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text                 = label,
		TextColor3           = theme.textdim,
		Font                 = fonts.semi,
		TextSize             = 10,
		TextXAlignment       = Enum.TextXAlignment.Left,
	})

	local chipstrip = makeinst("Frame", {
		Parent            = row,
		Size              = UDim2.new(1, -24, 0, 0),
		Position          = UDim2.new(0, 12, 0, 22),
		AutomaticSize     = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	})
	makeinst("UIListLayout", {
		Parent        = chipstrip,
		FillDirection = Enum.FillDirection.Horizontal,
		Wraps         = true,
		Padding       = UDim.new(0, 4),
		SortOrder     = Enum.SortOrder.LayoutOrder,
	})

	local inputbg = makeinst("Frame", {
		Parent           = row,
		Size             = UDim2.new(1, -24, 0, 22),
		Position         = UDim2.new(0, 12, 0, 22),
		BackgroundColor3 = theme.toggleoff,
		BorderSizePixel  = 0,
	})
	local inputstroke = makeinst("UIStroke", { Parent = inputbg, Color = theme.toggleborder, Thickness = 1 })

	local input = makeinst("TextBox", {
		Parent               = inputbg,
		Size                 = UDim2.new(1, -8, 1, 0),
		Position             = UDim2.new(0, 6, 0, 0),
		BackgroundTransparency = 1,
		Text                 = "",
		PlaceholderText      = placeholder,
		PlaceholderColor3    = theme.textdim,
		TextColor3           = theme.text,
		Font                 = fonts.regular,
		TextSize             = 11,
		TextXAlignment       = Enum.TextXAlignment.Left,
		ClearTextOnFocus     = false,
	})

	chipstrip:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		local h = chipstrip.AbsoluteSize.Y
		inputbg.Position = UDim2.new(0, 12, 0, 22 + (h > 0 and h + 4 or 0))
	end)

	local function removechip(choice)
		if chips[choice] then chips[choice]:Destroy(); chips[choice] = nil end
		selected[choice] = nil
		if callback then
			local vals = {}; for k in pairs(selected) do table.insert(vals, k) end; callback(vals)
		end
	end

	local function addchip(choice)
		if chips[choice] then return end
		local chip = makeinst("Frame", {
			Parent = chipstrip, Size = UDim2.new(0, 0, 0, 16),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = theme.accent, BackgroundTransparency = 0.75, BorderSizePixel = 0,
		})
		makeinst("UIListLayout", {
			Parent = chip, FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder,
		})
		makeinst("UIPadding", { Parent = chip, PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 4) })
		makeinst("TextLabel", {
			Parent = chip, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1, Text = choice, TextColor3 = theme.text, Font = fonts.semi, TextSize = 10,
			LayoutOrder = 2,
		})
		local xbtn = makeinst("TextButton", {
			Parent = chip, Size = UDim2.new(0, 12, 1, 0),
			BackgroundTransparency = 1, Text = "×", TextColor3 = theme.textdim,
			Font = fonts.bold, TextSize = 11, AutoButtonColor = false, LayoutOrder = 1,
		})
		xbtn.MouseButton1Click:Connect(function() removechip(choice) end)
		chips[choice] = chip
	end

	for v in pairs(selected) do addchip(v) end

	local itemheight = 24; local maxvisible = 5
	local popup = makeinst("ScrollingFrame", {
		Parent = self.gui, Size = UDim2.new(0, 1, 0, 0),
		BackgroundColor3 = theme.bgdark, BorderSizePixel = 0,
		Visible = false, ZIndex = 100, ScrollBarThickness = 0,
		ScrollBarImageColor3 = theme.scrollbar, ClipsDescendants = true,
	})
	makeinst("UIStroke", { Parent = popup, Color = theme.border, Thickness = 1 })

	local popuplist = makeinst("Frame", {
		Parent = popup, Size = UDim2.new(1,0,0,0),
		AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
	})
	makeinst("UIListLayout", { Parent = popuplist, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,0) })

	local function closepopup()
		popup.Visible = false; tw(inputstroke, { Color = theme.toggleborder })
	end

	local function refreshpopup()
		local allchoices = getchoices(); local q = input.Text:lower()
		local filtered = {}
		for _, c in ipairs(allchoices) do
			local s = tostring(c)
			if q == "" or s:lower():find(q, 1, true) then table.insert(filtered, s) end
		end
		for _, child in ipairs(popuplist:GetChildren()) do
			if not child:IsA("UIListLayout") then child:Destroy() end
		end
		if #filtered == 0 then closepopup(); return end

		for idx, choicestr in ipairs(filtered) do
			local itembg = makeinst("Frame", {
				Parent = popuplist, Size = UDim2.new(1,0,0,itemheight),
				BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 101, LayoutOrder = idx,
			})
			local ssel = selected[choicestr]
			local hl   = makeinst("Frame", {
				Parent = itembg, Size = UDim2.new(1,0,1,0),
				BackgroundColor3 = theme.accent, BackgroundTransparency = ssel and 0.82 or 1,
				BorderSizePixel = 0, ZIndex = 101,
			})
			makeinst("TextLabel", {
				Parent = itembg, Size = UDim2.new(1,-10,1,0), Position = UDim2.new(0,10,0,0),
				BackgroundTransparency = 1, Text = choicestr,
				TextColor3 = ssel and theme.text or theme.textdim,
				Font = fonts.regular, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 102,
			})
			local itembtn = makeinst("TextButton", {
				Parent = itembg, Size = UDim2.new(1,0,1,0),
				BackgroundTransparency = 1, Text = "", ZIndex = 200, AutoButtonColor = false,
			})
			itembtn.MouseEnter:Connect(function()
				if not selected[choicestr] then tw(hl, { BackgroundTransparency = 0.92 }) end
			end)
			itembtn.MouseLeave:Connect(function()
				tw(hl, { BackgroundTransparency = selected[choicestr] and 0.82 or 1 })
			end)
			itembtn.MouseButton1Click:Connect(function()
				if selected[choicestr] then
					selected[choicestr] = nil; removechip(choicestr)
				else
					selected[choicestr] = true; addchip(choicestr)
					if callback then
						local vals = {}; for k in pairs(selected) do table.insert(vals, k) end; callback(vals)
					end
				end
				input.Text = ""; refreshpopup()
			end)
		end

		task.defer(function()
			local abs  = inputbg.AbsolutePosition; local sz = inputbg.AbsoluteSize
			local sh   = self.gui.AbsoluteSize.Y
			local ph   = math.min(#filtered, maxvisible) * itemheight + 2
			local py   = abs.Y + sz.Y + 2
			if py + ph > sh then py = abs.Y - ph - 2 end
			popup.Position   = UDim2.new(0, abs.X, 0, py)
			popup.Size       = UDim2.new(0, sz.X,  0, ph)
			popup.CanvasSize = UDim2.new(0, 0,      0, #filtered * itemheight)
			popup.Visible    = true
			tw(inputstroke, { Color = theme.accent })
		end)
	end

	input.Focused:Connect(function()
		refreshpopup(); table.insert(self.openpopups, closepopup)
	end)
	input.FocusLost:Connect(function()
		task.delay(0.15, function() if not input:IsFocused() then closepopup() end end)
	end)
	input:GetPropertyChangedSignal("Text"):Connect(function()
		if input:IsFocused() then refreshpopup() end
	end)

	local function repositionsearch()
		if not popup.Visible then return end
		local abs = inputbg.AbsolutePosition; local sz = inputbg.AbsoluteSize
		local sh  = self.gui.AbsoluteSize.Y
		local ph  = popup.Size.Y.Offset
		local py  = abs.Y + sz.Y + 2
		if py + ph > sh then py = abs.Y - ph - 2 end
		popup.Position = UDim2.new(0, abs.X, 0, py)
	end

	elementdata.row        = row
	elementdata.input      = input
	elementdata.chipstrip  = chipstrip
	elementdata.popup      = popup
	elementdata.positionfn = repositionsearch
	elementdata.addchip    = addchip
	elementdata.removechip = removechip
	table.insert(sectiondata.elements, elementdata)
	return elementdata
end
menulib.addmultidropdown = menulib.addmultiselect

function menulib:addbutton(sectiondata, label, options)
	local theme    = self.theme
	local callback = (options and options.callback) or function() print("button:", label) end
	local elementdata = { type = "button", label = label, callback = callback }

	local row = makeinst("Frame", {
		Parent               = sectiondata.body,
		Size                 = UDim2.new(1, 0, 0, 34),
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		LayoutOrder          = #sectiondata.elements + 1,
	})

	local btnbg = makeinst("Frame", {
		Parent           = row,
		Size             = UDim2.new(1, -24, 0, 24),
		Position         = UDim2.new(0, 12, 0.5, -12),
		BackgroundColor3 = theme.toggleoff,
		BorderSizePixel  = 0,
	})
	local btnstroke = makeinst("UIStroke", { Parent = btnbg, Color = theme.toggleborder, Thickness = 1 })

	local btnlbl = makeinst("TextLabel", {
		Parent               = btnbg,
		Size                 = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text                 = label,
		TextColor3           = theme.textdim,
		Font                 = fonts.semi,
		TextSize             = 11,
		TextXAlignment       = Enum.TextXAlignment.Center,
	})

	local btn = makeinst("TextButton", {
		Parent               = btnbg,
		Size                 = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text                 = "",
		AutoButtonColor      = false,
		ZIndex               = 5,
	})

	btn.MouseEnter:Connect(function()
		tw(btnstroke, { Color = theme.accent })
		tw(btnlbl,    { TextColor3 = theme.text })
	end)
	btn.MouseLeave:Connect(function()
		tw(btnstroke, { Color = theme.toggleborder })
		tw(btnlbl,    { TextColor3 = theme.textdim })
	end)
	btn.MouseButton1Click:Connect(function()
		tw(btnstroke, { Color = theme.accent })
		tw(btnlbl,    { TextColor3 = theme.accent })
		task.delay(0.14, function()
			tw(btnstroke, { Color = theme.toggleborder })
			tw(btnlbl,    { TextColor3 = theme.textdim })
		end)
		callback()
	end)

	elementdata.row   = row
	elementdata.btnbg = btnbg
	table.insert(sectiondata.elements, elementdata)
	return elementdata
end

function menulib:addlabel(sectiondata, text)
	local theme       = self.theme
	local layoutorder = #sectiondata.elements + 1

	local row = makeinst("Frame", {
		Parent               = sectiondata.body,
		Size                 = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		LayoutOrder          = layoutorder,
	})
	local lbl = makeinst("TextLabel", {
		Parent               = row,
		Size                 = UDim2.new(1, -24, 1, 0),
		Position             = UDim2.new(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text                 = text,
		TextColor3           = theme.textdim,
		Font                 = fonts.regular,
		TextSize             = 11,
		TextXAlignment       = Enum.TextXAlignment.Left,
		TextWrapped          = true,
	})

	local labeldata = { type = "label", text = text, row = row, lbl = lbl }
	table.insert(sectiondata.elements, labeldata)
	return labeldata
end

function menulib:newwindow(title, options)
	local W    = (options and options.width)  or 240
	local H    = (options and options.height) or 200
	local xpos = (options and options.x)      or 20
	local ypos = (options and options.y)      or 20

	local windata = { lines = {}, vars = {}, labels = {}, _visible = true }

	local root = makeinst("Frame", {
		Parent           = self.gui,
		Size             = UDim2.new(0, W, 0, H),
		Position         = UDim2.new(0, xpos, 0, ypos),
		BackgroundColor3 = self.theme.bg,
		BorderSizePixel  = 0,
		ZIndex           = 10,
		ClipsDescendants = true,
	})
	local rootstroke = makeinst("UIStroke", {
		Parent    = root,
		Color     = self.theme.accent,
		Thickness = 1,
	})

	local titlebar = makeinst("Frame", {
		Parent           = root,
		Size             = UDim2.new(1, 0, 0, 26),
		BackgroundColor3 = self.theme.bgdark,
		BorderSizePixel  = 0,
		ZIndex           = 11,
	})
	local titlesep = makeinst("Frame", {
		Parent           = titlebar,
		Size             = UDim2.new(1, 0, 0, 1),
		Position         = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = self.theme.accent,
		BackgroundTransparency = 0.78,
		BorderSizePixel  = 0,
		ZIndex           = 12,
	})

	local titlerow = makeinst("Frame", {
		Parent               = titlebar,
		Size                 = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex               = 12,
	})
	makeinst("UIListLayout", {
		Parent            = titlerow,
		FillDirection     = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding           = UDim.new(0, 0),
	})
	makeinst("UIPadding", { Parent = titlerow, PaddingLeft = UDim.new(0, 10) })

	local titlelbl = makeinst("TextLabel", {
		Parent               = titlerow,
		Size                 = UDim2.new(1, 0, 1, 0),
		AutomaticSize        = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Text                 = title,
		TextColor3           = self.theme.text,
		Font                 = fonts.semi,
		TextSize             = 11,
		ZIndex               = 12,
	})

	local body = makeinst("ScrollingFrame", {
		Parent               = root,
		Size                 = UDim2.new(1, 0, 1, -27),
		Position             = UDim2.new(0, 0, 0, 27),
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		ScrollBarThickness   = 0,
		ScrollBarImageColor3 = self.theme.scrollbar,
		CanvasSize           = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize  = Enum.AutomaticSize.Y,
		ZIndex               = 11,
	})
	makeinst("UIListLayout", { Parent = body, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 0) })
	makeinst("UIPadding", {
		Parent        = body,
		PaddingTop    = UDim.new(0, 6),
		PaddingBottom = UDim.new(0, 6),
		PaddingLeft   = UDim.new(0, 10),
		PaddingRight  = UDim.new(0, 10),
	})

	windata.root      = root
	windata.titlebar  = titlebar
	windata.body      = body
	windata.rootstroke = rootstroke
	windata.titlelbl  = titlelbl
	windata.titlesep  = titlesep

	local dragging, dragstart, startpos = false, Vector2.new(), Vector2.new()
	titlebar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true; dragstart = input.Position; startpos = root.Position
		end
	end)
	services.userinput.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local d = input.Position - dragstart
			root.Position = UDim2.new(startpos.X.Scale, startpos.X.Offset + d.X,
			                          startpos.Y.Scale, startpos.Y.Offset + d.Y)
		end
	end)
	services.userinput.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)

	local function resolvetext(s, vars)
		return (s:gsub("{(%w+)}", function(k) return tostring(vars[k] or ("{" .. k .. "}")) end))
	end

	local function rebuild()
		for _, lbl in ipairs(windata.labels) do lbl:Destroy() end
		windata.labels = {}
		for i, line in ipairs(windata.lines) do
			local lbl = makeinst("TextLabel", {
				Parent               = body,
				Size                 = UDim2.new(1, 0, 0, 18),
				BackgroundTransparency = 1,
				Text                 = resolvetext(line, windata.vars),
				TextColor3           = self.theme.text,
				Font                 = fonts.regular,
				TextSize             = 11,
				TextXAlignment       = Enum.TextXAlignment.Left,
				TextWrapped          = true,
				LayoutOrder          = i,
				ZIndex               = 12,
			})
			table.insert(windata.labels, lbl)
		end
	end

	function windata:setlines(t)
		self.lines = t; rebuild()
	end

	function windata:setline(i, s)
		self.lines[i] = s
		if self.labels[i] then self.labels[i].Text = resolvetext(s, self.vars) end
	end

	function windata:setvars(t)
		for k, v in pairs(t) do self.vars[k] = v end
		for i, lbl in ipairs(self.labels) do lbl.Text = resolvetext(self.lines[i] or "", self.vars) end
	end

	function windata:setvar(k, v)
		self.vars[k] = v
		for i, lbl in ipairs(self.labels) do lbl.Text = resolvetext(self.lines[i] or "", self.vars) end
	end

	function windata:applytheme(theme)
		root.BackgroundColor3     = theme.bg
		titlebar.BackgroundColor3 = theme.bgdark
		rootstroke.Color          = theme.accent
		titlesep.BackgroundColor3 = theme.accent
		titlelbl.TextColor3       = theme.text
		body.ScrollBarImageColor3 = theme.scrollbar
		for _, lbl in ipairs(self.labels) do lbl.TextColor3 = theme.text end
	end

	table.insert(self._themelisteners, function(t) windata:applytheme(t) end)

	function windata:show()    root.Visible = true  end
	function windata:hide()    root.Visible = false end
	function windata:destroy() root:Destroy()       end

	windata._poskey = options and options.poskey or nil
	if windata._poskey then
		table.insert(self._positionables, {
			key    = windata._poskey,
			getpos = function()
				return { x = root.Position.X.Offset, y = root.Position.Y.Offset,
				         xs = root.Position.X.Scale,  ys = root.Position.Y.Scale }
			end,
			setpos = function(p)
				root.Position = UDim2.new(p.xs or 0, p.x or 0, p.ys or 0, p.y or 0)
			end,
		})
	end

	return windata
end

function menulib:newwatermark(text, options)
	local corner  = (options and options.corner) or "topright"

	local anchorX = (corner == "topright"  or corner == "bottomright") and 1 or 0
	local anchorY = (corner == "bottomleft" or corner == "bottomright") and 1 or 0
	local posX    = anchorX == 1 and 1 or 0
	local posY    = anchorY == 1 and 1 or 0
	local offX    = anchorX == 1 and -14 or 14
	local offY    = anchorY == 1 and -14 or 14

	local wmdata = { _text = text, _vars = {} }

	local function resolvetext(s, vars)
		return (s:gsub("{(%w+)}", function(k) return tostring(vars[k] or ("{" .. k .. "}")) end))
	end

	local frame = makeinst("Frame", {
		Parent               = self.gui,
		Size                 = UDim2.new(0, 0, 0, 24),
		AutomaticSize        = Enum.AutomaticSize.X,
		AnchorPoint          = Vector2.new(anchorX, anchorY),
		Position             = UDim2.new(posX, offX, posY, offY),
		BackgroundColor3     = self.theme.bgdark,
		BorderSizePixel      = 0,
		ZIndex               = 200,
	})
	local wmstroke = makeinst("UIStroke", {
		Parent    = frame,
		Color     = self.theme.accent,
		Thickness = 1,
	})
	makeinst("UIPadding", {
		Parent       = frame,
		PaddingLeft  = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
	})

	local lbl = makeinst("TextLabel", {
		Parent               = frame,
		Size                 = UDim2.new(0, 0, 1, 0),
		AutomaticSize        = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Text                 = resolvetext(text, wmdata._vars),
		TextColor3           = self.theme.text,
		Font                 = fonts.semi,
		TextSize             = 11,
		ZIndex               = 201,
	})

	wmdata.frame    = frame
	wmdata.lbl      = lbl
	wmdata.wmstroke = wmstroke

	local dragging, dragstart, startpos = false, Vector2.new(), Vector2.new()
	local dragbtn = makeinst("TextButton", {
		Parent               = frame,
		Size                 = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text                 = "",
		ZIndex               = 202,
		AutoButtonColor      = false,
	})
	dragbtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging  = true
			dragstart = input.Position
			startpos  = frame.Position
		end
	end)
	services.userinput.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local d = input.Position - dragstart
			frame.AnchorPoint = Vector2.new(0, 0)
			frame.Position = UDim2.new(
				startpos.X.Scale, startpos.X.Offset + d.X,
				startpos.Y.Scale, startpos.Y.Offset + d.Y
			)
		end
	end)
	services.userinput.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)

	function wmdata:settext(s)
		self._text = s; lbl.Text = resolvetext(s, self._vars)
	end

	function wmdata:setvars(t)
		for k, v in pairs(t) do self._vars[k] = v end
		lbl.Text = resolvetext(self._text, self._vars)
	end

	function wmdata:setvar(k, v)
		self._vars[k] = v
		lbl.Text = resolvetext(self._text, self._vars)
	end

	function wmdata:applytheme(theme)
		frame.BackgroundColor3 = theme.bgdark
		wmstroke.Color         = theme.accent
		lbl.TextColor3         = theme.text
	end

	table.insert(self._themelisteners, function(t) wmdata:applytheme(t) end)

	function wmdata:show()    frame.Visible = true  end
	function wmdata:hide()    frame.Visible = false end
	function wmdata:destroy() frame:Destroy()       end

	wmdata._poskey = options and options.poskey or nil
	if wmdata._poskey then
		table.insert(self._positionables, {
			key    = wmdata._poskey,
			getpos = function()
				return { x = frame.Position.X.Offset, y = frame.Position.Y.Offset,
				         xs = frame.Position.X.Scale,  ys = frame.Position.Y.Scale }
			end,
			setpos = function(p)
				frame.AnchorPoint = Vector2.new(0, 0)
				frame.Position = UDim2.new(p.xs or 0, p.x or 0, p.ys or 0, p.y or 0)
			end,
		})
	end

	return wmdata
end

return menulib
