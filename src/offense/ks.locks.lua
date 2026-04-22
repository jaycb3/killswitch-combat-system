-- Lock detection (own afflictions + offence helpers)

ks = ks or {}
ks.locks = ks.locks or {}

function ks.locks.herbLocked()
  if not ks.affs then return false end
  if ks.affs.slickness then return true end
  if ks.affs.anorexia then return true end
  return false
end

function ks.locks.salveLocked()
  if not ks.affs then return false end
  return ks.affs.anorexia and true or false
end

--- Returns true if we may attempt `channel` to cure `affKey`
function ks.locks.canUseChannel(affKey, channel)
  local a = ks.affs or {}
  if channel == "herb" then
    if a.slickness and affKey ~= "slickness" and affKey ~= "paralysis" then
      return false
    end
    if a.anorexia then return false end
  end
  if channel == "salve" then
    if a.anorexia then
      local epidermal = { anorexia = true, itching = true, scalded = true, blindaff = true, deafaff = true, stuttering = true, slashedthroat = true }
      if epidermal[affKey] then return false end
    end
  end
  return true
end

function ks.locks.snapshot()
  return {
    herb = ks.locks.herbLocked(),
    salve = ks.locks.salveLocked(),
    hard = ks.locks.herbLocked() and ks.locks.salveLocked(),
  }
end

return ks.locks
