-- Defence keepup: re-raise stripped defences

ks = ks or {}
ks.keepup = ks.keepup or {}

ks.keepup.enabled = ks.keepup.enabled or {}
ks.keepup.lastDefs = ks.keepup.lastDefs or {}

function ks.keepup.set(key, on)
  ks.keepup.enabled[key] = on and true or nil
end

function ks.keepup.onDefsRefresh()
  ks.keepup.lastDefs = {}
  for k, _ in pairs(ks.defs or {}) do ks.keepup.lastDefs[k] = true end
end

function ks.keepup.onDefenceRemove(key)
  if not ks.keepup.enabled[key] then return end
  ks.event.fire("keepup_strip", key)
  -- Actual raise commands are class-specific; user binds or class module fills
  if ks.conf.debug then
    echo("Killswitch keepup: defence stripped: " .. tostring(key) .. "\n")
  end
end

function ks.keepup.onDefenceAdd(key)
  -- track
end

return ks.keepup
