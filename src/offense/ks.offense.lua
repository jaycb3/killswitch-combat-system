-- Offence controller + class registry

ks = ks or {}
ks.offense = ks.offense or {}
ks.offense.registry = ks.offense.registry or {}
ks.offense.active = false
ks.offense.paused = false
ks.offense.currentClass = nil

function ks.offense.registerClass(className, mod)
  ks.offense.registry[className:lower()] = mod
end

function ks.offense.onClassDetected(className)
  if not className then return end
  ks.offense.currentClass = className:lower()
end

function ks.offense.module()
  local c = ks.offense.currentClass or (ks.me and ks.me.class and ks.me.class:lower())
  if not c then return nil end
  return ks.offense.registry[c]
end

function ks.offense.start(targetName)
  ks.offense.active = true
  if ks.target and ks.target.set then ks.target.set(targetName) end
  local m = ks.offense.module()
  if m and m.start then m.start(targetName) end
end

function ks.offense.stop()
  ks.offense.active = false
  local m = ks.offense.module()
  if m and m.stop then m.stop() end
  if ks.target and ks.target.clear then ks.target.clear() end
end

function ks.offense.attack()
  if not ks.offense.active or ks.offense.paused then return end
  if ks.bals and (not ks.bals.balance or not ks.bals.equilibrium) then return end
  local m = ks.offense.module()
  if m and m.tick then m.tick() end
end

ks.event.on("vitals_updated", function()
  if ks.offense.active and ks.bals and ks.bals.balance and ks.bals.equilibrium then
    ks.offense.attack()
  end
end)

return ks.offense

