-- CreatureDisplayDB.lua

CreatureDisplayDB = {}

local function GetCreatureDisplayDataByIdx(idx)
    local displayData = CreatureDisplayDBdb.data[idx].zone[0]
    return displayData
end

local function GetLatestOrRandom(displayData, key, latest)
    if #displayData[key] <= 0 then
        return nil    
    end

    if latest then
        return displayData[key][1]
    else
        return displayData[key][math.random(#displayData[key])]
    end
end

-- ---------------------------------------------------------
-- Full Creature Data retrieval
-- ---------------------------------------------------------

function CreatureDisplayDB:GetCreatureDisplayDataByName(name)
    local idx = CreatureDisplayDBdb.byname[name]
    if not idx then
        return nil
    end

    return GetCreatureDisplayDataByIdx(idx)
end


function CreatureDisplayDB:GetCreatureDisplayDataById(npcid)
    return self:GetCreatureDisplayDataByNpcId(npcid)
end

function CreatureDisplayDB:GetCreatureDisplayDataByNpcId(npcid)
    local idx = CreatureDisplayDBdb.bynid[npcid]
    if not idx then
        return nil
    end

    return GetCreatureDisplayDataByIdx(idx)
end

function CreatureDisplayDB:GetCreatureDisplayDataByDisplayId(displayid)
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
    local displayData = self:GetCreatureDisplayDataById(npcid)
    if not displayData then
        return nil
    end

    return displayData["name"]
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

function CreatureDisplayDB:GetFixedNpcIdForZone(zoneName, zoneId, npcName)
    local subZones = CreatureDisplayDBzoneFixed.byZoneName[zoneName]
    if not subZones then
        return nil
    end

    zoneId = zoneId or 0

    local zoneIdNpcData = subZones[zoneId]
    if not zoneIdNpcData then
        zoneIdNpcData = subZones[0]
    end
    if not zoneIdNpcData then
        return nil
    end    

    local npcId = zoneIdNpcData[npcName]
    return npcId
end

function CreatureDisplayDB:GetFixedNpcIdForCurrentZone(npcName)
    local currZoneName = GetZoneText()
    local currZoneId = C_Map.GetBestMapForUnit("player")

    return self:GetFixedNpcIdForZone(currZoneName, currZoneId, npcName)
end