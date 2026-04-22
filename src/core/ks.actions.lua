-- Action queue, balance slots, timeouts; one-shot vs pipeline hooks

ks = ks or {}
ks.actions = ks.actions or {}

local actions = {}
local bals_in_use = {}
local lagcount = 0

local CHANNELS = {
  "balance", "equilibrium", "herb", "salve", "smoke", "sip", "focus", "moss", "purgative", "misc", "physical"
}

function ks.actions.initBals()
  for _, c in ipairs(CHANNELS) do
    if ks.bals[c] == nil then
      ks.bals[c] = true
    end
  end
end

ks.actions.initBals()

local function timeoutFor(channel)
  local t = ks.conf.timeouts
  return (t and t[channel]) or 3
end

--- @param act table { name=string, channel=string, send=function|string, oncompleted=function, pipeline=bool, ontimeout=function }
function ks.actions.doAction(act)
  if not act or not act.channel then return false end
  local ch = act.channel
  if bals_in_use[ch] then return false end
  local name = act.name or (ch .. "_" .. tostring(os.time()))
  local wait = act.wait or timeoutFor(ch)
  if ks.affs and ks.affs.seriousconcussion and act.sync ~= false then
    wait = wait + (ks.conf.syncdelay_extra or 0.3)
  end
  local tid
  tid = tempTimer(wait * 1000, function()
    if actions[name] and actions[name].timerid == tid then
      ks.actions._timeout(name, act)
    end
  end)
  actions[name] = {
    act = act,
    timerid = tid,
    channel = ch,
  }
  bals_in_use[ch] = name
  if type(act.send) == "function" then
    act.send()
  elseif type(act.send) == "string" and act.send ~= "" then
    if act.send:find("[\r\n]") then
      for line in act.send:gmatch("[^\r\n]+") do
        send(line)
      end
    else
      send(act.send)
    end
  end
  return true
end

function ks.actions._timeout(name, act)
  local entry = actions[name]
  if not entry then return end
  if entry.timerid then killTimer(entry.timerid) end
  actions[name] = nil
  if entry.channel and bals_in_use[entry.channel] == name then
    bals_in_use[entry.channel] = nil
  end
  lagcount = lagcount + 1
  if act.ontimeout then act.ontimeout() end
  if ks.curing and ks.curing.decide then
    ks.curing.decide("timeout")
  end
end

function ks.actions.complete(name)
  local entry = actions[name]
  if not entry then return end
  local act = entry.act
  if entry.timerid then killTimer(entry.timerid) end
  actions[name] = nil
  if entry.channel and bals_in_use[entry.channel] == name then
    bals_in_use[entry.channel] = nil
  end
  if act and act.oncompleted then act.oncompleted() end
  if ks.curing and ks.curing.decide then
    ks.curing.decide("complete")
  end
end

function ks.actions.kill(name)
  local entry = actions[name]
  if not entry then return end
  if entry.timerid then killTimer(entry.timerid) end
  actions[name] = nil
  if entry.channel and bals_in_use[entry.channel] == name then
    bals_in_use[entry.channel] = nil
  end
end

function ks.actions.clearAll()
  for name, _ in pairs(actions) do
    ks.actions.kill(name)
  end
  bals_in_use = {}
end

function ks.actions.using(channel)
  return bals_in_use[channel] ~= nil
end

function ks.actions.findByChannel(channel)
  return bals_in_use[channel]
end

function ks.actions.syncdelay()
  if ks.affs and ks.affs.seriousconcussion then
    return (ks.conf.syncdelay_extra or 0.3)
  end
  return 0
end

return ks.actions
