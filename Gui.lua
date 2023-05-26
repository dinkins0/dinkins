Gui = {}

-- Create the addon frame
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

-- Create the image texture
local imageTexture = addonFrame:CreateTexture(nil, "BACKGROUND")
imageTexture:SetTexture("Interface\\Addons\\DinkinsDKP\\dinkinsdkp_sq.blp")
imageTexture:SetSize(addonFrame:GetWidth(), 200)
imageTexture:SetPoint("CENTER", addonFrame, 0, 300)
imageTexture:Hide()

-- Path to MP3 file
local soundFilePath = "Interface\\Addons\\DinkinsDKP\\questing.mp3"

-- Function to play the sound
local function PlaySoundOnShow()
    local soundID = PlaySoundFile(soundFilePath, "Master")
    if not soundID then
        print("Failed to play sound file:", soundFilePath)
    end
end

-- Show the GUI
function Gui.showGUI()
    addonFrame:Show()
    PlaySoundOnShow()
    imageTexture:Show()
end

function Gui.hideGUI()
    addonFrame:Hide()
    imageTexture:Hide()
end

-- Create the title
local title = addonFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -16)
title:SetText("DINKINS KINDNESS POINTS!!!")
title:SetFont("Interface\\Addons\\DinkinsDKP\\Fonts\\porky.TTF", 20, "OUTLINE")

-- Create the leaderboard scroll frame
local scrollFrame = CreateFrame("ScrollFrame", "DinkinsDKPScrollFrame", addonFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(250, 300)
scrollFrame:SetPoint("TOP", title, "BOTTOM", 0, -16)

-- Create the leaderboard content
local leaderboard = CreateFrame("Frame", "DinkinsDKPLeaderboard", scrollFrame)
leaderboard:SetSize(250, 300)

-- Function to animate leaderboard entries
local function AnimateLeaderboardEntries()
    local yOffset = 0
    local rowHeight = 20

    -- Clear the leaderboard before populating it
    for i = 1, #leaderboard.entries do
        leaderboard.entries[i]:Hide()
    end

    -- Get the sorted and merged DKP table
    local dkpTable = Table.SortDKPTable()

    -- Populate the leaderboard with entries
    local index = 1
    for _, data in ipairs(dkpTable) do
        local playerName = data.name
        local dkp = data.dkp

        local entryFrame = leaderboard.entries[index]
        if not entryFrame then
            entryFrame = CreateFrame("Frame", nil, leaderboard)
            entryFrame:SetHeight(rowHeight)
            entryFrame:SetPoint("TOPLEFT", 0, -yOffset)
            entryFrame:SetPoint("TOPRIGHT", 0, -yOffset)

            local nameText = entryFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            nameText:SetPoint("LEFT", 0, 0) -- Adjust the anchor point of the name text
            nameText:SetPoint("RIGHT", entryFrame, "CENTER", -5, 0) -- Adjust the anchor point of the name text

            local dkpText = entryFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            dkpText:SetPoint("LEFT", entryFrame, "CENTER", 5, 0) -- Adjust the anchor point of the DKP text
            dkpText:SetPoint("RIGHT", 0, 0) -- Adjust the anchor point of the DKP text

            entryFrame.nameText = nameText
            entryFrame.dkpText = dkpText

            leaderboard.entries[index] = entryFrame
        end

        entryFrame.nameText:SetText(playerName)
        entryFrame.dkpText:SetText(dkp)
        entryFrame:Show()

        yOffset = yOffset + rowHeight
        index = index + 1
    end

    scrollFrame:SetScrollChild(leaderboard)
end


-- Initialize the leaderboard entries table
leaderboard.entries = {}

-- Hook the show/hide events to start/stop the animation
addonFrame:SetScript("OnShow", function()
    AnimateLeaderboardEntries()
    PlaySoundOnShow()
end)

addonFrame:SetScript("OnHide", function()
    -- Stop the animation
    for i = 1, #leaderboard.entries do
        leaderboard.entries[i]:Hide()
    end
end)
