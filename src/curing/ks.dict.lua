-- Affliction/defence/helper/meta dictionary + GMCP name translation
ks = ks or {}
ks.dict = ks.dict or {}
ks.dict.entries = ks.dict.entries or {}

local E = ks.dict.entries

local function aff(key, wf, channels, gone)
  E[key] = { kind = "affliction", wf = wf and true or false, gone = gone ~= false, channels = channels or {} }
end

local function def(key, channels, gone)
  E[key] = { kind = "defence", wf = false, gone = gone ~= false, channels = channels or {} }
end

local function helper(key, channels)
  E[key] = { kind = "helper", wf = false, gone = false, channels = channels or {} }
end

local function meta(key, channels)
  E[key] = { kind = "meta", wf = false, gone = false, channels = channels or {} }
end

--- GMCP affliction name -> internal key
ks.dict.gmcp_to_internal = {
  blind = "blindaff",
  deaf = "deafaff",
  brokenleftarm = "crippledleftarm",
  brokenrightarm = "crippledrightarm",
  brokenleftleg = "crippledleftleg",
  brokenrightleg = "crippledrightleg",
  damagedleftarm = "mangledleftarm",
  damagedrightarm = "mangledrightarm",
  damagedleftleg = "mangledleftleg",
  damagedrightleg = "mangledrightleg",
  mangledleftarm = "mutilatedleftarm",
  mangledrightarm = "mutilatedrightarm",
  mangledleftleg = "mutilatedleftleg",
  mangledrightleg = "mutilatedrightleg",
  damagedhead = "mildconcussion",
  mangledhead = "seriousconcussion",
  nausea = "illness",
  weariness = "weakness",
  scytherus = "relapsing",
  lovers = "inlove",
  impaled = "impale",
  transfixation = "transfixed",
  whisperingmadness = "madness",
  pacified = "pacifism",
  disrupted = "disrupt",
  temperedcholeric = "cholerichumour",
  temperedmelancholic = "melancholichumour",
  temperedphlegmatic = "phlegmatichumour",
  temperedsanguine = "sanguinehumour",
  burning = "ablaze",
}

--- GMCP defence name -> internal key
ks.dict.gmcp_to_internal_def = {
  blindness = "blind",
  deafness = "deaf",
  density = "mass",
  levitating = "levitation",
  poisonresist = "venom",
  fangbarrier = "sileris",
  scholasticism = "myrrh",
  blocking = "block",
  gripping = "grip",
  heldbreath = "breath",
  antiforce = "gaiartha",
  bodyaugment = "mainaas",
  ironwill = "qamad",
  precision = "trusad",
  durability = "tsuura",
  bloodquell = "ukhia",
  bedevilaura = "bedevil",
  boostedregeneration = "boosting",
  reflections = "reflection",
  airpocket = "waterbubble",
}

--- Internal -> GMCP (afflictions that differ)
ks.dict.internal_to_gmcp = {}
for g, i in pairs(ks.dict.gmcp_to_internal) do
  ks.dict.internal_to_gmcp[i] = g
end

--- Herb groups (bellwort/cuprum, etc.)
local function herb_group(list, herb, mineral, prio)
  prio = prio or 80
  for _, k in ipairs(list) do
    aff(k, false, { herb = { p = prio, eat = herb, mineral = mineral } })
  end
end

herb_group({ "peace", "inlove", "justice", "generosity", "retribution", "timeloop", "pacifism" }, "bellwort", "cuprum", 82)
herb_group({ "dissonance", "dizziness", "shyness", "epilepsy", "impatience", "stupidity", "depression", "shadowmadness" }, "goldenseal", "plumbum", 85)
herb_group({ "masochism", "recklessness", "vertigo", "loneliness", "agoraphobia", "claustrophobia", "earthdisrupt" }, "lobelia", "argentum", 80)
herb_group({ "dementia", "paranoia", "hypersomnia", "hallucinations", "confusion" }, "ash", "stannum", 78)
herb_group({ "relapsing", "darkshade", "lethargy", "illness", "haemophilia", "addiction" }, "ginseng", "ferrum", 75)
herb_group({ "asthma", "clumsiness", "sensitivity", "healthleech", "hypochondria", "weakness", "parasite" }, "kelp", "aurum", 88)
herb_group({ "cholerichumour", "melancholichumour", "phlegmatichumour", "sanguinehumour" }, "ginger", "antimony", 70)
herb_group({ "airdisrupt", "firedisrupt", "spiritdisrupt", "waterdisrupt" }, "lobelia", "argentum", 79)

