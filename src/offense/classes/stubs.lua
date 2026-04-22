-- Stub offence modules (customize per class)

local function makeStub(cmd)
  local M = {}
  function M.start() end
  function M.stop() end
  function M.tick()
    local t = ks.target and ks.target.name
    if not t then return end
    send(cmd:gsub("@tar", t))
  end
  return M
end

local stubs = {
  bard = "jab @tar",
  shaman = "curse @tar",
  apostate = "warp @tar",
  priest = "smite @tar",
  sentinel = "dhurl @tar",
  sylvan = "grove @tar",
  druid = "gust @tar",
  psion = "weave @tar",
  jester = "bop @tar",
  depthwalker = "shadowstrike @tar",
  depthswalker = "shadowstrike @tar",
  blademaster = "strike @tar",
  alchemist = "humour @tar",
  pariah = "blight @tar",
  unnamable = "strike @tar",
}

for class, cmd in pairs(stubs) do
  ks.offense.registerClass(class, makeStub(cmd))
end

return true
