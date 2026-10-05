# CreatureDisplayDB
World of Warcraft Addon for Developers

The goal of this addon is to help other addon developers to get NPCs NPCID and DISPLAYID by NPC Name.

This addon has a database of NPC Ids and Display Ids, it does not get it from ingame npcs directly.

The database is built from WAGO data and from ids collected in game (CreatureIdCollector), and it knows where each id was seen. Lookups prefer the ids seen where the player currently is.

## Game versions

Each game version has its own database, and only the one for the running client is loaded:

| Client | TOC | Data files |
|---|---|---|
| Retail | `CreatureDisplayDB.toc` | `CreatureDisplayDB_retail_db_general.lua`, `CreatureDisplayDB_retail_db_byzone.lua` |
| Classic Era, TBC, Mists, WoW Forever | `CreatureDisplayDB_Vanilla.toc`, `_TBC.toc`, `_Mists.toc`, `_Camelot.toc` | `CreatureDisplayDB_forever_db_general.lua`, `CreatureDisplayDB_forever_db_byzone.lua` |

The functions are the same in every version.

## Creature Display Data

The creature display data is an object with 2 fields:

- `npc_ids`: a list of NPC Ids for that creature
- `display_ids`: a list of Display Ids for that creature

Both lists are always present (empty when there are no ids). Treat them as read only: some of them are shared.

The creature name is not part of it, use `GetNpcNameById` for that.

### Order of the ids

The lists are ordered by where the ids were seen, most relevant first:

1. ids seen in the player's current map
2. ids seen in each parent map of it (zone, continent, ...)
3. all the other ids of the creature

Within each of these, the ids are ordered by how reliable the source is (talking heads and bosses first), then descending (in theory, the first is the newest). There are no duplicates.

So the first id of a list is the best guess for the player's current location. Ids seen in a dungeon, a city or a zone are stored under their continent, so "where the player is" means the continent, or a more specific map when there's data for it.

## Fixed NPC Ids

Some NPCs need a specific NPC Id in a specific place (for example Thrall in The Maw). These are curated by hand in `CreatureDisplayDB_<version>_db_byzone.lua` and take priority over the general data:

```lua
CreatureDisplayDBzoneFixed.byName = {
    [ [=[Anduin Wrynn]=] ] = {
        byId = {
            [1648] = { 167833 },                -- uiMapID -> ids
        },
        byGroup = {
            [ [=[TheWarWithin]=] ] = { 249444 },  -- zone group name -> ids
        },
    },
}
```

- `byId` is keyed by uiMapID (`C_Map.GetBestMapForUnit("player")`).
- `byGroup` is keyed by a zone group name from `CreatureDisplayDB_ZoneGroup_Defs.lua` (usually one group per expansion). It's a shorthand: it's the same as a `byId` entry for every uiMapID the group lists. An explicit `byId` entry wins over a group entry.
- A fixed id applies to its map and every map under it. The lookup walks from the player's map up through its parents and uses the first fixed id it finds.
- Fixed ids are meant as a last resort: when one is found, it's used before any other data.
- ids lists have NPC Ids as positive numbers first, then Display Ids as negative numbers.

## How to use this addon

In your addon script, you can call this addon by a code like:

```lua
local function GetCreatureNpcId(name)
    if not CreatureDisplayDB then
        -- Addon not found
        return nil
    end

    -- First, lets check if the creature has a fixed NPC Id for the current zone or its parents
    -- This part can be skipped if your usecase dont care for npc ids locked by zone
    local creatureId = CreatureDisplayDB:GetFixedNpcIdForCurrentZoneAndParents(name)
    if creatureId then
        return creatureId
    end

    -- Lets look for other npc ids for this creature
    -- The first one is the best guess for where the player is
    local npcIds = CreatureDisplayDB:GetNpcIdsByName(name)
    if npcIds and #npcIds > 0 then
        return npcIds[1]
    end

    -- Creature not found in the database
    return nil
end
```

