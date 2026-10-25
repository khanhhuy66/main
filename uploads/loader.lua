--[[
    TELEPORT WAYPOINT PRO - LOADER
]]

local scriptURL = "https://files.catbox.moe/wguwdw.lua"

local success, err = pcall(function()
    loadstring(game:HttpGet(scriptURL))()
end)

if not success then
    warn("[Teleport Waypoint Pro] Failed to load script:")
    warn(err)
end
