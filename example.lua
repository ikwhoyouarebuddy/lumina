local pg = game.Players.LocalPlayer:WaitForChild("PlayerGui")
for _, n in ipairs({ "luminamenu", "luminanotifs" }) do
    local old = pg:FindFirstChild(n)
    if old then old:Destroy() end
end

local menulib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ikwhoyouarebuddy/lumina/refs/heads/main/main.lua"))()
local notiflib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ikwhoyouarebuddy/lumina/refs/heads/main/notification.lua"))()
local thememanager = loadstring(game:HttpGet("https://raw.githubusercontent.com/ikwhoyouarebuddy/lumina/refs/heads/main/thememanager.lua"))()
local configmanager = loadstring(game:HttpGet("https://raw.githubusercontent.com/ikwhoyouarebuddy/lumina/refs/heads/main/configmanager.lua"))()

local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")

local currentfps = 0
rs.Heartbeat:Connect(function(dt)
    currentfps = math.round(1 / dt)
end)

local menu = menulib.new("Lumina", "showcase")

local watermark = menu:newwatermark("Lumina  |  {fps} fps  |  {plr}", { corner = "topright", poskey = "wm" })
watermark:setvars({ fps = "?", plr = lp.Name })

task.spawn(function()
    while task.wait(1) do
        watermark:setvars({ fps = tostring(currentfps) })
    end
end)

-- floating info window showing live state from multiple elements
local infowin = menu:newwindow("Live State", { width = 210, height = 180, x = 20, y = 60, poskey = "win_state" })
infowin:setlines({
    "toggle A:   {togA}",
    "toggle B:   {togB}",
    "slider val: {slid}",
    "dropdown:   {drop}",
    "textbox:    {tbox}",
    "",
    "rgb r={r} g={g} b={b}",
    "threshold:  {tlo} - {thi}",
})
infowin:setvars({ togA = "off", togB = "off", slid = "50", drop = "none", tbox = "", r = "0", g = "200", b = "190", tlo = "20", thi = "80" })

local tabone = menu:addtab("Toggles & Buttons")
local tabtwo = menu:addtab("Inputs & Pickers")
local tabthree = menu:addtab("Slider Lab")
local tabfour = menu:addtab("Settings")


-- TAB 1: toggles, buttons, labels, dividers
local sectog = menu:addsection(tabone, "Toggle", "left")
local secbtn = menu:addsection(tabone, "Button", "left")
local seclbl = menu:addsection(tabone, "Label & Divider", "middle")
local sectogadv = menu:addsection(tabone, "Toggle + Keybind", "middle")

menu:addlabel(sectog, "Toggle stores a boolean. Fires callback on every change.")
menu:adddivider(sectog, "Basic")

menu:addtoggle(sectog, "Toggle A", false, {
    callback = function(v)
        infowin:setvar("togA", v and "on" or "off")
        print("toggle A:", v)
    end,
})

menu:addtoggle(sectog, "Toggle B", true, {
    callback = function(v)
        infowin:setvar("togB", v and "on" or "off")
        print("toggle B:", v)
    end,
})

menu:adddivider(sectog, "Linked")

-- two toggles where enabling one disables the other
local togexa = nil
local togexb = nil
togexa = menu:addtoggle(sectog, "Mode X (exclusive)", false, {
    callback = function(v)
        if v and togexb then togexb.setstate(false, true) end
        print("mode x:", v)
    end,
})
togexb = menu:addtoggle(sectog, "Mode Y (exclusive)", false, {
    callback = function(v)
        if v and togexa then togexa.setstate(false, true) end
        print("mode y:", v)
    end,
})

menu:addlabel(secbtn, "Button fires a one-shot callback. No state stored.")
menu:adddivider(secbtn, "Basic")

