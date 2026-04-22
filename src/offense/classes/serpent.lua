-- Serpent: venom sequencing + hypnosis kill path (customize commands)

local M = {}
local stack = { "curare", "kalmia", "xentio", "epteth", "camus", "oculus", "slike" }
local si = 1

function M.start(targetName)
  si = 1
end

function M.stop() end

function M.tick()
  local t = ks.target and ks.target.name
  if not t then return end
  local v = stack[si] or "curare"
  send("envenom whip with " .. v)
  send("doublestab " .. t)
  si = (si % #stack) + 1
  -- Hypnosis finisher is highly situational — enable manually or extend logic
  -- if ks.target.hpperc and ks.target.hpperc < 30 then send("hypnotise " .. t) end
end

ks.offense.registerClass("serpent", M)
return M
