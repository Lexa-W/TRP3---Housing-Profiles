local TRP3_HOUSE_BASEFRAME = CreateFrame("FRAME", "TRP3_HOUSE_BASEFRAME")
local plotId_Base = "Housing-4-2-0-3F0A023"
local addon = {}
TRP3_HOUSE_BASEFRAME:RegisterEvent("CURRENT_HOUSE_INFO_RECIEVED")
TRP3_HOUSE_BASEFRAME:RegisterEvent("OPEN_PLOT_CORNERSTONE")
TRP3_HOUSE_BASEFRAME:RegisterEvent("UI_ERROR_MESSAGE")
local test = false

local function UpdateFrameSize(f)
    local textHeight = 35
    -- Deal with widths and word wraps
    -- Width is always 375 - 350 + 20 padding
    f.ErrorMessage:SetWidth(350)
    f.ErrorMessage:SetWordWrap(true)
    print(f.ErrorMessage:GetStringHeight())
    if f.ErrorMessage:GetStringHeight() > 13 then
        -- If over one line, then add 20 to the height for padding
        textHeight = f.ErrorMessage:GetStringHeight() + 20
    end
    local regions = {f:GetRegions()}
    -- Center everything to the main frame & deal with height
    for _, region in ipairs(regions) do
        if region:IsObjectType("Texture") then
            region:SetHeight(textHeight)
            region:SetWidth(375)
            region:SetPoint("CENTER", f)
        end
    end
end
local function _CreateTexture(parentFrame, frameName, atlasString,drawLayer, height, width, point)
    local tex = parentFrame:CreateTexture(frameName, drawLayer)
    tex:SetPoint(point,f)
    tex:SetAtlas(atlasString, true)
    tex:SetSize(width, height)
end

-- Convenient function to bundle it all up here
local function PresentError(error)
    local f = CreateFrame("Frame", "HouseEntryDeclinedFrame")
    f:SetParent(UIErrorsFrame)
    f:SetSize(200, 50)
    f:SetPoint("TOP", UIErrorsFrame, "BOTTOM", 0, -10)
    -- prettify the frame
    _CreateTexture(f,"HouseEntryDeclinedFrameBorder","housing-wood-frame", "BORDER",0,0,"CENTER")
    _CreateTexture(f,"HouseEntryDeclinedFrameBG","housing-basic-panel-footer", "BACKGROUND",0,0,"CENTER")
    _CreateTexture(f,"HouseEntryDeclinedFrameArtwork","housing-basic-panel-gradient-header-bg","ARTWORK",0,0,"CENTER")
    f.ErrorMessage = f:CreateFontString("HouseEntryDeclinedFrameReason", "OVERLAY", "Game13FontShadow")
    f.ErrorMessage:SetPoint("CENTER")
    f.ErrorMessage:SetText(error)
    -- Update frame textures to accomodate dynamic text
    UpdateFrameSize(f)
    -- Animate in and out
    UIFrameFadeIn(f, 0.5, 0, 1)
    C_Timer.NewTimer(
        5,
        function()
            UIFrameFadeOut(f, 1, 1, 0)
        end
    )
end

local function setHouseName(name)
    addon["replacementName"] = name
end
local function updateName()
    HousingControlsFrame.VisitorControlFrame.OwnerNameText:SetText(addon["replacementName"])
    HousingControlsFrame.VisitorControlFrame.OwnerNameText:SetWidth(0)
    if test == true then
        HousingControlsFrame.VisitorControlFrame.VisitorInspectorButton:Hide()
        HousingControlsFrame.VisitorControlFrame.VisitorHouseInfoButton:Hide()
        HousingControlsFrame.VisitorControlFrame.VisitorExitButton:Hide()
    end
end

local function eventHandler(self, event, ...)
    local variables = ...
    if event == "CURRENT_HOUSE_INFO_RECIEVED" then
        --
        local testString = variables["neighborhoodGUID"] .. variables["plotID"]
        for i, v in pairs(variables) do
            print(i, v)
        end
        -- if testString == plotId_Base then
        -- We just set the variable here. The Hook above handles the rest.
        addon["replacementName"] = "The Slaughtered Donkey"
        setHouseName(addon["replacementName"])
        C_Timer.NewTimer(
            1.5,
            function()
                updateName()
            end,
            8
        )
    elseif event == "OPEN_PLOT_CORNERSTONE" then
        HousingCornerstoneVisitorFrame.HouseNameText:SetText("The Slaughtered Donkey")
        HousingCornerstoneVisitorFrame.OwnerText:SetText("Siranorae")
        HousingCornerstoneVisitorFrame.NeighborhoodLabel:SetText("Opening Hours: \n\nStatus: ")
        HousingCornerstoneVisitorFrame.NeighborhoodText:SetText("5pm-12am\n\nPublic")
        HousingCornerstoneVisitorFrame.NeighborhoodText:SetWidth(0)
        HousingCornerstoneVisitorFrame.PlotText:SetText("33 Nightshade Hollow")
    elseif event == "UI_ERROR_MESSAGE" then
        local number = variables
        if number == 1218 then
            UIErrorsFrame:Clear()
            PresentError(
                "No orgie"
            )
        end
    end
end
TRP3_HOUSE_BASEFRAME:SetScript("OnEvent", eventHandler)
