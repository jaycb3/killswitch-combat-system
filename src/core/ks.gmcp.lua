-- GMCP event bridge for Achaea / IRE

ks = ks or {}

local function gmcpTable()
  return gmcp or {}
end

local function toInternalAff(name)
  if ks.dict and ks.dict.internalAfflictionName then
    return ks.dict.internalAfflictionName(name)
  end
  if not name or not ks.dict or not ks.dict.gmcp_to_internal then return name end
  return ks.dict.gmcp_to_internal[name] or name
end

local function toInternalDef(name)
  if ks.dict and ks.dict.internalDefenceName then
    return ks.dict.internalDefenceName(name)
  end
  if not name or not ks.dict or not ks.dict.gmcp_to_internal_def then return name end
  return ks.dict.gmcp_to_internal_def[name] or name
end

ks.gmcp = ks.gmcp or {}

function ks.gmcp.onVitals()
  local g = gmcpTable().Char and gmcp.Char.Vitals
  if g and ks.vitals and ks.vitals.parse then
    ks.vitals.parse(g)
  end
end

function ks.gmcp.onStatus()
  local st = gmcpTable().Char and gmcp.Char.Status
  if not st then return end
  ks.me = ks.me or {}
  if st.name then ks.me.name = st.name end
  if st.class then ks.me.class = st.class end
  if st.target ~= nil then ks.me.target = st.target end
  ks.event.fire("status_updated", st)
  if ks.offense and ks.offense.onClassDetected then
    ks.offense.onClassDetected(st.class)
  end
end

function ks.gmcp.onAfflictionsList()
  ks.affs = {}
  local list = gmcpTable().Char and gmcp.Char.Afflictions and gmcp.Char.Afflictions.List
  if type(list) ~= "table" then return end
  for _, item in ipairs(list) do
    local n = type(item) == "table" and item.name or item
    if n then
      ks.affs[toInternalAff(n)] = true
    end
  end
  ks.event.fire("afflictions_list")
  if ks.curing and ks.curing.decide then ks.curing.decide("list") end
end

function ks.gmcp.onAfflictionAdd()
  local args = gmcpTable().Char and gmcp.Char.Afflictions and gmcp.Char.Afflictions.Add
  if type(args) ~= "table" then return end
  local n = args.name
  if not n then return end
  local key = toInternalAff(n)
  ks.affs[key] = true
  ks.event.fire("affliction_add", key, args)
  if ks.curing and ks.curing.decide then ks.curing.decide("add") end
end

function ks.gmcp.onAfflictionRemove()
  local args = gmcpTable().Char and gmcp.Char.Afflictions and gmcp.Char.Afflictions.Remove
  if args == nil then return end
  local function removeOne(n)
    local key = toInternalAff(n)
    ks.affs[key] = nil
    ks.event.fire("affliction_remove", key)
  end
  if type(args) == "table" then
    if #args > 0 then
      for _, n in ipairs(args) do removeOne(n) end
    elseif args.name then
      removeOne(args.name)
    end
  elseif type(args) == "string" then
    removeOne(args)
  end
  if ks.curing and ks.curing.decide then ks.curing.decide("remove") end
end

function ks.gmcp.onDefencesList()
  ks.defs = {}
  local list = gmcpTable().Char and gmcp.Char.Defences and gmcp.Char.Defences.List
  if type(list) ~= "table" then return end
  for _, item in ipairs(list) do
    local n = type(item) == "table" and item.name or item
    if n then
      ks.defs[toInternalDef(n)] = true
    end
  end
  ks.event.fire("defences_list")
  if ks.keepup and ks.keepup.onDefsRefresh then ks.keepup.onDefsRefresh() end
end

function ks.gmcp.onDefenceAdd()
  local args = gmcpTable().Char and gmcp.Char.Defences and gmcp.Char.Defences.Add
  if type(args) ~= "table" then return end
  local n = args.name
  if not n then return end
  local key = toInternalDef(n)
  ks.defs[key] = true
  ks.event.fire("defence_add", key, args)
  if ks.keepup and ks.keepup.onDefenceAdd then ks.keepup.onDefenceAdd(key) end
end

function ks.gmcp.onDefenceRemove()
  local args = gmcpTable().Char and gmcp.Char.Defences and gmcp.Char.Defences.Remove
  if args == nil then return end
  local function remOne(n)
    local key = toInternalDef(n)
    ks.defs[key] = nil
    ks.event.fire("defence_remove", key)
    if ks.keepup and ks.keepup.onDefenceRemove then ks.keepup.onDefenceRemove(key) end
  end
  if type(args) == "table" then
    if #args > 0 then
      for _, n in ipairs(args) do remOne(n) end
    elseif args.name then
      remOne(args.name)
    end
  elseif type(args) == "string" then
    remOne(args)
  end
