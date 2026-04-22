-- Simple HUD: echo status line (replace with UserWindow gauges as desired)

ks = ks or {}
ks.ui = ks.ui or {}

function ks.ui.refresh()
  local s = ks.stats or {}
  local line = string.format(
    "HP:%s%% MP:%s%% | bal:%s eq:%s | affs:%s defs:%s | tar:%s (%s%%)",
    tostring(s.hpperc or 0),
    tostring(s.mpperc or 0),
    tostring(ks.bals and ks.bals.balance),
    tostring(ks.bals and ks.bals.equilibrium),
    tostring(ks.ui.countKeys(ks.affs)),
    tostring(ks.ui.countKeys(ks.defs)),
    tostring(ks.target and ks.target.name or "-"),
    tostring(ks.target and ks.target.hpperc or "-")
  )
  echo("\n" .. line .. "\n")
end

function ks.ui.countKeys(t)
  if not t then return 0 end
  local n = 0
  for _ in pairs(t) do n = n + 1 end
  return n
end

return ks.ui
