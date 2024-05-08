local wezterm = require('wezterm')
local platform = require('utils.platform')()
local act = wezterm.action

local mod = {}

if platform.is_mac then
   mod.ALT = 'SUPER'
   mod.ALT_CTRL = 'SUPER|CTRL'
   mod.CTRL = 'CTRL'
elseif platform.is_win or platform.is_linux then
   mod.ALT = 'ALT' -- to not conflict with Windows key shortcuts
   mod.ALT_CTRL = 'ALT|CTRL'
   mod.ALT_SHIFT = 'ALT|SHIFT'
   mod.CTRL = 'CTRL'
   mod.SHIFT = 'SHIFT'
   mod.CTRL_SHIFT = 'CTRL|SHIFT'
end

-- stylua: ignore
local keys = {
   -- misc/useful --
   -- { key = 'F2', mods = 'NONE', action = act.ShowLauncher },
   { key = 'm', mods = mod.ALT, action = act.ActivateCommandPalette },

   -- toggle fullscreen
   { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },
   { key = 'f',   mods = mod.ALT_SHIFT, action = act.Search({ CaseInSensitiveString = '' }) },

   -- copy/paste --
   { key = 'Insert', mods = mod.CTRL,  action = act.CopyTo('Clipboard') },
   { key = 'Insert', mods = mod.SHIFT,  action = act.PasteFrom('Clipboard') },

   -- tabs --
   -- tabs: spawn+close
   { key = 't', mods = mod.ALT_SHIFT,     action = act.SpawnTab('DefaultDomain') },
   { key = 'F4', mods = mod.CTRL, action = act.CloseCurrentTab({ confirm = true }) },

   -- tabs: navigation
   { key = 'Tab', mods = mod.CTRL,     action = act.ActivateTabRelative(1) },
   { key = 'Tab', mods = mod.CTRL_SHIFT,     action = act.ActivateTabRelative(-1) },

   -- scroll ---
   -- scroll: scrollback only
   { key = 'b', mods = mod.ALT_SHIFT, action = act.ClearScrollback 'ScrollbackOnly' },

   -- panes --
   -- panes: split panes
   {
      key = [[\]],
      mods = mod.ALT_CTRL,
      action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
   },
   {
      key = [[\]],
      mods = mod.ALT,
      action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
   },
}

return {
   disable_default_key_bindings = true,
   keys = keys,
}
