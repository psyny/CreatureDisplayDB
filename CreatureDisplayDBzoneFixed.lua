-- CreatureDisplayDBzoneFixed.lua

-- Fixed ids is a workaround to overcome the problem that sometimes the NPCID for an specific zone needs to be a fixed id.
-- the structure is [zone name][zone id][npc name] = npc id
-- zone id can be zero, so it will be the value for every zone id in the zone name

CreatureDisplayDBzoneFixed = {}
CreatureDisplayDBzoneFixed.byZoneName = {}

CreatureDisplayDBzoneFixed.byZoneName = { 
    [ [=[The Maw]=] ] = {
        [0] = {
            [ [=[Thrall]=] ] = 166981,
            [ [=[Lady Jaina Proudmoore]=] ] = 166980,
            [ [=[Baine Bloodhoof]=] ] = 168162,
            [ [=[The Jailer]=] ] = 165539,   
        },
        [1648] = {        
            [ [=[Anduin Wrynn]=] ] = 167833,      
        }
    },
    [ [=[Isle of Quel'Danas]=] ] = {
        [0] = {
            [ [=[Arator]=] ] = 250391,
        },
    },      
    [ [=[Eversong Woods]=] ] = {
        [0] = {
            [ [=[Arator]=] ] = 250391,
            [ [=[Orweyna]=] ] = 236903,            
        },
    }, 
    [ [=[Zul'Aman]=] ] = {
        [0] = {
            [ [=[Lady Liadrin]=] ] = 236146,          
        },
    },      
}


