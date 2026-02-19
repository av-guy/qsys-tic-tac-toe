---@diagnostic disable: undefined-global, cast-local-type

--[[ #include "info.lua" ]]

function GetColor(props)
  return { 102, 102, 102 }
end

function GetPrettyName(props)
  return "Tic-Tac-Toe\nVersion " .. PluginInfo.Version
end

--[[ #include "properties.lua" ]]

--[[ #include "rectify_properties.lua" ]]

--[[ #include "controls.lua" ]]

--[[ #include "layout.lua" ]]

--[[ #include "runtime.lua"]]
