# lumina
a roblox ui library i made because i wasn't happy with what was out there. it's small, it looks good, and it doesn't get in your way.

---

## what's in it

four files. that's it.

- **main.lua** - the whole ui. menus, tabs, sections, every element type.
- **notification.lua** - toast notifications. works on its own, no menu needed.
- **thememanager.lua** - a ready-made theme editor you drop into any settings tab.
- **configmanager.lua** - config profiles. save, load, delete, autoload on join. credits to linoria for the idea.

if you're new, read [`example.lua`](https://github.com/ikwhoyouarebuddy/lumina/blob/main/example.lua) first. it covers every element with actual context.

---

## loading it

```lua
local menulib       = loadstring(game:HttpGet("https://raw.githubusercontent.com/ikwhoyouarebuddy/lumina/refs/heads/main/main.lua"))()
local notiflib      = loadstring(game:HttpGet("https://raw.githubusercontent.com/ikwhoyouarebuddy/lumina/refs/heads/main/notification.lua"))()
local thememanager  = loadstring(game:HttpGet("https://raw.githubusercontent.com/ikwhoyouarebuddy/lumina/refs/heads/main/thememanager.lua"))()
local configmanager = loadstring(game:HttpGet("https://raw.githubusercontent.com/ikwhoyouarebuddy/lumina/refs/heads/main/configmanager.lua"))()
```

---

## the basics

```lua
local menu = menulib.new("My Script", "v1.0")
local tab  = menu:addtab("Main")
local sec  = menu:addsection(tab, "General", "left")

menu:addtoggle(sec, "Do Thing", false, {
    callback = function(v)
        print(v)
    end,
})
```

right alt opens and closes the menu. everything else is in the [example](https://github.com/ikwhoyouarebuddy/lumina/blob/main/example.lua).

---

## elements

toggle · slider · button · colorpicker · dropdown · multiselect · searchbox · textbox · label · divider

and two extras - `newwindow` for a floating info panel, `newwatermark` for a corner hud.

---

## contact

made by `99.lua` - come say hi at [discord.gg/flowcc](https://discord.gg/flowcc)