See below the other functions this addon provides

## Main Functions

All the functions below that return ids use the player's current map to order them (see [Order of the ids](#order-of-the-ids)).

### 1. `CreatureDisplayDB:GetCreatureDisplayDataByName(name)`
Retrieves display data for a creature based on its name from the database.

- **Parameters**: `name` (string) – The name of the creature.
- **Returns**: Table with display data or `nil` if the name is not found.

### 2. `CreatureDisplayDB:GetCreatureDisplayDataById(npcid)`
Retrieves display data for a creature based on its NPC ID from the database.

- **Parameters**: `npcid` (number) – The NPC ID of the creature.
- **Returns**: Table with display data or `nil` if the NPC ID is not found.

### 3. `CreatureDisplayDB:GetNpcIdByName(name, latest)`
Retrieves an NPC ID based on the given creature name.

- **Parameters**:
  - `name` (string) – The name of the creature.
  - `latest` (boolean) – If `true`, returns the first NPC ID of the list (the best guess for the current location). If `false`, returns a random NPC ID.
- **Returns**: NPC ID (number) or `nil` if the name is not found or has no NPC IDs.

### 4. `CreatureDisplayDB:GetNpcIdsByName(name)`
Retrieves a list of all NPC IDs associated with the given creature name.

- **Parameters**: `name` (string) – The name of the creature.
- **Returns**: Table of NPC IDs (possibly empty) or `nil` if the name is not found.

### 5. `CreatureDisplayDB:GetNpcNameById(npcid)`
Retrieves the name of a creature based on its NPC ID.

- **Parameters**: `npcid` (number) – The NPC ID of the creature.
- **Returns**: Name (string) of the creature or `nil` if the NPC ID is not found.

### 6. `CreatureDisplayDB:GetDisplayIdByName(name, latest)`
Retrieves a display ID based on the given creature name.

- **Parameters**:
  - `name` (string) – The name of the creature.
  - `latest` (boolean) – If `true`, returns the first display ID of the list (the best guess for the current location). If `false`, returns a random display ID.
- **Returns**: Display ID (number) or `nil` if the name is not found or has no display IDs.

### 7. `CreatureDisplayDB:GetDisplayIdsByName(name)`
Retrieves a list of all display IDs associated with the given creature name.

- **Parameters**: `name` (string) – The name of the creature.
- **Returns**: Table of display IDs (possibly empty) or `nil` if the name is not found.

### 8. `CreatureDisplayDB:GetDisplayIdByNpcId(npcid, latest)`
Retrieves a display ID based on the given NPC ID.

- **Parameters**:
  - `npcid` (number) – The NPC ID of the creature.
  - `latest` (boolean) – If `true`, returns the first display ID of the list. If `false`, returns a random display ID.
- **Returns**: Display ID (number) or `nil` if the NPC ID is not found or has no display IDs.

### 9. `CreatureDisplayDB:GetDisplayIdsByNpcId(npcid)`
Retrieves a list of all display IDs associated with the given NPC ID.

- **Parameters**: `npcid` (number) – The NPC ID of the creature.
- **Returns**: Table of display IDs (possibly empty) or `nil` if the NPC ID is not found.

### 10. `CreatureDisplayDB:GetFixedNpcIdForZone(zoneName, zoneId, npcName)`
Retrieves a fixed NPC ID for a specific map and NPC name. Only the exact map is checked (its `byId` entry, or a `byGroup` entry if that map is listed in the group). Use `GetFixedNpcIdForZoneAndParents` to also check the parent maps.

- **Parameters**:
  - `zoneName` (string) – Ignored, kept for compatibility.
  - `zoneId` (number) – The uiMapID of the map.
  - `npcName` (string) – The name of the NPC.
- **Returns**: Fixed NPC ID (number) or `nil` if no matching NPC ID is found.

### 11. `CreatureDisplayDB:GetFixedNpcIdForCurrentZone(npcName)`
Same as `GetFixedNpcIdForZone`, using the player's current map.