aff("paralysis", false, { herb = { p = 96, eat = "bloodroot", mineral = "magnesium" } })
aff("slickness", false, {
  herb = { p = 94, eat = "bloodroot", mineral = "magnesium" },
  smoke = { p = 93, pipe = "valerian" },
})

-- Goldenseal overlap: already set stupidity etc.; ensure epilepsy etc. covered by group

aff("aeon", false, { smoke = { p = 99, pipe = "elm" } })
aff("deadening", false, { smoke = { p = 88, pipe = "elm" } })
aff("madness", false, { smoke = { p = 90, pipe = "elm" } })
aff("hellsight", false, { smoke = { p = 87, pipe = "valerian" } })
aff("disloyalty", false, { smoke = { p = 86, pipe = "valerian" } })
aff("manaleech", false, { smoke = { p = 86, pipe = "valerian" } })

aff("voyria", false, { purgative = { p = 99, sip = "immunity" } })

-- Salves: mending
local function mending(list, prio)
  for _, k in ipairs(list) do
    aff(k, false, { salve = { p = prio or 85, apply = "mending", salve = "renewal" } })
  end
end

mending({ "ablaze", "severeburn", "extremeburn", "charredburn", "meltingburn", "selarnia" }, 90)
mending({ "crippledleftarm", "crippledrightarm", "crippledleftleg", "crippledrightleg", "unknowncrippledarm", "unknowncrippledleg", "unknowncrippledlimb" }, 84)

-- Salves: restoration
local function restoration(list, prio)
  for _, k in ipairs(list) do
    aff(k, false, { salve = { p = prio or 82, apply = "restoration", salve = "reconstructive" } })
  end
end

restoration({ "mangledleftarm", "mangledrightarm", "mangledleftleg", "mangledrightleg",
  "mutilatedleftarm", "mutilatedrightarm", "mutilatedleftleg", "mutilatedrightleg",
  "serioustrauma", "mildtrauma", "seriousconcussion", "mildconcussion",
  "heartseed", "laceratedthroat", "hypothermia", "parestoarms", "parestolegs" }, 83)

aff("frozen", false, { salve = { p = 88, apply = "caloric", salve = "exothermic" } })
aff("shivering", false, { salve = { p = 88, apply = "caloric", salve = "exothermic" } })

local function epidermal(list, prio)
  for _, k in ipairs(list) do
    aff(k, false, { salve = { p = prio or 80, apply = "epidermal", salve = "sensory" } })
  end
end

epidermal({ "anorexia", "itching", "scalded", "blindaff", "deafaff", "stuttering", "slashedthroat" }, 81)

aff("fear", false, { focus = { p = 75 }, misc = { p = 50 } })

-- Focus-capable mental affs
local focus_affs = {
  "agoraphobia", "claustrophobia", "confusion", "dementia", "dizziness", "epilepsy", "generosity",
  "hallucinations", "hypersomnia", "loneliness", "masochism", "pacifism", "paranoia", "recklessness",
  "shyness", "stupidity", "vertigo", "airdisrupt", "firedisrupt", "waterdisrupt", "spiritdisrupt",
}
for _, k in ipairs(focus_affs) do
  if not E[k] then
    aff(k, false, { focus = { p = 65 } })
  else
    local ch = E[k].channels
    ch.focus = ch.focus or { p = 65 }
  end
end

-- Sip precision fractures
aff("skullfractures", false, { sip = { p = 80, kind = "precision", part = "head" } })
aff("crackedribs", false, { sip = { p = 80, kind = "precision", part = "torso" } })
aff("wristfractures", false, { sip = { p = 80, kind = "precision", part = "arms" } })
aff("torntendons", false, { sip = { p = 80, kind = "precision", part = "legs" } })

