-- CreatureDisplayDB_retail_db_byzone.lua

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
    -- The Maw
    [ [=[Thrall]=] ] = {
        byId = {
            [1543] = { 166981 },
        },
    },
    [ [=[Lady Jaina Proudmoore]=] ] = {
        byId = {
            [1543] = { 166980 },
        },
    },
    [ [=[Baine Bloodhoof]=] ] = {
        byId = {
            [1543] = { 168162 },
        },
    },
    [ [=[The Jailer]=] ] = {
        byId = {
            [1543] = { 165539 },
        },
    },

    -- The War Within / Midnight
    [ [=[Anduin Wrynn]=] ] = {
        byId = {
            [1648] = { 167833 },
        },
        byGroup = {
            [ [=[TheWarWithin]=] ] = { 249444 },
            [ [=[Midnight]=] ] = { 249444 },
        },
    },
    [ [=[Arator]=] ] = {   
        byId = {
            [2274] = { 250391 },
            [2537] = { 235523 },
            [2393] = { 235523 },
        },
    },
    [ [=[Lady Liadrin]=] ] = {
        byGroup = {
            [ [=[TheWarWithin]=] ] = { 236146 },
            [ [=[Midnight]=] ] = { 236146 },
        },
    },
    [ [=[Orweyna]=] ] = {
        byGroup = {
            [ [=[TheWarWithin]=] ] = { 236903 },
            [ [=[Midnight]=] ] = { 236903 },
        },
    },
    [ [=[Valeera Sanguinar]=] ] = {
        byGroup = {
            [ [=[TheWarWithin]=] ] = { 242381 },
            [ [=[Midnight]=] ] = { 242381 },
        },
    },
    [ [=[Alleria Windrunner]=] ] = {
        byGroup = {
            [ [=[TheWarWithin]=] ] = { 239826 },
            [ [=[Midnight]=] ] = { 239826 },
        },
    },
}
