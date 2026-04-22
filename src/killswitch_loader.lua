--[[
  Killswitch loader — copy repo to: getMudletHomeDir() .. "/killswitch/"
  In Mudlet: lua killswitch_loader via script, or paste this file.
]]

local KS_ROOT = getMudletHomeDir() .. "/killswitch/"

local function load(rel)
  local path = KS_ROOT .. "src/" .. rel
  local c, e = loadfile(path)
  if not c then error("Killswitch load failed: " .. tostring(e) .. " path=" .. path) end
  return c()
end

load("core/ks.core.lua")
ks.setBasePath(KS_ROOT)

load("core/ks.actions.lua")
load("core/ks.vitals.lua")
load("curing/ks.dict.lua")
load("offense/ks.locks.lua")
load("curing/ks.prio.lua")
load("curing/ks.curing.lua")
load("curing/ks.keepup.lua")
load("offense/ks.target.lua")
load("offense/ks.limbcounter.lua")
load("offense/ks.offense.lua")
load("offense/classes/serpent.lua")
load("offense/classes/knight.lua")
load("offense/classes/monk.lua")
load("offense/classes/magi.lua")
load("offense/classes/occultist.lua")
load("offense/classes/stubs.lua")
load("ui/ks.ui.lua")
load("ui/ks.aliases.lua")
load("core/ks.gmcp.lua")

if ks.gmcp and ks.gmcp.register then ks.gmcp.register() end
if ks.gmcp and ks.gmcp.enableModules then ks.gmcp.enableModules() end

echo("Killswitch loaded.\n")

return ks
