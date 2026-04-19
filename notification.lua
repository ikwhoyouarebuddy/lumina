local notiflib = {}

local services = {
	players = game:GetService("Players"),
	tween   = game:GetService("TweenService"),
}

local localplayer = services.players.LocalPlayer
local playergui   = localplayer:WaitForChild("PlayerGui")

local fonts = {
	regular = Enum.Font.Gotham,
	semi    = Enum.Font.GothamSemibold,
}

local ti = {
	fast   = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	medium = TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
}

local theme = {
	bg      = Color3.fromRGB(6,   8,   13),
	bgdark  = Color3.fromRGB(3,   4,   8),
	border  = Color3.fromRGB(22,  30,  46),
	text    = Color3.fromRGB(205, 215, 235),
	textdim = Color3.fromRGB(72,  88,  118),
}

local typecolors = {
	info    = Color3.fromRGB(0,   200, 190),
	success = Color3.fromRGB(40,  210, 100),
	warning = Color3.fromRGB(255, 180, 0),
	error   = Color3.fromRGB(255, 65,  75),
}

local w      = 220
local margin = 12
local gap    = 6
local active = {}

local function makeinst(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props) do inst[k] = v end
	return inst
end

local function tw(inst, props, speed)
	services.tween:Create(inst, speed or ti.fast, props):Play()
end

local gui = makeinst("ScreenGui", {
	Parent         = playergui,
	Name           = "luminanotifs",
	ResetOnSpawn   = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Global,
	DisplayOrder   = 999,
})

local function restack()
	local y = margin
	for i = 1, #active do
		local e = active[i]
		if e.frame and e.frame.Parent then
			local h = e.frame.AbsoluteSize.Y
			tw(e.frame, {
				Position = UDim2.new(1, -(w + margin), 0, y),
			}, ti.medium)
			y = y + h + gap
		end
	end
end

local function dismiss(entry)
	if entry.dismissed then return end
	entry.dismissed = true

	for i, v in ipairs(active) do
		if v == entry then table.remove(active, i) break end
	end

	tw(entry.frame, {
		Position = UDim2.new(1, margin, 0, entry.frame.Position.Y.Offset),
	}, ti.medium)

	task.delay(0.28, function()
		if entry.frame and entry.frame.Parent then
			entry.frame:Destroy()
		end
		restack()
	end)
end

function notiflib.notify(options)
	local title    = options.title    or "Notification"
	local ntype    = options.type     or "info"
	local duration = options.duration or 4
	local onclick  = options.onclick  or nil
	local col      = typecolors[ntype] or typecolors.info
	local entry    = { dismissed = false }

	local lines
	if options.lines then
		lines = options.lines
	elseif options.message and options.message ~= "" then
		lines = { options.message }
	else
		lines = {}
	end

	local frame = makeinst("Frame", {
		Parent           = gui,
		Size             = UDim2.new(0, w, 0, 0),
		Position         = UDim2.new(1, margin, 0, margin),
		BackgroundColor3 = theme.bg,
		BorderSizePixel  = 0,
		AutomaticSize    = Enum.AutomaticSize.Y,
		ZIndex           = 10,
	})

	local stroke = makeinst("UIStroke", {
		Parent       = frame,
		Color        = col,
		Thickness    = 1,
		Transparency = 0,
	})

	local body = makeinst("Frame", {
		Parent               = frame,
		Size                 = UDim2.new(1, 0, 0, 0),
		AutomaticSize        = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		ZIndex               = 11,
	})
	makeinst("UIPadding", {
		Parent        = body,
		PaddingTop    = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 10),
		PaddingLeft   = UDim.new(0, 10),
		PaddingRight  = UDim.new(0, 10),
	})
	makeinst("UIListLayout", {
		Parent        = body,
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder     = Enum.SortOrder.LayoutOrder,
		Padding       = UDim.new(0, 3),
	})

	local titlerow = makeinst("Frame", {
		Parent               = body,
		Size                 = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		BorderSizePixel      = 0,
		LayoutOrder          = 1,
	})
	makeinst("TextLabel", {
		Parent               = titlerow,
		Size                 = UDim2.new(1, 0, 1, 0),
		Position             = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Text                 = title,
		TextColor3           = col,
		Font                 = fonts.semi,
		TextSize             = 12,
		TextXAlignment       = Enum.TextXAlignment.Left,
		TextTruncate         = Enum.TextTruncate.AtEnd,
		ZIndex               = 12,
	})

	for i, line in ipairs(lines) do
		makeinst("TextLabel", {
			Parent               = body,
			Size                 = UDim2.new(1, 0, 0, 0),
			AutomaticSize        = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text                 = line,
			TextColor3           = theme.textdim,
			Font                 = fonts.regular,
			TextSize             = 11,
			TextXAlignment       = Enum.TextXAlignment.Left,
			TextYAlignment       = Enum.TextYAlignment.Top,
			TextWrapped          = true,
			LayoutOrder          = i + 1,
			ZIndex               = 12,
		})
	end

	local btn = makeinst("TextButton", {
		Parent               = frame,
		Size                 = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text                 = "",
		AutoButtonColor      = false,
		ZIndex               = 20,
	})
	btn.MouseEnter:Connect(function()
		tw(frame, { BackgroundColor3 = theme.bgdark }, ti.fast)
	end)
	btn.MouseLeave:Connect(function()
		tw(frame, { BackgroundColor3 = theme.bg }, ti.fast)
	end)
	btn.MouseButton1Click:Connect(function()
		if onclick then onclick() end
		dismiss(entry)
	end)

	entry.frame = frame
	table.insert(active, 1, entry)

	task.defer(function()
		restack()
		services.tween:Create(stroke,
			TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
			{ Transparency = 1 }
		):Play()
	end)

	task.delay(duration, function() dismiss(entry) end)

	return entry
end

function notiflib.applytheme(newtheme)
	for k in pairs(theme) do
		if newtheme[k] then theme[k] = newtheme[k] end
	end
	typecolors.info = newtheme.accent or typecolors.info
end

return notiflib