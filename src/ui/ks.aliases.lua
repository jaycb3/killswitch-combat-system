-- Alias helpers (call from Mudlet aliases: `lua ks.aliases.atk()`)

ks = ks or {}
ks.aliases = ks.aliases or {}

function ks.aliases.atk(rest)
  local name = rest and rest:match("%S+")
  if name and ks.offense then ks.offense.start(name) end
end

function ks.aliases.unatk()
  if ks.offense then ks.offense.stop() end
end

function ks.aliases.pp()
  ks.offense.paused = not ks.offense.paused
  ks.conf.paused = ks.offense.paused
  echo("Offence/curing paused: " .. tostring(ks.offense.paused) .. "\n")
end

function ks.aliases.showAffs()
  if not ks.affs then return end
  for k, _ in pairs(ks.affs) do echo(k .. " ") end
  echo("\n")
end

function ks.aliases.showDefs()
  if not ks.defs then return end
  for k, _ in pairs(ks.defs) do echo(k .. " ") end
  echo("\n")
end

function ks.aliases.prio(rest)
  local a, ch, p = rest:match("^(%S+)%s+(%S+)%s+(%d+)")
  if a and ch and p and ks.prio then ks.prio.set(a, ch, tonumber(p)) end
end

return ks.aliases