- **Parameters**: `npcName` (string) – The name of the NPC.
- **Returns**: Fixed NPC ID (number) or `nil` if no matching NPC ID is found.

### 12. `CreatureDisplayDB:GetFixedNpcIdForZoneAndParents(zoneId, npcName)`
Retrieves a fixed NPC ID for a map and NPC name, falling back to the map's parents. Walks from `zoneId` up through its parent maps, most specific first, and returns the first fixed id found (`byId`, with `byGroup` entries expanded to the maps the group lists).

- **Parameters**:
  - `zoneId` (number) – The uiMapID of the map.
  - `npcName` (string) – The name of the NPC.
- **Returns**: Fixed NPC ID (number) or `nil` if no matching NPC ID is found.

### 13. `CreatureDisplayDB:GetFixedNpcIdForCurrentZoneAndParents(npcName)`
Same as `GetFixedNpcIdForZoneAndParents`, using the player's current map.

- **Parameters**: `npcName` (string) – The name of the NPC.
- **Returns**: Fixed NPC ID (number) or `nil` if no matching NPC ID is found.

### 14. `CreatureDisplayDB:GetZoneSpecificDataByName(name, uiMapId)`
Retrieves only the ids seen in a map and its parent maps, without the creature's other ids. Useful to combine with your own data: for example, check your location-specific data, then this, then your general data, then `GetCreatureDisplayDataByName`.

- **Parameters**:
  - `name` (string) – The name of the creature.
  - `uiMapId` (number, optional) – The uiMapID of the map. Defaults to the player's current map.
- **Returns**: Table with display data (`npc_ids`, `display_ids`, most specific map first) or `nil` if the name is not found or has no ids for that location.

## Zone Groups

A zone group is a named set of uiMapIDs, usually one expansion (`"TheWarWithin"`, `"Shadowlands"`, ...), defined in `CreatureDisplayDB_ZoneGroup_Defs.lua`. They're only used as a shorthand to define fixed ids (`byGroup`); usually only the continent is listed, and the maps under it are covered through their parents.

`CreatureDisplayDB_ZoneGroup` provides:

- `GetZoneGroup(uiMapId)` – returns `groupName, groupIdx, matchedUiMapId` for a map (checking its parents), or `nil`. Defaults to the player's map.
- `GetZoneKeyChain(uiMapId)` – returns the storage keys of a map, most specific first, ending with `"global"`.
- `GetZoneIdsForGroup(groupName)` – returns the uiMapIDs listed for a group in the defs (not the maps that belong to it through their parents). Read only.
- `GetZoneGroupIdxForUiMapId(uiMapId)`, `GetGroupNameByIdx(groupIdx)`, `GetGroupIdxByName(groupName)` – direct lookups, no parent fallback.

## Slash Commands

### `/CreatureDisplayDBTargetInfo`
A support command that prints target NPC display information. Useful for debugging and gathering information about the current target.

- **Output**:
  - Name: The name of the target.
  - Server: The server of the target.
  - ID: The NPC ID of the target.
  - GUID: The GUID of the target.
  - Zone Name: The name of the current zone.
  - Zone ID: The ID of the current zone.

### `/CreatureDisplayDBMapChain`
Prints the current map and all its parent maps (uiMapID, name and type). Useful to find uiMapIDs for the fixed ids and zone groups.

### `/CreatureDisplayDBZoneGroup`
Prints the zone group of the current map, the map where it was matched, and the map's key chain.

### `/CreatureDisplayDBViewNpcIdByName <name>`, `/CreatureDisplayDBViewDisplayIdByName <name>`
Shows the models of a creature, by its NPC Ids or Display Ids.

### `/CreatureDisplayDBViewNpcId <npcid>`, `/CreatureDisplayDBViewDisplayId <displayid>`
Shows the model of an NPC Id or Display Id.

### `/CreatureDisplayDBModelExplorer`
Opens the model explorer.

## Notes
...
