-- Main curing decision loop

ks = ks or {}
ks.curing = ks.curing or {}

function ks.curing.decide(reason)
  if ks.conf.paused then return end
  if not ks.affs then return end
  -- Voyria emergency
  if ks.affs.voyria and ks.bals and ks.bals.purgative then
    ks.curing.tryCure("voyria", "purgative")
    return
  end
  if ks.affs.aeon and ks.bals and ks.bals.smoke then
    ks.curing.tryCure("aeon", "smoke")
    return
  end
  if ks.locks and ks.locks.herbLocked and ks.locks.herbLocked() then
    -- try smoke/focus/salve first
  end
  for _, ch in ipairs({ "smoke", "herb", "salve", "sip", "purgative", "focus", "moss", "misc" }) do
    if ks.bals and ks.bals[ch] and not (ks.actions and ks.actions.using(ch)) then
      local key = ks.prio and ks.prio.bestForChannel(ch, ks.affs)
      if key then
        if ks.curing.tryCure(key, ch) then return end
      end
    end
  end
  ks.curing.maybeSipVitals()
end

function ks.curing.maybeSipVitals()
  local s = ks.stats or {}
  local hp = s.hpperc or 0
  local mp = s.mpperc or 0
  if hp < (ks.conf.siphealth or 80) and ks.bals and ks.bals.sip and not ks.actions.using("sip") then
    ks.actions.doAction({
      name = "sip_health",
      channel = "sip",
      send = "sip health",
    })
    return true
  end
  if mp < (ks.conf.sipmana or 70) and ks.bals and ks.bals.sip and not ks.actions.using("sip") then
    ks.actions.doAction({
      name = "sip_mana",
      channel = "sip",
      send = "sip mana",
    })
    return true
  end
  if hp < (ks.conf.mosshealth or 60) and ks.bals and ks.bals.moss and not ks.actions.using("moss") then
    ks.actions.doAction({
      name = "moss",
      channel = "moss",
      send = "eat moss",
    })
    return true
  end
  return false
end

function ks.curing.tryCure(affKey, channel)
  local entry = ks.dict.entries[affKey]
  if not entry or not entry.channels or not entry.channels[channel] then return false end
  local spec = entry.channels[channel]
  local cmd
  if channel == "herb" and spec.eat then
    cmd = string.format("outr %s\neat %s", spec.eat, spec.eat)
  elseif channel == "smoke" and spec.pipe then
    cmd = string.format("smoke %s", spec.pipe)
  elseif channel == "salve" and spec.apply then
    local part = spec.part or "body"
    cmd = string.format("apply %s to %s", spec.apply, part)
  elseif channel == "purgative" and spec.sip then
    cmd = string.format("sip %s", spec.sip)
  elseif channel == "focus" then
    cmd = "focus"
  elseif channel == "misc" and spec.kind == "clot" then
    cmd = "clot"
  elseif channel == "misc" and spec.kind == "writhe" then
    cmd = "writhe"
  else
    return false
  end
  if not cmd then return false end
  return ks.actions.doAction({
    name = affKey .. "_" .. channel,
    channel = channel,
    send = cmd,
    sync = true,
  })
end

return ks.curing