-- Misc / hindering (wf)
aff("bleeding", false, { misc = { p = 95, kind = "clot" } })
aff("bound", true, { misc = { p = 90, kind = "writhe" } })
aff("webbed", true, { misc = { p = 90, kind = "writhe" } })
aff("roped", true, { misc = { p = 90, kind = "writhe" } })
aff("transfixed", true, { misc = { p = 90, kind = "writhe" } })
aff("impale", true, { misc = { p = 90, kind = "writhe" } })
aff("hoisted", false, { misc = { p = 85, kind = "writhe" } })
aff("prone", false, { misc = { p = 40, kind = "stand" } })
aff("sleep", true, { misc = { p = 70, kind = "wake" } })
aff("disrupt", false, { misc = { p = 75, kind = "disrupt" } })
aff("lovers", false, { physical = { p = 50, kind = "reject" } })
aff("amnesia", false, { misc = { p = 60 } })

-- wf afflictions (pipelines / no simple cure)
local wf_affs = {
  "blackout", "burning", "cadmus", "cantmorph", "corrupted", "degenerate", "dehydrated", "deteriorate",
  "galed", "hamstring", "hatred", "hecate", "icing", "inquisition", "lullaby", "mucous", "ninkharsag",
  "numbedleftarm", "numbedrightarm", "palpatar", "phlogistication", "pinshot", "retardation", "rixil",
  "stain", "stun", "swellskin", "timeflux", "unconsciousness", "unknowncure", "vitrification", "voided",
  "paradox",
}
for _, k in ipairs(wf_affs) do
  if not E[k] then aff(k, true, {}) end
end

aff("cantvitality", true, { gone = false })

-- Helpers (curing*, check*, waiting*)
local curing_helpers = {
  "curingbound", "curingheartseed", "curinghoisted", "curinghypothermia", "curingimpale", "curinglaceratedthroat",
  "curingmangledleftarm", "curingmangledleftleg", "curingmangledrightarm", "curingmangledrightleg",
  "curingmildconcussion", "curingmildtrauma", "curingmutilatedleftarm", "curingmutilatedleftleg",
  "curingmutilatedrightarm", "curingmutilatedrightleg", "curingparestoarms", "curingparestolegs",
  "curingroped", "curingseriousconcussion", "curingserioustrauma", "curingsleep", "curingspeed",
  "curingtransfixed", "curingwebbed",
}
for _, k in ipairs(curing_helpers) do helper(k, {}) end

local check_helpers = {
  "checkanorexia", "checkasthma", "checkhypersomnia", "checkimpatience", "checkparalysis", "checkslows", "checkstun", "checkwrithes",
}
for _, k in ipairs(check_helpers) do helper(k, { misc = { p = 0, kind = "check" } }) end

helper("age", {})
helper("bloodsworntoggle", { misc = {} })
helper("defcheck", { physical = {} })
helper("diag", { physical = {} })
helper("doparry", { physical = {} })
helper("doprecache", { misc = {} })
helper("dragonflex", { misc = {} })
helper("dragonheal", { physical = {} })
helper("dwinnu", { misc = {} })
helper("fillelm", { physical = {} })
helper("fillskullcap", { physical = {} })
helper("fillvalerian", { physical = {} })
helper("fitness", { physical = {} })
helper("footingattack", {})
helper("givewarning", {})
helper("gotbalance", {})
helper("gothit", {})
helper("lightpipes", { physical = {} })
helper("nomana", {})
helper("phoenix", { physical = {} })
helper("rage", { misc = {} })
helper("rejuvenate", { physical = {} })
helper("restore", { physical = {} })
helper("rewield", { physical = {} })
helper("sacrifice", { physical = {} })
helper("shrugging", { physical = {} })
helper("stolebalance", {})
helper("touchtree", { misc = {} })
helper("transmute", { physical = {} })
helper("usehealing", { misc = {} })
helper("waitingfordragonbreath", {})
helper("waitingfordragonform", {})
helper("waitingformace", {})
helper("waitingforrejuvenate", {})
helper("waitingforsileris", {})
helper("waitingforviridian", {})
helper("waitingonblind", {})
helper("waitingondeaf", {})
helper("waitingonrebounding", {})

-- Meta
meta("healhealth", { sip = { p = 70, kind = "health" }, moss = { p = 65, eat = "irid" } })
meta("healmana", { sip = { p = 70, kind = "mana" }, moss = { p = 65, eat = "potash" } })
meta("unknownany", { focus = { p = 50 } })
meta("unknownmental", { focus = { p = 55 } })
helper("sstosvoa", {})
helper("sstosvod", {})
helper("svotossa", {})
helper("svotossd", {})