menu:addbutton(secbtn, "Fire Info Toast", {
    callback = function() notiflib.notify({ title = "Info", message = "This is an info notification.", type = "info", duration = 4 }) end,
})
menu:addbutton(secbtn, "Fire Success Toast", {
    callback = function() notiflib.notify({ title = "Success", message = "Operation completed.", type = "success", duration = 4 }) end,
})
menu:addbutton(secbtn, "Fire Warning Toast", {
    callback = function() notiflib.notify({ title = "Warning", message = "Be careful with this.", type = "warning", duration = 4 }) end,
})
menu:addbutton(secbtn, "Fire Error Toast", {
    callback = function() notiflib.notify({ title = "Error", message = "Something failed.", type = "error", duration = 4 }) end,
})

menu:adddivider(secbtn, "Multi-line + Click")

menu:addbutton(secbtn, "Multi-line Notification", {
    callback = function()
        notiflib.notify({
            title = "Lumina",
            lines = {
                "Notifications support multiple lines.",
                "They also support an onclick callback.",
                "Click anywhere on this to dismiss.",
            },
            type = "info",
            duration = 8,
            onclick = function()
                notiflib.notify({ title = "Clicked", message = "You clicked the notification.", type = "success", duration = 2 })
            end,
        })
    end,
})

menu:addlabel(seclbl, "Label shows static or dynamic text. Divider segments a section.")

menu:adddivider(seclbl, "Labels")
menu:addlabel(seclbl, "This is a plain label.")
menu:addlabel(seclbl, "Labels wrap long text automatically and are read-only.")
menu:addlabel(seclbl, "Use them for hints, descriptions, or status readouts.")

menu:adddivider(seclbl, "Divider Styles")
menu:adddivider(seclbl, "")
menu:addlabel(seclbl, "A divider with no text is just a faint line (above).")
menu:adddivider(seclbl, "Named Divider")
menu:addlabel(seclbl, "A named divider adds a floating label in the center.")

menu:addlabel(sectogadv, "Toggles can bind a key. The bound key fires the same callback.")
menu:adddivider(sectogadv, "Keybind Toggle")

menu:addtoggle(sectogadv, "Keybound Toggle", false, {
    keybind = true,
    callback = function(v)
        print("keybound toggle:", v)
    end,
    keybindcallback = function(v)
        print("fired via keybind:", v)
    end,
})

menu:addlabel(sectogadv, "Click the key chip next to the toggle to assign a key. Press that key at any time to toggle.")
menu:adddivider(sectogadv, "setstate API")
menu:addlabel(sectogadv, "Toggles expose setstate(value, firecallback) to set state from code.")

local exttog = menu:addtoggle(sectogadv, "Externally Controlled", false, {
    callback = function(v) print("externally controlled:", v) end,
})

menu:addbutton(sectogadv, "Force ON", { callback = function() exttog.setstate(true, true) end })
menu:addbutton(sectogadv, "Force OFF", { callback = function() exttog.setstate(false, true) end })


-- TAB 2: textbox, dropdown, multiselect, searchbox, colorpicker
local sectb = menu:addsection(tabtwo, "Textbox", "left")
local secdd = menu:addsection(tabtwo, "Dropdown", "left")
local seccp = menu:addsection(tabtwo, "Color Picker", "middle")
local secms = menu:addsection(tabtwo, "Multi-select & Searchbox", "middle")

menu:addlabel(sectb, "Textbox captures free-form text. Callback fires on focus-lost or on enter key. Pass live=true for every keystroke.")
menu:adddivider(sectb, "On Enter")

menu:addtextbox(sectb, "On-enter Input", {
    placeholder = "type something, press enter",
    callback = function(text, enter)
        if enter then
            infowin:setvar("tbox", text ~= "" and text or "(empty)")
            print("submitted:", text)
        end
    end,
})

menu:adddivider(sectb, "Live")

menu:addtextbox(sectb, "Live Input", {
    placeholder = "updates on every keystroke",
    live = true,
    callback = function(text)
        print("live:", text)
    end,
})

menu:adddivider(sectb, "Script Executor")

