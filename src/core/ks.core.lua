-- Killswitch — Achaea Mudlet combat system (core)
-- GMCP-first; namespace and configuration.

ks = ks or {}
ks._VERSION = "0.1.0"

ks.conf = ks.conf or {
  debug = false,
  siphealth = 80,
  sipmana = 70,
  mosshealth = 60,
  mossmana = 60,
  bleedamount = 60,
  manableedamount = 60,
  corruptedhealthmin = 70,
  manause = 35,
  serverside = false,
  paused = false,
  -- Action timeout defaults (seconds), from svof-style tuning
  timeouts = {
    herb = 2.5,
    salve = 5,
    smoke = 2,
    sip = 7,
    moss = 10,
    purgative = 10,
    focus = 5,
    dragonheal = 20,
    physical = 3,
    misc = 3,
    pipeline = 3,
  },
  syncdelay_extra = 0.3, -- seriousconcussion
}

ks.me = ks.me or { name = "", class = "", target = "" }
ks.stats = ks.stats or {}
ks.affs = ks.affs or {}
ks.defs = ks.defs or {}
ks.bals = ks.bals or {}
ks.rift = ks.rift or {}
ks.room = ks.room or { name = "", area = "", exits = {}, players = {} }

ks.event = ks.event or {}

function ks.event.fire(name, ...)
  local f = ks.event[name]
  if type(f) == "function" then
    return f(...)
  end
end

function ks.event.on(name, fn)
  local prev = ks.event[name]
  if type(prev) == "function" then
    ks.event[name] = function(...)
      prev(...)
      return fn(...)
    end
  else
    ks.event[name] = fn
  end
end

--- Base path for optional dofile loads (set by loader or package)
ks.basePath = ks.basePath or ""

function ks.setBasePath(p)
  ks.basePath = (p or ""):gsub("/$", "") .. "/"
end

function ks.dofile(rel)
  local path = ks.basePath .. rel
  local chunk, err = loadfile(path)
  if not chunk then
    error("Killswitch: cannot load " .. path .. ": " .. tostring(err))
  end
  return chunk()
end

--- Reset transient combat state (not config)
function ks.resetSession()
  ks.affs = {}
  ks.defs = {}
  ks.rift = {}
  if ks.actions and ks.actions.clearAll then
    ks.actions.clearAll()
  end
end

return ks
