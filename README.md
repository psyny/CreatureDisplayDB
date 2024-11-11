# CreatureDisplayDB
World of Warcraft Addon for Developers

The goal of this addon is to help other addon developers to get NPCs NPCID and DISPLAYID by NPC Name.

This addon has a database of NPC Ids and Display Ids, it does not get it from ingame npcs directly.

For now, the database used is WAGO only. But I might add more in the future.

## Main Functions

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
  - `latest` (boolean) – If `true`, returns the latest NPC ID. If `false`, returns a random NPC ID.
- **Returns**: NPC ID (number) or `nil` if the name is not found.

### 4. `CreatureDisplayDB:GetNpcIdsByName(name)`
Retrieves a list of all NPC IDs associated with the given creature name.

- **Parameters**: `name` (string) – The name of the creature.
- **Returns**: Table of NPC IDs or `nil` if the name is not found.

### 5. `CreatureDisplayDB:GetNpcNameById(npcid)`
Retrieves the name of a creature based on its NPC ID.

- **Parameters**: `npcid` (number) – The NPC ID of the creature.
- **Returns**: Name (string) of the creature or `nil` if the NPC ID is not found.

### 6. `CreatureDisplayDB:GetDisplayIdByName(name, latest)`
Retrieves a display ID based on the given creature name.

- **Parameters**:
  - `name` (string) – The name of the creature.
  - `latest` (boolean) – If `true`, returns the latest display ID. If `false`, returns a random display ID.
- **Returns**: Display ID (number) or `nil` if the name is not found.

### 7. `CreatureDisplayDB:GetDisplayIdsByName(name)`
Retrieves a list of all display IDs associated with the given creature name.

- **Parameters**: `name` (string) – The name of the creature.
- **Returns**: Table of display IDs or `nil` if the name is not found.

### 8. `CreatureDisplayDB:GetDisplayIdByNpcId(npcid, latest)`
Retrieves a display ID based on the given NPC ID.

- **Parameters**:
  - `npcid` (number) – The NPC ID of the creature.
  - `latest` (boolean) – If `true`, returns the latest display ID. If `false`, returns a random display ID.
- **Returns**: Display ID (number) or `nil` if the NPC ID is not found.

### 9. `CreatureDisplayDB:GetDisplayIdsByNpcId(npcid)`
Retrieves a list of all display IDs associated with the given NPC ID.

- **Parameters**: `npcid` (number) – The NPC ID of the creature.
- **Returns**: Table of display IDs or `nil` if the NPC ID is not found.

### 10. `CreatureDisplayDB:GetFixedNpcIdForZone(zoneName, zoneId, npcName)`
Retrieves a fixed NPC ID for a specific zone and NPC name.

- **Parameters**:
  - `zoneName` (string) – The name of the zone.
  - `zoneId` (number, optional) – The ID of the zone. Defaults to `0` if not provided.
  - `npcName` (string) – The name of the NPC.
- **Returns**: Fixed NPC ID (number) or `nil` if no matching NPC ID is found.

### 11. `CreatureDisplayDB:GetFixedNpcIdForCurrentZone(npcName)`
Retrieves a fixed NPC ID for the current zone based on the player's location.

- **Parameters**: `npcName` (string) – The name of the NPC.
- **Returns**: Fixed NPC ID (number) or `nil` if no matching NPC ID is found.

## Slash Command

### `/CreatureDisplayDBTargetInfo`
A support command that prints target NPC display information. Useful for debugging and gathering information about the current target.

- **Output**:
  - Name: The name of the target.
  - Server: The server of the target.
  - ID: The NPC ID of the target.
  - GUID: The GUID of the target.
  - Zone Name: The name of the current zone.
  - Zone ID: The ID of the current zone.

## Notes
...