-- ZoneGrouping.lua

-- Group zones to use the same the same NPC display ids

ZoneGrouping = {}
ZoneGrouping.byGroupName = {}
ZoneGrouping.byZoneName = {}

function ZoneGrouping:Initialize()
    for groupName, zones in pairs(self.byGroupName) do
        for zoneName, _ in pairs(zones) do
            self.byZoneName[zoneName] = groupName
        end
    end
end

function ZoneGrouping:GetGroupNameForZone(zoneName)
    return self.byZoneName[zoneName]
end


ZoneGrouping.byGroupName = { 
    [ [=[GROUP: Classic]=] ] = {
        [ [=[Elwynn Forest]=] ] = true,
        [ [=[Durotar]=] ] = true,
        [ [=[Mulgore]=] ] = true,
        [ [=[Teldrassil]=] ] = true,
        [ [=[Dun Morogh]=] ] = true,
        [ [=[Tirisfal Glades]=] ] = true,
        [ [=[Westfall]=] ] = true,
        [ [=[Redridge Mountains]=] ] = true,
        [ [=[Duskwood]=] ] = true,
        [ [=[Stranglethorn Vale]=] ] = true,
        [ [=[Badlands]=] ] = true,
        [ [=[Swamp of Sorrows]=] ] = true,
        [ [=[Blasted Lands]=] ] = true,
        [ [=[Burning Steppes]=] ] = true,
        [ [=[Searing Gorge]=] ] = true,
        [ [=[Deadwind Pass]=] ] = true,
        [ [=[Hillsbrad Foothills]=] ] = true,
        [ [=[Alterac Mountains]=] ] = true,
        [ [=[Arathi Highlands]=] ] = true,
        [ [=[Wetlands]=] ] = true,
        [ [=[Loch Modan]=] ] = true,
        [ [=[Darkshore]=] ] = true,
        [ [=[Ashenvale]=] ] = true,
        [ [=[Stonetalon Mountains]=] ] = true,
        [ [=[Desolace]=] ] = true,
        [ [=[Feralas]=] ] = true,
        [ [=[Dustwallow Marsh]=] ] = true,
        [ [=[Tanaris]=] ] = true,
        [ [=[Un'Goro Crater]=] ] = true,
        [ [=[Silithus]=] ] = true,
        [ [=[Winterspring]=] ] = true,
        [ [=[Felwood]=] ] = true,
        [ [=[Moonglade]=] ] = true,

        -- dungeons / raids
        [ [=[Deadmines]=] ] = true,
        [ [=[Shadowfang Keep]=] ] = true,
        [ [=[Blackfathom Deeps]=] ] = true,
        [ [=[Scarlet Monastery]=] ] = true,
        [ [=[Razorfen Downs]=] ] = true,
        [ [=[Razorfen Kraul]=] ] = true,
        [ [=[Zul'Farrak]=] ] = true,
        [ [=[Blackrock Depths]=] ] = true,
        [ [=[Blackrock Spire]=] ] = true,
        [ [=[Scholomance]=] ] = true,
        [ [=[Stratholme]=] ] = true,
        [ [=[Molten Core]=] ] = true,
        [ [=[Blackwing Lair]=] ] = true,
        [ [=[Temple of Ahn'Qiraj]=] ] = true,
        [ [=[Ruins of Ahn'Qiraj]=] ] = true,
        [ [=[Naxxramas]=] ] = true,
    },

    [ [=[GROUP: BurningCrusade]=] ] = {
        [ [=[Hellfire Peninsula]=] ] = true,
        [ [=[Zangarmarsh]=] ] = true,
        [ [=[Terokkar Forest]=] ] = true,
        [ [=[Nagrand]=] ] = true,
        [ [=[Blade's Edge Mountains]=] ] = true,
        [ [=[Netherstorm]=] ] = true,
        [ [=[Shadowmoon Valley]=] ] = true,

        -- dungeons
        [ [=[Hellfire Ramparts]=] ] = true,
        [ [=[The Blood Furnace]=] ] = true,
        [ [=[The Shattered Halls]=] ] = true,
        [ [=[The Slave Pens]=] ] = true,
        [ [=[The Underbog]=] ] = true,
        [ [=[The Steamvault]=] ] = true,
        [ [=[Mana-Tombs]=] ] = true,
        [ [=[Auchenai Crypts]=] ] = true,
        [ [=[Sethekk Halls]=] ] = true,
        [ [=[Shadow Labyrinth]=] ] = true,
        [ [=[Old Hillsbrad Foothills]=] ] = true,
        [ [=[The Black Morass]=] ] = true,
        [ [=[Magisters' Terrace]=] ] = true,

        -- raids
        [ [=[Karazhan]=] ] = true,
        [ [=[Gruul's Lair]=] ] = true,
        [ [=[Magtheridon's Lair]=] ] = true,
        [ [=[Serpentshrine Cavern]=] ] = true,
        [ [=[Tempest Keep]=] ] = true,
        [ [=[Black Temple]=] ] = true,
        [ [=[Sunwell Plateau]=] ] = true,
    },
    
    [ [=[GROUP: Wrath]=] ] = {
        [ [=[Borean Tundra]=] ] = true,
        [ [=[Howling Fjord]=] ] = true,
        [ [=[Dragonblight]=] ] = true,
        [ [=[Grizzly Hills]=] ] = true,
        [ [=[Zul'Drak]=] ] = true,
        [ [=[Sholazar Basin]=] ] = true,
        [ [=[Icecrown]=] ] = true,
        [ [=[The Storm Peaks]=] ] = true,

        -- dungeons
        [ [=[Utgarde Keep]=] ] = true,
        [ [=[Utgarde Pinnacle]=] ] = true,
        [ [=[The Nexus]=] ] = true,
        [ [=[The Oculus]=] ] = true,
        [ [=[Azjol-Nerub]=] ] = true,
        [ [=[Ahn'kahet: The Old Kingdom]=] ] = true,
        [ [=[Drak'Tharon Keep]=] ] = true,
        [ [=[Violet Hold]=] ] = true,
        [ [=[Gundrak]=] ] = true,
        [ [=[Halls of Lightning]=] ] = true,
        [ [=[Halls of Stone]=] ] = true,
        [ [=[Pit of Saron]=] ] = true,
        [ [=[Forge of Souls]=] ] = true,
        [ [=[Halls of Reflection]=] ] = true,

        -- raids
        [ [=[Naxxramas]=] ] = true,
        [ [=[The Obsidian Sanctum]=] ] = true,
        [ [=[The Eye of Eternity]=] ] = true,
        [ [=[Ulduar]=] ] = true,
        [ [=[Trial of the Crusader]=] ] = true,
        [ [=[Icecrown Citadel]=] ] = true,
    },

    [ [=[GROUP: Cataclysm]=] ] = {
        [ [=[Mount Hyjal]=] ] = true,
        [ [=[Vashj'ir]=] ] = true,
        [ [=[Deepholm]=] ] = true,
        [ [=[Uldum]=] ] = true,
        [ [=[Twilight Highlands]=] ] = true,

        [ [=[Blackrock Caverns]=] ] = true,
        [ [=[The Stonecore]=] ] = true,
        [ [=[Grim Batol]=] ] = true,
        [ [=[Halls of Origination]=] ] = true,
        [ [=[Lost City of the Tol'vir]=] ] = true,
        [ [=[Throne of the Tides]=] ] = true,

        [ [=[Bastion of Twilight]=] ] = true,
        [ [=[Blackwing Descent]=] ] = true,
        [ [=[Firelands]=] ] = true,
        [ [=[Dragon Soul]=] ] = true,
    },

    [ [=[GROUP: Mists]=] ] = {
        [ [=[The Jade Forest]=] ] = true,
        [ [=[Valley of the Four Winds]=] ] = true,
        [ [=[Kun-Lai Summit]=] ] = true,
        [ [=[Townlong Steppes]=] ] = true,
        [ [=[Dread Wastes]=] ] = true,
        [ [=[Krasarang Wilds]=] ] = true,

        [ [=[Temple of the Jade Serpent]=] ] = true,
        [ [=[Stormstout Brewery]=] ] = true,
        [ [=[Shado-Pan Monastery]=] ] = true,
        [ [=[Mogu'shan Palace]=] ] = true,

        [ [=[Mogu'shan Vaults]=] ] = true,
        [ [=[Heart of Fear]=] ] = true,
        [ [=[Terrace of Endless Spring]=] ] = true,
        [ [=[Siege of Orgrimmar]=] ] = true,
    },    

    [ [=[GROUP: Draenor]=] ] = {
        [ [=[Frostfire Ridge]=] ] = true,
        [ [=[Shadowmoon Valley]=] ] = true,
        [ [=[Gorgrond]=] ] = true,
        [ [=[Talador]=] ] = true,
        [ [=[Spires of Arak]=] ] = true,
        [ [=[Nagrand]=] ] = true,

        [ [=[Bloodmaul Slag Mines]=] ] = true,
        [ [=[Shadowmoon Burial Grounds]=] ] = true,
        [ [=[Iron Docks]=] ] = true,
        [ [=[Auchindoun]=] ] = true,
        [ [=[Grimrail Depot]=] ] = true,

        [ [=[Highmaul]=] ] = true,
        [ [=[Blackrock Foundry]=] ] = true,
        [ [=[Hellfire Citadel]=] ] = true,
    },    

    [ [=[GROUP: Legion]=] ] = {
        [ [=[Azsuna]=] ] = true,
        [ [=[Val'sharah]=] ] = true,
        [ [=[Highmountain]=] ] = true,
        [ [=[Stormheim]=] ] = true,
        [ [=[Suramar]=] ] = true,

        [ [=[Eye of Azshara]=] ] = true,
        [ [=[Darkheart Thicket]=] ] = true,
        [ [=[Black Rook Hold]=] ] = true,
        [ [=[Halls of Valor]=] ] = true,
        [ [=[Vault of the Wardens]=] ] = true,
        [ [=[Court of Stars]=] ] = true,

        [ [=[The Emerald Nightmare]=] ] = true,
        [ [=[Trial of Valor]=] ] = true,
        [ [=[The Nighthold]=] ] = true,
        [ [=[Tomb of Sargeras]=] ] = true,
        [ [=[Antorus, the Burning Throne]=] ] = true,
    },    

    [ [=[GROUP: BFA]=] ] = {
        [ [=[Tiragarde Sound]=] ] = true,
        [ [=[Drustvar]=] ] = true,
        [ [=[Stormsong Valley]=] ] = true,
        [ [=[Nazmir]=] ] = true,
        [ [=[Vol'dun]=] ] = true,
        [ [=[Zuldazar]=] ] = true,
        [ [=[Nazjatar]=] ] = true,

        [ [=[Freehold]=] ] = true,
        [ [=[Atal'Dazar]=] ] = true,
        [ [=[Waycrest Manor]=] ] = true,
        [ [=[The Underrot]=] ] = true,
        [ [=[Tol Dagor]=] ] = true,
        [ [=[King's Rest]=] ] = true,

        [ [=[Uldir]=] ] = true,
        [ [=[Battle of Dazar'alor]=] ] = true,
        [ [=[The Eternal Palace]=] ] = true,
        [ [=[Ny'alotha, the Waking City]=] ] = true,
    },  
    
    [ [=[GROUP: Shadowlands]=] ] = {
        [ [=[Bastion]=] ] = true,
        [ [=[Maldraxxus]=] ] = true,
        [ [=[Ardenweald]=] ] = true,
        [ [=[Revendreth]=] ] = true,
        [ [=[Zereth Mortis]=] ] = true,

        [ [=[The Necrotic Wake]=] ] = true,
        [ [=[Plaguefall]=] ] = true,
        [ [=[Mists of Tirna Scithe]=] ] = true,
        [ [=[Halls of Atonement]=] ] = true,
        [ [=[Theater of Pain]=] ] = true,
        [ [=[De Other Side]=] ] = true,
        [ [=[Spires of Ascension]=] ] = true,

        [ [=[Castle Nathria]=] ] = true,
        [ [=[Sanctum of Domination]=] ] = true,
        [ [=[Sepulcher of the First Ones]=] ] = true,
    },

    [ [=[GROUP: Dragonflight]=] ] = {
        [ [=[The Waking Shores]=] ] = true,
        [ [=[Ohn'ahran Plains]=] ] = true,
        [ [=[Azure Span]=] ] = true,
        [ [=[Thaldraszus]=] ] = true,
        [ [=[The Forbidden Reach]=] ] = true,
        [ [=[Zaralek Cavern]=] ] = true,
        [ [=[Emerald Dream]=] ] = true,

        [ [=[Ruby Life Pools]=] ] = true,
        [ [=[The Nokhud Offensive]=] ] = true,
        [ [=[Brackenhide Hollow]=] ] = true,
        [ [=[Halls of Infusion]=] ] = true,
        [ [=[Neltharus]=] ] = true,
        [ [=[Uldaman: Legacy of Tyr]=] ] = true,

        [ [=[Vault of the Incarnates]=] ] = true,
        [ [=[Aberrus, the Shadowed Crucible]=] ] = true,
        [ [=[Amirdrassil, the Dream's Hope]=] ] = true,
    },

    [ [=[GROUP: TheWarWithin]=] ] = {

        -- zones
        [ [=[Isle of Dorn]=] ] = true,
        [ [=[The Ringing Deeps]=] ] = true,
        [ [=[Hallowfall]=] ] = true,
        [ [=[Azj-Kahet]=] ] = true,

        -- cities
        [ [=[Dornogal]=] ] = true,
        [ [=[City of Threads]=] ] = true,

        -- dungeons
        [ [=[The Stonevault]=] ] = true,
        [ [=[The Dawnbreaker]=] ] = true,
        [ [=[Darkflame Cleft]=] ] = true,
        [ [=[Ara-Kara, City of Echoes]=] ] = true,
        [ [=[Priory of the Sacred Flame]=] ] = true,

        -- raid
        [ [=[Nerub-ar Palace]=] ] = true,

        -- delves
        [ [=[Earthcrawl Mines]=] ] = true,
        [ [=[Fungal Folly]=] ] = true,
        [ [=[Kriegval's Rest]=] ] = true,
        [ [=[Nightfall Sanctum]=] ] = true,
        [ [=[Skittering Breach]=] ] = true,
        [ [=[The Spiral Weave]=] ] = true,
        [ [=[The Underkeep]=] ] = true,
        [ [=[Waterworks]=] ] = true,
    }, 

    [ [=[GROUP: Midnight]=] ] = {
        [ [=[Isle of Quel'Danes]=] ] = true,
        [ [=[Eversong Woods]=] ] = true,
        [ [=[Zul'Aman]=] ] = true,
        [ [=[Voidstorm]=] ] = true,
        [ [=[Light's Hope Chapel]=] ] = true,
        [ [=[Scarlet Halls]=] ] = true,
        [ [=[Burning Steppes]=] ] = true,
    },
}