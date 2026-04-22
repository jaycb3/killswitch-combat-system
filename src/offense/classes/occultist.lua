-- Occultist: tarot + entity pressure (placeholders)

local M = {}

function M.start() end
function M.stop() end

function M.tick()
  local t = ks.target and ks.target.name
  if not t then return end
  send("fling fool tarot at " .. t)
end

ks.offense.registerClass("occultist", M)
return M
