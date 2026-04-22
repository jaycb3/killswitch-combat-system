-- Magi: crystal limb prep → devastate

local M = {}

function M.start() end
function M.stop() end

function M.tick()
  local t = ks.target and ks.target.name
  if not t then return end
  send("cast lightning at " .. t)
end

ks.offense.registerClass("magi", M)
return M
