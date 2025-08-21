-- Pull in the wezterm API
local wezterm = require("wezterm")

local local_settings = require("local")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.font = wezterm.font("FiraCode Nerd Font")

config.color_scheme = "Tokyo Night Moon"
config.font_size = 18

local_settings.apply_to_config(config)

return config
