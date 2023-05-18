-- Create the addon frame
Gui = {}

local addonFrame = CreateFrame("Frame", "DinkinsDKPAddonFrame", UIParent)
addonFrame:SetSize(300, 400)
addonFrame:SetPoint("CENTER")
addonFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
})
addonFrame:SetBackdropColor(0, 0, 0, 0.8)
addonFrame:SetMovable(true)
addonFrame:EnableMouse(true)
addonFrame:RegisterForDrag("LeftButton")
addonFrame:SetScript("OnDragStart", addonFrame.StartMoving)
addonFrame:SetScript("OnDragStop", addonFrame.StopMovingOrSizing)
addonFrame:Hide()

-- Path to MP3 file
local soundFilePath = "Interface\\Addons\\DinkinsDKP\\questing.mp3"

-- Function to play the sound
local function PlaySoundOnShow()
    PlaySoundFile(soundFilePath, "Master")
end

-- Show the GUI
function ShowGUI()
    addonFrame:Show()
    PlaySoundOnShow()
end


-- Create the title
local title = addonFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -16)
title:SetText("DINKINS KINDNESS POINTS!!!")
title:SetFont("Fonts\\ARIALN.TTF", 20, "OUTLINE")

-- Create the leaderboard scroll frame
local scrollFrame = CreateFrame("ScrollFrame", "DinkinsDKPScrollFrame", addonFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(250, 300)
scrollFrame:SetPoint("TOP", title, "BOTTOM", 0, -16)

-- Create the leaderboard content
local leaderboard = CreateFrame("Frame", "DinkinsDKPLeaderboard", scrollFrame)
leaderboard:SetSize(250, 300)

-- Animation variables
local animationTimer = 0
local animationSpeed = 2
local animationOffset = 5

-- Populate the leaderboard with data from the dkpTable
local dkpTable = {
    { name = "Dinkins", dkp = 300, nameText = nil },
    { name = "Theban", dkp = 200, nameText = nil },
    { name = "Pneucrusader", dkp = 150, nameText = nil },
    -- !!!! This can be removed and referenced with the actual DKP table once this is all strung up !!!
}

local yOffset = 0
local rowHeight = 20
for i, data in ipairs(dkpTable) do
    local nameText = leaderboard:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    nameText:SetPoint("TOPLEFT", 8, -yOffset)
    nameText:SetText(data.name)
    data.nameText = nameText  -- Store the nameText in the data table

    local dkpText = leaderboard:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    dkpText:SetPoint("TOPRIGHT", -8, -yOffset)
    dkpText:SetText(data.dkp)

    yOffset = yOffset + rowHeight
end

scrollFrame:SetScrollChild(leaderboard)

-- Register slash commands to show/hide the GUI Note: Commented out. Redundant I believe when called in DinkinsDKP.lua
-- SLASH_DKPGUI1 = "/dkp"
-- SLASH_DKPGUI2 = "/dinkinsdkp"
-- SlashCmdList["DKPGUI"] = function()
--    if addonFrame:IsShown() then
--        addonFrame:Hide()
--    else
--        addonFrame:Show()
--    end
--end

-- Start the animation
local originalY = {}
local function StartAnimation()
    for i, data in ipairs(dkpTable) do
        originalY[i] = data.nameText:GetPoint(2)
    end
    
    addonFrame:SetScript("OnUpdate", function(self, elapsed)
        animationTimer = animationTimer + elapsed
        for i, data in ipairs(dkpTable) do
            local yOffset = originalY[i] + math.sin(animationTimer * animationSpeed) * animationOffset
            data.nameText:SetPoint("TOPLEFT", 8, -yOffset)
        end
    end)
end

-- Stop the animation
local function StopAnimation()
    addonFrame:SetScript("OnUpdate", nil)
end

-- Hook the show/hide events to start/stop the animation
addonFrame:SetScript("OnShow", StartAnimation)
addonFrame:SetScript("OnHide", StopAnimation)
