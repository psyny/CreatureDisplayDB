-- CreatureDisplayDBcmd.lua

local modelFrame = nil

local function DisplayModel(ids, isDisplayId)
    print ("Attempt to display: " .. #ids .. " ids")

    if modelFrame  then
        modelFrame:Hide()
    end
    
    -- Create the model frame
    modelFrame = CreateFrame("PlayerModel", nil, UIParent, "BackdropTemplate")
    modelFrame:SetSize(400, 400)
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

            local success = pcall(function() modelFrame:SetCustomCamera(1) end)  -- Attempt to modify the camera
            if not success then
                print("Camera adjust failed. Maybe the model is blank")
            end     
            
            modelFrame:SetAnimation(0)
            success = pcall(function() modelFrame:RefreshModel() end)
            if not success then
                print("Animation adjust failed. Maybe the model is blank")
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


local isPaused = true
local function ModelExplorer()
    -- Main frame
    local frame = CreateFrame("Frame", "Model Explorer", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(700, 500)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetFrameStrata("TOOLTIP")
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    frame.title:SetPoint("TOP", 0, -10)
    frame.title:SetText("Model and Lighting Testing")

    -- Model frame
    local modelFrame = CreateFrame("PlayerModel", nil, frame, "BackdropTemplate")
    modelFrame:SetSize(400, 400)
    modelFrame:SetPoint("CENTER", frame, "CENTER", 0, 0)
    modelFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    modelFrame:SetBackdropColor(0, 0, 0, 1)

    -- Function to create labeled input boxes
    local function CreateInputField(parent, label, defaultVal, left, large, xOffset, yOffset)
        local container = CreateFrame("Frame", nil, parent)
        container:SetSize(100, 30)

        if left then
            container:SetPoint("TOPLEFT", xOffset, yOffset)
        else
            container:SetPoint("TOPRIGHT", -xOffset, yOffset)
        end        

        local text = container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetText(label)
        if left then
            text:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
        else
            text:SetPoint("TOPRIGHT", container, "TOPRIGHT", 0, 0)
        end             

        local inputBox = CreateFrame("EditBox", nil, container, "InputBoxTemplate")
        inputBox:SetSize(50, 20)
        if left then
            inputBox:SetPoint("TOPLEFT", container, "TOPLEFT", 0, -10)
        else
            inputBox:SetPoint("TOPRIGHT", container, "TOPRIGHT", 0, -10)
        end          
        inputBox:SetText(defaultVal)
        inputBox:SetAutoFocus(true)
        --inputBox:SetNumeric(true)

        if large then
            inputBox:SetSize(80, 20)
        else
            inputBox:SetSize(30, 20)
        end

        -- Allow only valid float characters (digits, a single period, optional negative sign)
        inputBox:SetScript("OnTextChanged", function(self, userInput)
            if userInput then
                local text = self:GetText()
                if not string.match(text, "^-?%d*%.?%d*$") then
                    self:SetText(string.match(text, "^-?%d*%.?%d*"))
                    self:ClearFocus()
                end
            end
        end)        

        return inputBox
    end

    -- Left side input fields
    local modelIDBox = CreateInputField(frame, "Model ID:", 0, true, true, 10, -20)
    local displayIDBox = CreateInputField(frame, "Display ID:", 0, true, true, 10, -60)
    local portraitZoomBox = CreateInputField(frame, "Portrait Zoom:", 0, true, false, 10, -100)
    local animationIDBox = CreateInputField(frame, "Animation ID:", 0, true, false, 10, -140)
    local scaleBox  = CreateInputField(frame, "Scale:", 1, true, false, 10, -180)
    local posXBox  = CreateInputField(frame, "Pos X:", 0, true, false, 10, -220)

    -- Right side input fields
    local lightOnBox = CreateInputField(frame, "Light On:", 1, false, false, 10, -20)
    local lightXBox = CreateInputField(frame, "", -1, false, false, 90, -60)
    local lightYBox = CreateInputField(frame, "", 1, false, false, 50, -60)
    local lightZBox = CreateInputField(frame, "Light X,Y,Z:", -1, false, false, 10, -60)
    local ambientIntensityBox = CreateInputField(frame, "Ambient Intensity:", 1, false, false, 10, -100)
    local ambientRBox = CreateInputField(frame, "", 0.5, false, false, 90, -140)
    local ambientGBox = CreateInputField(frame, "", 0.5, false, false, 50, -140)
    local ambientBBox = CreateInputField(frame, "Ambient R,G,B:", 0.5, false, false, 10, -140)
    local diffuseIntensityBox = CreateInputField(frame, "Diffuse Intensity:", 1, false, false, 10, -180)
    local diffuseRBox = CreateInputField(frame, "", 0.5, false, false, 90, -220)
    local diffuseGBox = CreateInputField(frame, "", 0.5, false, false, 50, -220)
    local diffuseBBox = CreateInputField(frame, "Diffuse R,G,B:", 0.5, false, false, 10, -220)

    -- Collect values from input boxes
    local function CollectModelExplorerValues()
        return {
            modelID = tonumber(modelIDBox:GetText()),
            displayID = tonumber(displayIDBox:GetText()),
            portraitZoom = tonumber(portraitZoomBox:GetText()) or 0,
            animationID = tonumber(animationIDBox:GetText()) or 0,
            scale = tonumber(scaleBox:GetText()) or 1,
            posX = tonumber(posXBox:GetText()) or 0,
            lightOn = tonumber(lightOnBox:GetText()) or 0,
            lightX = tonumber(lightXBox:GetText()) or -1,
            lightY = tonumber(lightYBox:GetText()) or 1,
            lightZ = tonumber(lightZBox:GetText()) or -1,
            ambientIntensity = tonumber(ambientIntensityBox:GetText()) or 1,
            ambientR = tonumber(ambientRBox:GetText()) or 0.5,
            ambientG = tonumber(ambientGBox:GetText()) or 0.5,
            ambientB = tonumber(ambientBBox:GetText()) or 0.5,
            diffuseIntensity = tonumber(diffuseIntensityBox:GetText()) or 1,
            diffuseR = tonumber(diffuseRBox:GetText()) or 0.5,
            diffuseG = tonumber(diffuseGBox:GetText()) or 0.5,
            diffuseB = tonumber(diffuseBBox:GetText()) or 0.5,
        }
    end

    local function UpdateModelExplorerModel()
        local modelFrameValues = CollectModelExplorerValues()

        -- Base Data
        local isNpcId = false
        local creatureId = 0
        local hasId = false

        if modelFrameValues.modelID and modelFrameValues.modelID > 0 then
            isNpcId = true
            hasId = true
            creatureId = modelFrameValues.modelID
        else
            if modelFrameValues.displayID and modelFrameValues.displayID > 0 then
                isNpcId = false
                hasId = true
                creatureId = modelFrameValues.displayID
            end
        end

        -- Set
        if hasId then
            modelFrame:ClearModel()
            modelFrame:SetModelScale(1.0)
            if isNpcId then        
                modelFrame:SetCreature(creatureId)                        
            else
                modelFrame:SetDisplayInfo(creatureId)
            end

            print("Model Started Load: " .. GetTime())
            modelFrame:SetScript("OnModelLoaded", function(self)
                local lmodelFrameValues = modelFrameValues

                -- Zoom, anim
                if lmodelFrameValues.portraitZoom then
                    modelFrame:SetPortraitZoom(lmodelFrameValues.portraitZoom)
                end

                if lmodelFrameValues.animationID then
                    modelFrame:SetAnimation(lmodelFrameValues.animationID)
                end        

                if lmodelFrameValues.scale then
                    modelFrame:SetModelScale(lmodelFrameValues.scale)
                end        

                if lmodelFrameValues.posX then
                    modelFrame:SetPosition(lmodelFrameValues.posX, 0 , 0)
                end                      

                -- Light
                if lmodelFrameValues.lightOn > 0 then
                    local light = {
                        omnidirectional = false,
                        point = CreateVector3D(lmodelFrameValues.lightX, lmodelFrameValues.lightY, lmodelFrameValues.lightZ), -- X: 1: behind model, -1: direct  front  | Y: 1: from left,  -1: from right | Z: 1: below,  -1: above
                        ambientIntensity = lmodelFrameValues.ambientIntensity,
                        ambientColor = CreateColor(lmodelFrameValues.ambientR, lmodelFrameValues.ambientG, lmodelFrameValues.ambientB),
                        diffuseIntensity = lmodelFrameValues.diffuseIntensity,
                        diffuseColor = CreateColor(lmodelFrameValues.diffuseR, lmodelFrameValues.diffuseG, lmodelFrameValues.diffuseB),
                    }

                    modelFrame:SetLight(true, light) -- Dim light        
                end

                -- Paused
                modelFrame:SetPaused(isPaused) 
            end)            
        end
    end

    -- Update button
    local updateButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    updateButton:SetSize(100, 30)
    updateButton:SetPoint("BOTTOM", 0, 10)
    updateButton:SetText("Update")
    updateButton:SetScript("OnClick", function()
        local inputValues = UpdateModelExplorerModel()
    end)

    -- Play button
    local playButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    playButton:SetSize(100, 30)
    playButton:SetPoint("BOTTOMLEFT", 0, 10)
    playButton:SetText("Toggle Animation")
    playButton:SetScript("OnClick", function()
        isPaused = not isPaused
        modelFrame:SetPaused(isPaused) 
    end)    

    -- Light Presets
    local function SetLightPreset(lightPreset)
        lightOnBox:SetText(lightPreset.lightOn)
        lightXBox:SetText(lightPreset.lightX)
        lightYBox:SetText(lightPreset.lightY)
        lightZBox:SetText(lightPreset.lightZ)

        ambientIntensityBox:SetText(lightPreset.ambientIntensity)
        ambientRBox:SetText(lightPreset.ambientR)
        ambientGBox:SetText(lightPreset.ambientG)        
        ambientBBox:SetText(lightPreset.ambientB)     

        diffuseIntensityBox:SetText(lightPreset.diffuseIntensity)
        diffuseRBox:SetText(lightPreset.diffuseR)
        diffuseGBox:SetText(lightPreset.diffuseG)        
        diffuseBBox:SetText(lightPreset.diffuseB)    

        UpdateModelExplorerModel()
    end

    local preset0Button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    preset0Button:SetSize(100, 30)
    preset0Button:SetPoint("BOTTOMRIGHT", -10, 10)
    preset0Button:SetText("Light Preset 0")
    preset0Button:SetScript("OnClick", function()
        local lightPreset = {
            lightOn = 1,
            lightX = -1.0,
            lightY = 1.0,
            lightZ = -1.0,

            ambientIntensity = 1,
            ambientR = 0.5,
            ambientG = 0.5,
            ambientB = 0.5,

            diffuseIntensity = 1,
            diffuseR = 0.5,
            diffuseG = 0.5,
            diffuseB = 0.5,
        }
        SetLightPreset(lightPreset)
    end)    

    local preset1Button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    preset1Button:SetSize(100, 30)
    preset1Button:SetPoint("BOTTOMRIGHT", -10, 40)
    preset1Button:SetText("Light Preset 1")
    preset1Button:SetScript("OnClick", function()
        local lightPreset = {
            lightOn = 1,
            lightX = -1.0,
            lightY = 1.0,
            lightZ = -1.0,

            ambientIntensity = 1,
            ambientR = 0.5,
            ambientG = 0.5,
            ambientB = 0.6,

            diffuseIntensity = 1,
            diffuseR = 0.6,
            diffuseG = 0.6,
            diffuseB = 0.5,
        }
        SetLightPreset(lightPreset)
    end)    
    
    local preset2Button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    preset2Button:SetSize(100, 30)
    preset2Button:SetPoint("BOTTOMRIGHT", -10, 70)
    preset2Button:SetText("Light Preset 2")
    preset2Button:SetScript("OnClick", function()
        local lightPreset = {
            lightOn = 1,
            lightX = -1.0,
            lightY = 1.0,
            lightZ = -1.0,

            ambientIntensity = 1,
            ambientR = 0.5,
            ambientG = 0.5,
            ambientB = 0.6,

            diffuseIntensity = 1,
            diffuseR = 0.6,
            diffuseG = 0.5,
            diffuseB = 0.5,
        }
        SetLightPreset(lightPreset)
    end)         
    
    local preset3Button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    preset3Button:SetSize(100, 30)
    preset3Button:SetPoint("BOTTOMRIGHT", -10, 100)
    preset3Button:SetText("Light Preset 3")
    preset3Button:SetScript("OnClick", function()
        local lightPreset = {
            lightOn = 1,
            lightX = -1.0,
            lightY = 1.0,
            lightZ = -1.0,

            ambientIntensity = 1,
            ambientR = 0.5,
            ambientG = 0.5,
            ambientB = 0.6,

            diffuseIntensity = 1,
            diffuseR = 0.6,
            diffuseG = 0.3,
            diffuseB = 0.3,
        }
        SetLightPreset(lightPreset)
    end)  
    
    local preset4Button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    preset4Button:SetSize(100, 30)
    preset4Button:SetPoint("BOTTOMRIGHT", -10, 130)
    preset4Button:SetText("Light Preset 4")
    preset4Button:SetScript("OnClick", function()
        local lightPreset = {
            lightOn = 1,
            lightX = -1.0,
            lightY = 1.0,
            lightZ = -1.0,

            ambientIntensity = 1,
            ambientR = 0.5,
            ambientG = 0.5,
            ambientB = 0.6,

            diffuseIntensity = 1,
            diffuseR = 0.1,
            diffuseG = 0.2,
            diffuseB = 0.3,
        }
        SetLightPreset(lightPreset)
    end)     

    return frame
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

-- Show creature model by displayid
SLASH_CreatureDisplayDBModelExplorer1 = "/CreatureDisplayDBModelExplorer"
SlashCmdList["CreatureDisplayDBModelExplorer"] = function()
    ModelExplorer()
end