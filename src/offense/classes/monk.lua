-- Monk: Tekura limb pressure + AXK finisher hook

local M = {}
local conf = { armdamage = 3, legdamage = 4, breakat = 7 }

function M.start(name)
  ks.limbs = ks.limbs or {}
  ks.limbs.breakAt = conf.breakat
end

function M.stop() end

function M.tick()
  local t = ks.target and ks.target.name
  if not t then return end
  send(string.format("combo %s sdk ucp ucp", t))
end

ks.offense.registerClass("monk", M)
return M