-- Defences (147): physical keepup + consumable defs
local function def_phys(k, gone)
  def(k, { physical = { p = 50, kind = "raise" } }, gone)
end

local physical_defs = {
  "affinity", "air", "arash", "arctar", "aria", "armour", "astralform", "baalzadeen", "barkskin", "basilisk",
  "bear", "bindall", "bodyblock", "boosting", "boundair", "boundearth", "boundfire", "boundspirit", "boundwater",
  "care", "cat", "chargeshield", "cheetah", "circulate", "cloak", "condor", "devil", "diamondskin", "dilation",
  "disperse", "doya", "dragon", "dragonarmour", "dragonbreath", "dragonform", "drunkensailor", "eagle", "earth",
  "earthblessing", "elephant", "elusiveness", "empathy", "enduranceblessing", "evadeblock", "extispicy", "fire",
  "flame", "fortifiedair", "fortifiedearth", "fortifiedfire", "fortifiedspirit", "fortifiedwater", "fortifyall",
  "frostblessing", "gaital", "gopher", "gorilla", "grip", "heartsfury", "hiding", "horse", "hydra", "hyena",
  "icewyrm", "impaling", "jackdaw", "jaguar", "kaiboost", "lay", "lifevision", "lyre", "mace", "maelstrom",
  "mainaas", "mask", "meditate", "metawake", "mindseye", "mir", "nightingale", "nightsight", "oak", "owl",
  "pinchblock", "qamad", "rain", "rat", "reflection", "resistance", "rest", "riding", "sanya", "scorpion",
  "selfishness", "shadowcloak", "shadowveil", "shield", "simultaneity", "sloth", "spinning", "spirit", "squirrel",
  "stealth", "stonefist", "stoneskin", "summon", "syphon", "temperance", "thermalblessing", "thyr", "trusad",
  "tsuura", "tune", "turtle", "tykonos", "ukhia", "viridian", "vitality", "watch", "water", "waterweird",
  "wildcat", "willow", "willpowerblessing", "wolf", "wolverine", "wyvern", "bedevil", "gaiartha", "block", "breath",
}
for _, k in ipairs(physical_defs) do def_phys(k, true) end

def("blind", { herb = { p = 70, eat = "bayberry", mineral = "arsenic" }, misc = {} }, true)
def("deaf", { herb = { p = 70, eat = "hawthorn", mineral = "calamine" }, misc = {} }, true)
def("deathsight", { herb = { p = 65, eat = "skullcap", mineral = "azurite" }, physical = {} }, true)
def("insomnia", { herb = { p = 75, eat = "cohosh", mineral = "gypsum" }, misc = {} }, true)
def("kola", { herb = { p = 60, eat = "kola", mineral = "quartz" } }, true)
def("myrrh", { herb = { p = 60, eat = "myrrh", mineral = "bisemutum" } }, true)
def("thirdeye", { herb = { p = 65, eat = "echinacea", mineral = "dolomite" }, misc = {} }, true)
def("waterbubble", { herb = { p = 65, eat = "pear", mineral = "calcite" } }, true)
def("caloric", { salve = { p = 70, apply = "caloric", salve = "exothermic" } }, true)
def("mass", { salve = { p = 70, apply = "mass", salve = "density" } }, true)
def("rebounding", { smoke = { p = 85, pipe = "skullcap" } }, true)
def("frost", { purgative = { p = 70, sip = "frost" } }, true)
def("levitation", { purgative = { p = 70, sip = "levitation" } }, true)
def("speed", { purgative = { p = 75, sip = "speed" } }, true)
def("venom", { purgative = { p = 70, sip = "venom" } }, true)
def("sileris", { misc = { p = 80, kind = "sileris" }, herb = { p = 80, eat = "sileris" } }, true)

function ks.dict.internalAfflictionName(gmcpName)
  return ks.dict.gmcp_to_internal[gmcpName] or gmcpName
end

function ks.dict.internalDefenceName(gmcpName)
  return ks.dict.gmcp_to_internal_def[gmcpName] or gmcpName
end

return ks.dict
