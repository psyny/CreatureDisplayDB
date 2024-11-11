-- CreatureDisplayDBcmd.lua

local modelFrame = nil

local function DisplayModel(ids, isDisplayId)
    print ("Attempt to display: " .. #ids .. " ids")

    if modelFrame  then
        modelFrame:Hide()
    end
    
    -- Create the model frame
    modelFrame = CreateFrame("PlayerModel", nil, UIParent, "BackdropTemplate")
    modelFrame:SetSize(300, 300)
    modelFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    modelFrame:SetBackdropColor(0, 0, 0, 0.95)

    modelFrame:SetFrameStrata("TOOLTIP")
    modelFrame:SetMovable(true)
    modelFrame:EnableMouse(true)     
    modelFrame:SetPoint("TOP", UIParent, "TOP", 0, 0)

    if isDisplayId then       
        for _, displayId in ipairs(ids) do
            modelFrame:ClearModel()
            modelFrame:SetDisplayInfo(displayId)

            local resultingDisplayId = modelFrame:GetDisplayInfo()
            if resultingDisplayId and resultingDisplayId > 0 then
                print ("resultingDisplayId: " .. resultingDisplayId .. " for display id: " .. displayId) 
            end

            local resultingFileId = modelFrame:GetModelFileID()
            if resultingFileId and resultingFileId > 0 then
                print ("resultingFileId: " .. resultingFileId .. " for display id: " .. displayId) 
                break  
            end
        end        
    else
        -- Multiple NPC ids            
        for _, modelId in ipairs(ids) do
            modelFrame:ClearModel()
            modelFrame:SetCreature(modelId)

            local resultingDisplayId = modelFrame:GetDisplayInfo()
            if resultingDisplayId and resultingDisplayId > 0 then
                print ("resultingDisplayId: " .. resultingDisplayId .. " for npc id: " .. modelId) 
            end

            local resultingFileId = modelFrame:GetModelFileID()
            if resultingFileId and resultingFileId > 0 then
                print ("resultingFileId: " .. resultingFileId .. " for npc id: " .. modelId) 
                break  
            end
        end
    end

    -- Close Button
    local closeButton = CreateFrame("Button", nil, modelFrame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", modelFrame, "TOPRIGHT", 0, 0)

    modelFrame:Show()
end


-- Target NPC Display Info
SLASH_CreatureDisplayDBTargetInfo1 = "/CreatureDisplayDBTargetInfo"
SlashCmdList["CreatureDisplayDBTargetInfo"] = function()   
    local unittoken = "target"
    local creatureName = ""
    local creatureServer = ""
    local guid = ""
    local creatureId = ""
    local zoneName = GetZoneText()
    local zoneID = C_Map.GetBestMapForUnit("player") 

    if UnitExists(unittoken) then
        creatureName, creatureServer = UnitName(unittoken)
        guid = UnitGUID(unittoken)
        if guid ~= "" then
            creatureId = tonumber(guid:match("[Creature|Vehicle|Pet|Vignette|Instance]%-.-%-.-%-.-%-.-%-(%d+)"))
        end
    end

    print("[TARGET INFO]")
    print("Name: " .. (creatureName or ""))
    print("Server: " .. (creatureServer or ""))
    print("ID: " .. (creatureId or ""))
    print("GUID: " .. (guid or ""))
    print("Zone Name: " .. (zoneName or ""))
    print("Zone ID: " .. (zoneID or ""))
end


-- Show creature model (npcid) by name
SLASH_CreatureDisplayDBViewNpcIdByName1 = "/CreatureDisplayDBViewNpcIdByName"
SlashCmdList["CreatureDisplayDBViewNpcIdByName"] = function(creatureName)
    local npcIds = CreatureDisplayDB:GetNpcIdsByName(creatureName)
    if not npcIds then
        print("CREATURE NOT FOUND: " .. creatureName)
        return
    end

    DisplayModel(npcIds, false)
end

-- Show creature model (displayid) by name
SLASH_CreatureDisplayDBViewDisplayIdByName1 = "/CreatureDisplayDBViewDisplayIdByName"
SlashCmdList["CreatureDisplayDBViewDisplayIdByName"] = function(creatureName)
    local displayIds = CreatureDisplayDB:GetDisplayIdsByName(creatureName)
    if not displayIds then
        print("CREATURE NOT FOUND: " .. creatureName)
        return
    end

    DisplayModel(displayIds, true)
end

-- Show creature model by ncpid
SLASH_CreatureDisplayDBViewNpcId1 = "/CreatureDisplayDBViewNpcId"
SlashCmdList["CreatureDisplayDBViewNpcId"] = function(npcId)
    DisplayModel({npcId}, false)
end

-- Show creature model by displayid
SLASH_CreatureDisplayDBViewDisplayId1 = "/CreatureDisplayDBViewDisplayId"
SlashCmdList["CreatureDisplayDBViewDisplayId"] = function(displayId)
    DisplayModel({displayId}, true)
end