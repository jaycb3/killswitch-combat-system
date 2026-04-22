-- Universal limb damage tracker (per target)

ks = ks or {}
ks.limbs = ks.limbs or {}

ks.limbs.list = ks.limbs.list or {}
ks.limbs.breakAt = ks.limbs.breakAt or 10
ks.limbs.prepOffset = ks.limbs.prepOffset or 2

local limbKeys = { "head", "torso", "rightarm", "leftarm", "rightleg", "leftleg" }

function ks.limbs.ensure(who)
  who = who or "target"
  ks.limbs.list[who] = ks.limbs.list[who] or {}
  for _, L in ipairs(limbKeys) do
    if ks.limbs.list[who][L] == nil then ks.limbs.list[who][L] = 0 end
  end
  return ks.limbs.list[who]
end

function ks.limbs.hit(who, limb, dmg)
  dmg = dmg or 1
  local t = ks.limbs.ensure(who)
  limb = (limb or ""):gsub("%s+", ""):lower()
  if not t[limb] then return end
  t[limb] = t[limb] + dmg
  raiseEvent("ks limb hit", who, limb, t[limb])
  if t[limb] >= ks.limbs.breakAt then
    t[limb] = 0
    raiseEvent("ks limb broke", who, limb)
  end
end

function ks.limbs.reset(who, limb)
  if who == "all" then ks.limbs.list = {} return end
  local t = ks.limbs.list[who]
  if not t then return end
  if limb then t[limb] = 0 else
    for _, L in ipairs(limbKeys) do t[L] = 0 end
  end
end

function ks.limbs.isPrepped(who, limb)
  local t = ks.limbs.list[who]
  if not t or not limb then return false end
  local th = ks.limbs.breakAt - (ks.limbs.prepOffset or 2)
  return (t[limb] or 0) >= th
end

return ks.limbs
