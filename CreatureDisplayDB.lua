-- CreatureDisplayDB.lua

CreatureDisplayDB = {}

local MAX_ZONE_CHAIN_DEPTH = 20

-- issecretvalue only exists on clients with secret values (retail 12.0+)
local function IsSecretValue(value)
    return issecretvalue ~= nil and issecretvalue(value)
end

-- The DB doesn't write empty id lists (npc_ids / display_ids can be nil). Callers always get a list,
-- missing ones are filled with this shared empty table. Don't modify it.
local EMPTY_IDS = {}

local function ZoneDataHasIds(zoneData)
    if not zoneData then
        return false
    end

    return (zoneData.npc_ids and #zoneData.npc_ids > 0) or (zoneData.display_ids and #zoneData.display_ids > 0)
end

-- Appends ids from source to dest, skipping ids already in seen. Keeps the source order.
local function AppendUniqueIds(dest, seen, source)
    if not source then
        return
    end

    for _, id in ipairs(source) do
        if not seen[id] then
            seen[id] = true
            table.insert(dest, id)
        end
    end
end

-- Returns the zone data (in zones) with ids for uiMapId and each of its parent maps, most specific first.
-- Zone 0 is not included. Returns nil if none has ids.
local function GetZoneDatasForMap(zones, uiMapId)
    local zoneDatas = nil
    local currId = uiMapId
    local depth = 0
    while currId and currId ~= 0 and depth < MAX_ZONE_CHAIN_DEPTH do
        local zoneData = zones[currId]
        if ZoneDataHasIds(zoneData) then
            zoneDatas = zoneDatas or {}
            table.insert(zoneDatas, zoneData)
        end

        local mapInfo = C_Map.GetMapInfo(currId)
        if not mapInfo then
            break
        end
        currId = mapInfo.parentMapID
        depth = depth + 1
    end

    return zoneDatas
end

-- Merges zone datas into a new { npc_ids, display_ids }, in order. Duplicates are removed, the order within each zone is kept.
local function MergeZoneDatas(zoneDatas)
    local npcIds = {}
    local displayIds = {}
    local seenNpcIds = {}
    local seenDisplayIds = {}
    for _, zoneData in ipairs(zoneDatas) do
        AppendUniqueIds(npcIds, seenNpcIds, zoneData.npc_ids)
        AppendUniqueIds(displayIds, seenDisplayIds, zoneData.display_ids)
    end

    return {
        npc_ids = npcIds,
        display_ids = displayIds,
    }
end

-- Returns { npc_ids, display_ids } for the creature at idx.
-- Ids seen in the player's current map come first, then the ones seen in each parent map, then zone[0] (all ids).
-- Duplicates are removed, the order within each zone is kept.
local function GetCreatureDisplayDataByIdx(idx)
    local zones = CreatureDisplayDBdb.data[idx].zone
    local generalData = zones[0]

    -- Zones with ids, most specific first
    local zoneDatas = GetZoneDatasForMap(zones, C_Map.GetBestMapForUnit("player"))

    -- No zone specific data: same as before
    if not zoneDatas then
        if generalData then
            -- Fill missing lists once, so the returned data always has both
            generalData.npc_ids = generalData.npc_ids or EMPTY_IDS
            generalData.display_ids = generalData.display_ids or EMPTY_IDS
        end
        return generalData
    end

    if generalData then
        table.insert(zoneDatas, generalData)
    end

    return MergeZoneDatas(zoneDatas)
end

local function GetLatestOrRandom(displayData, key, latest)
    local ids = displayData[key]
    if not ids or #ids <= 0 then
        return nil
    end

    if latest then
        return ids[1]
    else
        return ids[math.random(#ids)]
    end
end

-- ---------------------------------------------------------
-- Full Creature Data retrieval
-- ---------------------------------------------------------

function CreatureDisplayDB:GetCreatureDisplayDataByName(name)
    if IsSecretValue(name) then
        return nil
    end
    
    local idx = CreatureDisplayDBdb.byname[name]
    if not idx then
        return nil
    end

    return GetCreatureDisplayDataByIdx(idx)
end


-- Returns { npc_ids, display_ids } with only the ids seen in uiMapId and its parent maps (zone 0 is not included),
-- most specific first. Returns nil if the name is not found or has no ids for that location.
-- uiMapId is optional, defaults to the player's current map.
function CreatureDisplayDB:GetZoneSpecificDataByName(name, uiMapId)
    if IsSecretValue(name) then
        return nil
    end

    local idx = CreatureDisplayDBdb.byname[name]
    if not idx then
        return nil
    end

    uiMapId = uiMapId or C_Map.GetBestMapForUnit("player")
    local zoneDatas = GetZoneDatasForMap(CreatureDisplayDBdb.data[idx].zone, uiMapId)
    if not zoneDatas then
        return nil
    end

    return MergeZoneDatas(zoneDatas)
end

function CreatureDisplayDB:GetCreatureDisplayDataById(npcid)
    if IsSecretValue(npcid) then
        return nil
    end
    
    return self:GetCreatureDisplayDataByNpcId(npcid)
end

function CreatureDisplayDB:GetCreatureDisplayDataByNpcId(npcid)
    if IsSecretValue(npcid) then
        return nil
    end
    
    local idx = CreatureDisplayDBdb.bynid[npcid]
    if not idx then
        return nil
    end

    return GetCreatureDisplayDataByIdx(idx)
end

function CreatureDisplayDB:GetCreatureDisplayDataByDisplayId(displayid)
    if IsSecretValue(displayid) then
        return nil
    end
    
    local idx = CreatureDisplayDBdb.bydid[displayid]
    if not idx then
        return nil
    end

    return GetCreatureDisplayDataByIdx(idx)
end

-- ---------------------------------------------------------
-- NPC ID retrieval
-- ---------------------------------------------------------

-- Returns NPC ID by NPC NAME (nil if name is not in the DB)
-- If latest == true, will return the latest NPC ID. If not, it will return a random NPC ID for that NPC NAME
function CreatureDisplayDB:GetNpcIdByName(name, latest)
    local displayData = self:GetCreatureDisplayDataByName(name)
    if not displayData then
        return nil
    end

    return GetLatestOrRandom(displayData, "npc_ids", latest)
end

function CreatureDisplayDB:GetNpcIdsByName(name)
    local displayData = self:GetCreatureDisplayDataByName(name)
    if not displayData then
        return nil
    end

    return displayData["npc_ids"]
end

-- ---------------------------------------------------------
-- NPC NAME retrieval
-- ---------------------------------------------------------

-- Returns NPC NAME by NPC ID (nil if npc id is not in the DB)
function CreatureDisplayDB:GetNpcNameById(npcid)
    if IsSecretValue(npcid) then
        return nil
    end

    -- The display data only has the ids, the name is in the creature record
    local idx = CreatureDisplayDBdb.bynid[npcid]
    if not idx then
        return nil
    end

    return CreatureDisplayDBdb.data[idx].name
end


-- ---------------------------------------------------------
-- DISPLAY ID retrieval
-- ---------------------------------------------------------

function CreatureDisplayDB:GetDisplayIdByName(name, latest)
    local displayData = self:GetCreatureDisplayDataByName(name)
    if not displayData then
        return nil
    end

    return GetLatestOrRandom(displayData, "display_ids", latest)
end

function CreatureDisplayDB:GetDisplayIdsByName(name)
    local displayData = self:GetCreatureDisplayDataByName(name)
    if not displayData then
        return nil
    end

    return displayData["display_ids"]
end

function CreatureDisplayDB:GetDisplayIdByNpcId(npcid, latest)
    local displayData = self:GetCreatureDisplayDataById(npcid)
    if not displayData then
        return nil
    end

    return GetLatestOrRandom(displayData, "display_ids", latest)
end

function CreatureDisplayDB:GetDisplayIdsByNpcId(npcid)
    local displayData = self:GetCreatureDisplayDataById(npcid)
    if not displayData then
        return nil
    end

    return displayData["display_ids"]
end

-- ---------------------------------------------------------
-- FIXED ID BY ZONE retrieval
-- ---------------------------------------------------------

local MAX_FIXED_CHAIN_DEPTH = 20

-- Returns the first npcId (positive id) of an ids list
local function GetFirstNpcId(ids)
    if not ids then
        return nil
    end

    for _, id in ipairs(ids) do
        if id > 0 then
            return id
        end
    end

    return nil
end

-- byGroup is a shorthand to define fixed ids for every uiMapID listed in a zone group (CreatureDisplayDB_ZoneGroup_Defs).
-- On first use, it's expanded into byId. An explicit byId entry wins over a group entry.
local isFixedDataExpanded = false

local function ExpandFixedDataGroups()
    isFixedDataExpanded = true

    for npcName, npcData in pairs(CreatureDisplayDBzoneFixed.byName) do
        if npcData.byGroup then
            npcData.byId = npcData.byId or {}
            for groupName, ids in pairs(npcData.byGroup) do
                local zoneIds = CreatureDisplayDB_ZoneGroup:GetZoneIdsForGroup(groupName)
                if not zoneIds then
                    print("[CreatureDisplayDB] Fixed ids of '" .. npcName .. "': unknown zone group '" .. groupName .. "'")
                else
                    for _, zoneId in ipairs(zoneIds) do
                        if npcData.byId[zoneId] == nil then
                            npcData.byId[zoneId] = ids
                        end
                    end
                end
            end
        end
    end
end

-- Walks the parent chain of zoneId (uiMapID), most specific map first, checking at most maxDepth maps.
-- maxDepth = 1 checks only zoneId itself.
local function LookupFixedNpcIdInZoneData(zoneId, npcName, maxDepth)
    if not isFixedDataExpanded then
        ExpandFixedDataGroups()
    end

    local npcData = CreatureDisplayDBzoneFixed.byName[npcName]
    if not npcData or not npcData.byId then
        return nil
    end

    local byId = npcData.byId

    local currId = zoneId
    local depth = 0
    while currId and currId ~= 0 and depth < maxDepth do
        local npcId = GetFirstNpcId(byId[currId])
        if npcId then
            return npcId
        end

        local mapInfo = C_Map.GetMapInfo(currId)
        if not mapInfo then
            break
        end
        currId = mapInfo.parentMapID
        depth = depth + 1
    end

    return nil
end

-- zoneName is ignored, kept for retro compatibility. Checks only the exact zoneId.
function CreatureDisplayDB:GetFixedNpcIdForZone(zoneName, zoneId, npcName)
    if IsSecretValue(npcName) then
        return nil
    end

    zoneId = zoneId or 0

    return LookupFixedNpcIdInZoneData(zoneId, npcName, 1)
end

function CreatureDisplayDB:GetFixedNpcIdForCurrentZone(npcName)
    local currZoneName = GetZoneText()
    local currZoneId = C_Map.GetBestMapForUnit("player")

    return self:GetFixedNpcIdForZone(currZoneName, currZoneId, npcName)
end

-- Checks zoneId, then its parent maps, most specific first
function CreatureDisplayDB:GetFixedNpcIdForZoneAndParents(zoneId, npcName)
    if IsSecretValue(npcName) then
        return nil
    end

    zoneId = zoneId or 0

    return LookupFixedNpcIdInZoneData(zoneId, npcName, MAX_FIXED_CHAIN_DEPTH)
end

function CreatureDisplayDB:GetFixedNpcIdForCurrentZoneAndParents(npcName)
    local currZoneId = C_Map.GetBestMapForUnit("player")

    return self:GetFixedNpcIdForZoneAndParents(currZoneId, npcName)
end
