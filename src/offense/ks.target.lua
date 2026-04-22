-- Target state + GMCP sync

ks = ks or {}
ks.target = ks.target or {
  name = nil,
  id = nil,
  hpperc = 100,
  desc = "",
  affs = {},
  limbs = {},
}

function ks.target.set(name)
  ks.target.name = name
  if sendGMCP and name then
    -- Tab target by name often uses id; user may set id via game
    sendGMCP([[IRE.Target.Set "]] .. tostring(name) .. [["]])
  end
end

function ks.target.clear()
  ks.target.name = nil
  ks.target.id = nil
  ks.target.hpperc = 100
  if sendGMCP then sendGMCP([[IRE.Target.Set ""]]) end
end

return ks.target
