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
    local soundID = PlaySoundFile(soundFilePath, "Master")
    if not soundID then
        print("Failed to play sound file:", soundFilePath)
    end
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

-- Function to animate leaderboard entries
local function AnimateLeaderboardEntries()
    local yOffset = 0
    local rowHeight = 20

    if Table.DinkinsDKPDB ~= nil then
        for playerName, dkp in pairs(Table.DinkinsDKPDB) do
            local entryFrame = CreateFrame("Frame", nil, leaderboard)
            entryFrame:SetHeight(rowHeight)
            entryFrame:SetPoint("TOPLEFT", 0, -yOffset)
            entryFrame:SetPoint("TOPRIGHT", 0, -yOffset)
            
            local nameText = entryFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            nameText:SetText(playerName)
            
            local dkpText = entryFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            dkpText:SetText(dkp)
            
            -- Function to apply slight wiggle animation to a text frame
            local function ApplyWiggleAnimation(frame)
                local originalX = frame:GetLeft()
                local animationScale = 0.03
                local animationSpeed = 4
                
                frame:SetScript("OnUpdate", function(self, elapsed)
                    local offset = math.sin(GetTime() * animationSpeed) * animationScale
                    frame:SetPoint("LEFT", originalX + offset, 0)
                end)
            end
            
            -- Apply wiggle animation to name and dkp text frames
            ApplyWiggleAnimation(nameText)
            ApplyWiggleAnimation(dkpText)

            yOffset = yOffset + rowHeight
        end

        scrollFrame:SetScrollChild(leaderboard)
    end
end

-- Initialize local table with either WoW Saved Variable or default
local function eventHandler(self, event, ...)
    if event == "ADDON_LOADED" and ... == "DinkinsDKP" then
        AnimateLeaderboardEntries()
        leaderboard:UnregisterEvent("ADDON_LOADED")
    end
end

leaderboard:SetScript("OnEvent", eventHandler)

-- Hook the show/hide events to start/stop the animation
addonFrame:SetScript("OnShow", function()
    AnimateLeaderboardEntries()
    PlaySoundOnShow()
end)

addonFrame:SetScript("OnHide", function()
    -- Stop the animation
    for i = 1, leaderboard:GetNumChildren() do
        local child = select(i, leaderboard:GetChildren())
        child:SetScript("OnUpdate", nil)
    end
end)
