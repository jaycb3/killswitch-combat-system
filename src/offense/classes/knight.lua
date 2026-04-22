-- Knight (Runewarden / Paladin / Infernal): limb prep → finishers

local M = {}

function M.start(name)
  if ks.limbs and ks.limbs.ensure then ks.limbs.ensure(name or "target") end
end

function M.stop() end

function M.tick()
  local t = ks.target and ks.target.name
  if not t then return end
  local order = { { "leftleg", "left leg" }, { "rightleg", "right leg" }, { "leftarm", "left arm" }, { "rightarm", "right arm" }, { "head", "head" } }
  for _, pair in ipairs(order) do
    local key, label = pair[1], pair[2]
    if ks.limbs and not ks.limbs.isPrepped(t, key) then
      send(string.format("slash %s %s", t, label))
      return
    end
  end
  send("behead " .. t)
end

for _, c in ipairs({ "runewarden", "paladin", "infernal", "knight" }) do
  ks.offense.registerClass(c, M)
end
return M