end

function ks.gmcp.onTargetInfo()
  local t = gmcpTable().IRE and gmcp.IRE.Target
  if not t then return end
  ks.target = ks.target or {}
  if t.Info then
    local i = t.Info
    if i.id then ks.target.id = i.id end
    if i.short_desc then ks.target.desc = i.short_desc end
    if i.hpperc then
      local p = tostring(i.hpperc):gsub("%%", "")
      ks.target.hpperc = tonumber(p) or ks.target.hpperc
    end
  end
  if t.Set ~= nil then
    ks.target.id = t.Set
  end
  ks.event.fire("target_info", ks.target)
end

function ks.gmcp.onRiftList()
  ks.rift = {}
  local list = gmcpTable().IRE and gmcp.IRE.Rift and gmcp.IRE.Rift.List
  if type(list) ~= "table" then return end
  for _, row in ipairs(list) do
    if type(row) == "table" and row.name then
      ks.rift[row.name:lower()] = tonumber(row.amount) or 0
    end
  end
  ks.event.fire("rift_list")
end

function ks.gmcp.onRiftChange()
  local ch = gmcpTable().IRE and gmcp.IRE.Rift and gmcp.IRE.Rift.Change
  if type(ch) ~= "table" or not ch.name then return end
  ks.rift = ks.rift or {}
  ks.rift[ch.name:lower()] = tonumber(ch.amount) or 0
  ks.event.fire("rift_change", ch)
end

function ks.gmcp.onRoomInfo()
  local r = gmcpTable().Room and gmcp.Room.Info
  if type(r) ~= "table" then return end
  ks.room = ks.room or {}
  ks.room.num = r.num
  ks.room.name = r.name
  ks.room.area = r.area
  ks.room.environment = r.environment
  ks.room.exits = r.exits or {}
  ks.room.details = r.details
  ks.event.fire("room_info", ks.room)
end

function ks.gmcp.onRoomAddPlayer()
  local p = gmcpTable().Room and gmcp.Room.AddPlayer
  if type(p) ~= "table" then return end
  ks.room.players = ks.room.players or {}
  table.insert(ks.room.players, p.name or p.fullname)
end

function ks.gmcp.onRoomRemovePlayer()
  local name = gmcpTable().Room and gmcp.Room.RemovePlayer
  if not name or not ks.room.players then return end
  for i, n in ipairs(ks.room.players) do
    if n == name then table.remove(ks.room.players, i) break end
  end
end

--- Register all handlers (call after ks.dict is loaded)
function ks.gmcp.register()
  local function reg(event, fnname)
    registerAnonymousEventHandler(event, fnname)
  end
  -- Closures work in Mudlet registerAnonymousEventHandler
  reg("gmcp.Char.Vitals", function() ks.gmcp.onVitals() end)
  reg("gmcp.Char.Status", function() ks.gmcp.onStatus() end)
  reg("gmcp.Char.Afflictions.List", function() ks.gmcp.onAfflictionsList() end)
  reg("gmcp.Char.Afflictions.Add", function() ks.gmcp.onAfflictionAdd() end)
  reg("gmcp.Char.Afflictions.Remove", function() ks.gmcp.onAfflictionRemove() end)
  reg("gmcp.Char.Defences.List", function() ks.gmcp.onDefencesList() end)
  reg("gmcp.Char.Defences.Add", function() ks.gmcp.onDefenceAdd() end)
  reg("gmcp.Char.Defences.Remove", function() ks.gmcp.onDefenceRemove() end)
  reg("gmcp.IRE.Target.Info", function() ks.gmcp.onTargetInfo() end)
  reg("gmcp.IRE.Target.Set", function() ks.gmcp.onTargetInfo() end)
  reg("gmcp.IRE.Rift.List", function() ks.gmcp.onRiftList() end)
  reg("gmcp.IRE.Rift.Change", function() ks.gmcp.onRiftChange() end)
  reg("gmcp.Room.Info", function() ks.gmcp.onRoomInfo() end)
  reg("gmcp.Room.AddPlayer", function() ks.gmcp.onRoomAddPlayer() end)
  reg("gmcp.Room.RemovePlayer", function() ks.gmcp.onRoomRemovePlayer() end)
end

function ks.gmcp.enableModules()
  if sendGMCP then
    sendGMCP([[Core.Supports.Set ["Char 1", "Char.Vitals 1", "Char.Afflictions 1", "Char.Defences 1", "Char.Items 1", "Char.Skills 1", "Char.Status 1", "Room 1", "IRE.Rift 1", "IRE.Target 1", "IRE.Time 1"]]])
  end
end

return ks.gmcp