menu:addtextbox(sectb, "Execute Lua", {
    placeholder = "print('hi')",
    callback = function(text, enter)
        if not enter or text == "" then return end
        local fn, err = loadstring(text)
        if not fn then print("syntax error:", err) return end
        local ok, runerr = pcall(fn)
        if ok then
            notiflib.notify({ title = "Execute", message = "Ran ok.", type = "success", duration = 2 })
        else
            notiflib.notify({ title = "Execute", message = tostring(runerr):sub(1, 80), type = "error", duration = 5 })
        end
    end,
})

menu:addlabel(secdd, "Dropdown lets the user pick one option from a list. Callback fires on selection.")
menu:adddivider(secdd, "Basic")

menu:adddropdown(secdd, "Pick One", {
    choices = { "Option A", "Option B", "Option C", "Option D", "Option E" },
    default = "Option A",
    callback = function(v)
        infowin:setvar("drop", v)
        print("dropdown:", v)
    end,
})

menu:adddivider(secdd, "Dynamic Choices")
menu:addlabel(secdd, "choices table can be swapped at runtime by setting el.choices.")

local dyndd = menu:adddropdown(secdd, "Dynamic Dropdown", {
    choices = { "Alpha", "Beta", "Gamma" },
    default = "Alpha",
    callback = function(v) print("dynamic:", v) end,
})

menu:addbutton(secdd, "Swap to Set 2", {
    callback = function()
        dyndd.choices = { "Delta", "Epsilon", "Zeta", "Eta" }
        print("choices swapped")
    end,
})

menu:addlabel(seccp, "Color picker gives full HSV control plus a hex input box. Callback fires on any change.")
menu:adddivider(seccp, "Basic")

menu:addcolorpicker(seccp, "Pick a Color", Color3.fromRGB(0, 200, 190), function(c, r, g, b)
    print(string.format("color: #%02X%02X%02X  rgb(%d,%d,%d)", r, g, b, r, g, b))
end)

menu:adddivider(seccp, "Synced Pair")
menu:addlabel(seccp, "Two pickers where the second mirrors the first using setcolor.")

local mirrormaster = nil
local mirrorslave = nil

mirrormaster = menu:addcolorpicker(seccp, "Master Color", Color3.fromRGB(255, 80, 80), function(c)
    if mirrorslave and mirrorslave.setcolor then
        mirrorslave.setcolor(c)
    end
    print("master color:", c)
end)

mirrorslave = menu:addcolorpicker(seccp, "Mirror (read slave)", Color3.fromRGB(255, 80, 80), function(c)
    print("slave color:", c)
end)

menu:addlabel(secms, "Multi-select and searchbox both produce a list of selected values. They differ only in that searchbox filters as you type.")
menu:adddivider(secms, "Multi-select")

menu:addmultiselect(secms, "Pick Multiple", {
    choices = { "Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape", "Honeydew" },
    callback = function(selected)
        print("selected:", table.concat(selected, ", "))
    end,
})

menu:adddivider(secms, "Searchbox")
menu:addlabel(secms, "Searchbox sources choices from a function so the list can change between opens.")

local searchpool = { "Alice", "Bob", "Carol", "Dave", "Eve", "Frank", "Grace", "Heidi", "Ivan", "Judy" }

menu:addsearchbox(secms, "Search Names", {
    choices = function() return searchpool end,
    placeholder = "type to filter...",
    callback = function(selected)
        print("search selected:", table.concat(selected, ", "))
    end,
})

