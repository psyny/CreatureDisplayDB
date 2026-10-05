-- CreatureDisplayDB_forever_db_byzone.lua

-- Fixed ids is a workaround to overcome the problem that sometimes the NPCID for an specific zone needs to be a fixed id.
-- the structure is:
--     [npc name].byId[uiMapID] = { ids }
--     [npc name].byGroup[zone group name] = { ids }   (group names from CreatureDisplayDB_ZoneGroup_Defs.lua)
-- ids: npcIds as positive numbers first, then displayIds as negative numbers
-- The lookup walks the parent chain of the current map (see /CreatureDisplayDBMapChain), most specific map first.
-- For each map, byId is checked first, then byGroup if that map defines a zone group.

CreatureDisplayDBzoneFixed = {}
CreatureDisplayDBzoneFixed.byName = {}

CreatureDisplayDBzoneFixed.byName = { 
}
