-- Create the addon frame
Gui = {}

local addonFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
addonFrame:SetSize(300, 400)
addonFrame:SetPoint("CENTER")
addonFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = {
        left = 4,
        right = 4,
        top = 4,
        bottom = 4
    }
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
local function ShowGUI()
    addonFrame:Show()
    PlaySoundOnShow()
end

-- Create the title
local title = addonFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -16)
title:SetText("DINKINS KINDNESS POINTS!!!")
title:SetFont("Fonts\\ARIALN.TTF", 20, "OUTLINE")

-- Create the image
local image = addonFrame:CreateTexture(nil, "ARTWORK")
image:SetTexture("Interface\\Addons\\DinkinsDKP\\dinkinsdkp.png")
image:SetPoint("TOP", addonFrame, "TOP", 0, -50)
image:SetSize(addonFrame:GetWidth() - 40, 100)

-- Create the leaderboard scroll frame
local scrollFrame = CreateFrame("ScrollFrame", "DinkinsDKPScrollFrame", addonFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(250, 300)
scrollFrame:SetPoint("TOP", image, "BOTTOM", 0, -16)

-- Create the leaderboard content
local leaderboard = CreateFrame("Frame", "DinkinsDKPLeaderboard", scrollFrame)
leaderboard:SetSize(250, 300)
leaderboard:RegisterEvent("ADDON_LOADED")

-- Show the GUI
function Gui.ShowGUI()
    -- Populate the leaderboard with data from the dkpTable
    local yOffset = 0
    local rowHeight = 20

    if Table.DinkinsDKPDB ~= nil then
        for playerName, dkp in pairs(Table.DinkinsDKPDB) do
            local nameText = leaderboard:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            nameText:SetPoint("TOPLEFT", 8, -yOffset)
            nameText:SetText(playerName)

            local dkpText = leaderboard:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            dkpText:SetPoint("TOPRIGHT", -8, -yOffset)
            dkpText:SetText(dkp)

            yOffset = yOffset + rowHeight
        end

        scrollFrame:SetScrollChild(leaderboard)
    end

    addonFrame:Show()
    PlaySoundOnShow()
end

-- Initialize local table with either WoW Saved Variable or default
local function eventHandler(self, event, ...)
    if event == "ADDON_LOADED" and ... == "DinkinsDKP" then
        -- Populate the leaderboard with data from the dkpTable
        local yOffset = 0
        local rowHeight = 20

        if Table.DinkinsDKPDB ~= nil then
            for playerName, dkp in pairs(Table.DinkinsDKPDB) do
                local nameText = leaderboard:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                nameText:SetPoint("TOPLEFT", 8, -yOffset)
                nameText:SetText(playerName)

                local dkpText = leaderboard:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                dkpText:SetPoint("TOPRIGHT", -8, -yOffset)
                dkpText:SetText(dkp)

                yOffset = yOffset + rowHeight
            end

            scrollFrame:SetScrollChild(leaderboard)
        end

        leaderboard:UnregisterEvent("ADDON_LOADED")
    end
end

leaderboard:SetScript("OnEvent", eventHandler)

-- Animation variables
local animationTimer = 0
local animationSpeed = 2
local animationOffset = 5

-- Start the animation
local originalY = {}
local function StartAnimation()
    addonFrame:SetScript("OnUpdate", function(self, elapsed)
        animationTimer = animationTimer + elapsed
        --        for i, data in ipairs(dkpTable) do
        --            local yOffset = originalY[i] + math.sin(animationTimer * animationSpeed) * animationOffset
        --            data.nameText:SetPoint("TOPLEFT", 8, -yOffset)
        --        end

        if Table.DinkinsDKPDB ~= nil then
            for playerName, dkp in pairs(Table.DinkinsDKPDB) do
                local yOffset = math.sin(animationTimer * animationSpeed) * animationOffset

                local nameText = leaderboard:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                nameText:SetPoint("TOPLEFT", 8 + yOffset, -yOffset)

                local dkpText = leaderboard:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                dkpText:SetPoint("TOPRIGHT", -8 + yOffset, -yOffset)

                yOffset = yOffset + 20
            end

            scrollFrame:SetScrollChild(leaderboard)
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