menu:addbutton(secms, "Add Random Name", {
    callback = function()
        local names = { "Mallory", "Oscar", "Peggy", "Rupert", "Sybil", "Trent", "Uma", "Victor" }
        local name = names[math.random(1, #names)]
        table.insert(searchpool, name)
        print("added to pool:", name)
    end,
})


-- TAB 3: slider lab (so tuff name) niche and clever uses of the slider element
local secslid1 = menu:addsection(tabthree, "What sliders are", "left")
local secslid2 = menu:addsection(tabthree, "RGB Channel Editor", "left")
local secslid3 = menu:addsection(tabthree, "Threshold Pair", "left")
local secslid4 = menu:addsection(tabthree, "Countdown Timer", "middle")
local secslid5 = menu:addsection(tabthree, "Step Precision Demo", "middle")
local secslid6 = menu:addsection(tabthree, "Batch Rate Limiter", "middle")

menu:addlabel(secslid1, "Slider stores a number between min and max, snapping to step. It exposes value, fill, valuelabel, track, and row.")
menu:addlabel(secslid1, "The fill frame's Size.X.Scale reflects the normalized value so you can drive other visuals from a slider without extra logic.")
menu:adddivider(secslid1, "Basic")

menu:addslider(secslid1, "Basic Slider", {
    min = 0, max = 100, step = 1, default = 50,
    callback = function(v)
        infowin:setvar("slid", tostring(v))
        print("slider:", v)
    end,
})

-- RGB channel editor: three sliders produce a color and print the combined hex
local rval, gval, bval = 0, 200, 190

local function printrgb()
    local hex = string.format("#%02X%02X%02X", rval, gval, bval)
    infowin:setvars({ r = tostring(rval), g = tostring(gval), b = tostring(bval) })
    print("rgb color:", hex)
end

menu:addlabel(secslid2, "Three sliders independently control R, G, B channels. Their values combine into a Color3 on every change.")
menu:adddivider(secslid2, "Channels")

menu:addslider(secslid2, "Red",   { min = 0, max = 255, step = 1, default = 0,   callback = function(v) rval = v; printrgb() end })
menu:addslider(secslid2, "Green", { min = 0, max = 255, step = 1, default = 200, callback = function(v) gval = v; printrgb() end })
menu:addslider(secslid2, "Blue",  { min = 0, max = 255, step = 1, default = 190, callback = function(v) bval = v; printrgb() end })

menu:addbutton(secslid2, "Print Current Hex", {
    callback = function()
        local hex = string.format("#%02X%02X%02X", rval, gval, bval)
        notiflib.notify({ title = "RGB", message = hex, type = "info", duration = 3 })
    end,
})

-- threshold pair: low can never exceed high, high can never go below low
local threshlo = 20
local threshhi = 80
local threshloref = nil
local threshhiref = nil

menu:addlabel(secslid3, "Two sliders clamped against each other. The low handle can never exceed the high one and vice versa, enforced in callbacks.")
menu:adddivider(secslid3, "Min / Max")

threshloref = menu:addslider(secslid3, "Low Threshold", {
    min = 0, max = 100, step = 1, default = 20,
    callback = function(v)
        if v > threshhi then
            threshloref.value = threshhi
            threshloref.valuelabel.Text = tostring(threshhi)
            threshloref.fill.Size = UDim2.new((threshhi - 0) / 100, 0, 1, 0)
            return
        end
        threshlo = v
        infowin:setvar("tlo", tostring(threshlo))
        print("threshold range:", threshlo, "-", threshhi)
    end,
})

threshhiref = menu:addslider(secslid3, "High Threshold", {
    min = 0, max = 100, step = 1, default = 80,
    callback = function(v)
        if v < threshlo then
            threshhiref.value = threshlo
            threshhiref.valuelabel.Text = tostring(threshlo)
            threshhiref.fill.Size = UDim2.new((threshlo - 0) / 100, 0, 1, 0)
            return
        end
        threshhi = v
        infowin:setvar("thi", tostring(threshhi))
        print("threshold range:", threshlo, "-", threshhi)
    end,
})

-- countdown timer: slider sets the duration, button starts it, a floating window shows the tick
local timerwin = menu:newwindow("Countdown", { width = 150, height = 80, x = 240, y = 60 })
timerwin:setlines({ "Duration: {dur}s", "Remaining: {rem}s", "{status}" })
timerwin:setvars({ dur = "10", rem = "--", status = "idle" })

local timerduration = 10
local timerrunning = false

menu:addlabel(secslid4, "Slider sets a duration in seconds. A button starts the countdown. The floating window updates every tick until it reaches zero.")
menu:adddivider(secslid4, "Timer")

menu:addslider(secslid4, "Duration (s)", {
    min = 1, max = 60, step = 1, default = 10,
    callback = function(v)
        timerduration = v
        timerwin:setvar("dur", tostring(v))
    end,
})

menu:addbutton(secslid4, "Start Countdown", {
    callback = function()
        if timerrunning then print("already running") return end
        timerrunning = true
        local rem = timerduration
        timerwin:setvars({ rem = tostring(rem), status = "running" })
        task.spawn(function()
            while rem > 0 and timerrunning do
                task.wait(1)
                rem = rem - 1
                timerwin:setvar("rem", tostring(rem))
            end
            timerrunning = false
            timerwin:setvar("status", rem == 0 and "done!" or "stopped")
            if rem == 0 then
                notiflib.notify({ title = "Timer", message = "Countdown finished.", type = "success", duration = 3 })
            end
        end)
    end,
})

menu:addbutton(secslid4, "Stop", {
    callback = function()
        timerrunning = false
        timerwin:setvars({ rem = "--", status = "stopped" })
        print("timer stopped")
    end,
})

-- step precision demo: same range, different step values
menu:addlabel(secslid5, "Same min/max (0-1) but different step sizes. Shows how step affects precision and the number of discrete positions.")
menu:adddivider(secslid5, "Steps")

menu:addslider(secslid5, "Step 0.01 (fine)", { min = 0, max = 1, step = 0.01, default = 0.5, callback = function(v) print("fine:", v) end })
menu:addslider(secslid5, "Step 0.1  (mid)",  { min = 0, max = 1, step = 0.1,  default = 0.5, callback = function(v) print("mid:", v) end })
menu:addslider(secslid5, "Step 0.25 (coarse)",{ min = 0, max = 1, step = 0.25, default = 0.5, callback = function(v) print("coarse:", v) end })
menu:addslider(secslid5, "Step 1    (int)",  { min = 0, max = 10, step = 1,   default = 5,   callback = function(v) print("int:", v) end })

-- batch rate limiter: slider controls max events per second, a button fires them and the limiter enforces the cap
local ratelimit = 5
local ratebucket = 0
local ratelasttick = tick()

local function rateallowed()
    local now = tick()
    local elapsed = now - ratelasttick
    ratelasttick = now
    ratebucket = math.min(ratelimit, ratebucket + elapsed * ratelimit)
    if ratebucket >= 1 then
        ratebucket = ratebucket - 1
        return true
    end
    return false
end

menu:addlabel(secslid6, "Slider controls a token-bucket rate limit. Firing the button rapidly will be gated to the configured max events per second.")
menu:adddivider(secslid6, "Rate Limit")

menu:addslider(secslid6, "Max per Second", {
    min = 1, max = 20, step = 1, default = 5,
    callback = function(v)
        ratelimit = v
        print("rate limit set:", v, "per second")
    end,
})

menu:addbutton(secslid6, "Fire Event (rate-gated)", {
    callback = function()
        if rateallowed() then
            print("event fired at", tick())
            notiflib.notify({ title = "Event", message = "Fired (allowed by rate limiter)", type = "success", duration = 1 })
        else
            print("event blocked by rate limiter")
            notiflib.notify({ title = "Rate Limited", message = "Too fast. Blocked.", type = "warning", duration = 1 })
        end
    end,
})

menu:addbutton(secslid6, "Spam x5 (test limiter)", {
    callback = function()
        for _ = 1, 5 do
            if rateallowed() then
                print("allowed at", tick())
            else
                print("blocked at", tick())
            end
        end
    end,
})


-- TAB 4: settings
thememanager.inject(menu, tabfour, function(t)
    notiflib.applytheme({ accent = t.accent })
    print("theme changed")
end)

configmanager.inject(menu, tabfour, {
    thememanager = thememanager,
    notiflib = notiflib,
    savetheme = true,
})


task.defer(function()
    notiflib.notify({
        title = "Lumina showcase",
        lines = { "Press RIGHT ALT to toggle.", "Tab 3 has niche slider examples." },
        type = "info",
        duration = 5,
    })
end)

-- hi 
