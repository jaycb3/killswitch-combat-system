-- Parse gmcp.Char.Vitals into ks.stats; fire vitals_updated

ks = ks or {}

local function num(s)
  local n = tonumber(s)
  return n or 0
end

local function perc(cur, maxv)
  if not maxv or maxv <= 0 then return 0 end
  return math.floor((cur / maxv) * 100 + 0.5)
end

ks.vitals = ks.vitals or {}

function ks.vitals.parse(g)
  if not g or type(g) ~= "table" then return end
  local s = ks.stats
  s.hp = num(g.hp)
  s.maxhp = num(g.maxhp)
  s.mp = num(g.mp)
  s.maxmp = num(g.maxmp)
  s.ep = num(g.ep)
  s.maxep = num(g.maxep)
  s.wp = num(g.wp)
  s.maxwp = num(g.maxwp)
  s.nl = num(g.nl)
  s.hpperc = perc(s.hp, s.maxhp)
  s.mpperc = perc(s.mp, s.maxmp)
  s.epperc = perc(s.ep, s.maxep)
  s.wpperc = perc(s.wp, s.maxwp)
  -- bal/eq as strings "1" / "0" in IRE GMCP
  s.bal = g.bal
  s.eq = g.eq
  if ks.bals then
    ks.bals.balance = (g.bal == "1" or g.bal == 1)
    ks.bals.equilibrium = (g.eq == "1" or g.eq == 1)
  end
  s.string = g.string or ""
  s.charstats = g.charstats
  s.bleed = nil
  s.rage = nil
  if type(g.charstats) == "table" then
    for _, line in ipairs(g.charstats) do
      if type(line) == "string" then
        local k, v = line:match("^([^:]+):%s*(.+)$")
        if k and v then
          k = k:lower():gsub("%s+", "")
          if k:find("bleed") then s.bleed = v end
          if k:find("rage") then s.rage = v end
        end
      end
    end
  end
  ks.event.fire("vitals_updated", s)
end

return ks.vitals
