-- Priority engine per balance channel

ks = ks or {}
ks.prio = ks.prio or {}

ks.prio.overrides = ks.prio.overrides or {}

function ks.prio.getPriority(affKey, channel)
  local o = ks.prio.overrides[affKey]
  if o and o[channel] then return o[channel] end
  local d = ks.dict and ks.dict.entries and ks.dict.entries[affKey]
  if not d or not d.channels or not d.channels[channel] then return 0 end
  return d.channels[channel].p or d.channels[channel].priority or 0
end

function ks.prio.set(affKey, channel, priority)
  ks.prio.overrides[affKey] = ks.prio.overrides[affKey] or {}
  ks.prio.overrides[affKey][channel] = priority
end

local CHANNEL_ORDER = { "smoke", "herb", "salve", "sip", "purgative", "focus", "moss", "misc", "physical" }

function ks.prio.bestForChannel(channel, affTable)
  local bestKey, bestP = nil, -1
  affTable = affTable or ks.affs
  for k, _ in pairs(affTable) do
    local ent = ks.dict and ks.dict.entries and ks.dict.entries[k]
    if ent and ent.kind == "affliction" then
      if not (ks.locks and ks.locks.canUseChannel and not ks.locks.canUseChannel(k, channel)) then
        local p = ks.prio.getPriority(k, channel)
        if p > bestP then
          bestP = p
          bestKey = k
        end
      end
    end
  end
  if bestP <= 0 then return nil end
  return bestKey, bestP
end

function ks.prio.exportList()
  local t = {}
  for k, chs in pairs(ks.prio.overrides) do
    t[k] = chs
  end
  return t
end

return ks.prio
