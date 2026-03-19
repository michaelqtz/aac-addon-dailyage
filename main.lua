local api = require("api")

local dailyAge_addon = {
	name = "DailyAge",
	author = "Michaelqt",
	version = "1.1.0",
	desc = "Dailies & Weeklies Quest Tracker."
}

local quests = {
    -- Crimson Rift
    {2941}, -- Crimson Omens 1
    {2942}, -- Crimson Omens 2
    {2943}, -- Crimson Omens 3
    {5886}, -- Defeat Hounds
    {5885}, -- Defeat Anth
    -- Grimghast Rift
    {5142, 5157}, -- Putting packs in treb
    {5143}, -- Halting Crimson Tide 1
    {5144}, -- Halting Crimson Tide 2
    {7648}, -- Defeat Nightmare #1
    {7649}, -- Defeat Nightmare #B
    -- Whalesong Siege
    {8602, 8609, 8610, 8611},
    {8603, 8612, 8613, 8614},
    {8604, 8615, 8616, 8617},
    {8637, 8638, 8639, 8640},
    {8605, 8606, 8607, 8608},
    -- Aegis Island
    {8623, 8624, 8625, 8626},
    {8627, 8628, 8629, 8630},
    {8631, 8632, 8633, 8634},
    {8641, 8642, 8643, 8644},
    {8618, 8619, 8620, 8621},
    -- Mistmerrow Attack
    -- TODO: HELP! I DONT KNOW WHICH ARE DAILIES
    -- Luscas Awakening
    {5765}, -- Lusca Awakening
    -- Abyssal Attack
    {6973, 6974, 6975, 6976}, -- Becoming a Seaknight
    {6791}, -- Stopping Doomsday
    -- Jola, Meina, Glenn
    {5971}, {5969}, {5970}, {5972},
    -- Ocean Gilda Dailies
    {6797}, -- Enemies of Sea Trade (Seabugs)
    {6792}, -- Ghosts from the Depths
    {6793}, -- Calming the Ocean's Malice
    {6798}, -- Ghost Ships of Delphinad
    -- Prestige 
    {7606, 7609}, -- Grand Construction 1
    {7607, 7610}, -- Grand Construction 2
    {7608, 7611}, -- Grand Construction 3
    {7616}, -- Pirate Politics
    -- Library Dailies
    {6095}, -- F1 p1
    {6096}, -- F1 p2
    {6430}, -- F1 p3
    {6118}, -- F2 p1
    {6119}, -- F2 p2
    {6431}, -- F2 p3
    {6141}, -- F3 p1
    {6142}, -- F3 p2
    {6432}, -- F3 p3
    {6637}, -- Ayanad Agent p1
    {6638}, -- Ayanad Agent p2
    {6639}, -- Ayanad Agent p3
    -- Arena Dailies
    {6627}, -- Blood Sweat and Training
    -- Ocleera Rift
    {7327}, -- Sprouting Ocleera Marks
    {7328}, -- Engorged Ocleera Marks
    {7329}, -- Mosntrous Ocleera Marks
    {7330}, -- Kill the Hateful Ocleera
    -- World Bosses
    {7619}, {7620}, {7621}, {7622},
    {7623}, {7624}, {7625}, {7626},
    {7627}, {7628}, {7629}, {7630},
    {7631}, {7632}, {7633}, {7634},
    {7635}, {7636}, {7637}, {7638},
    {7639}, {7640}, {7641}, {7642},
    {7643}, {7644}, {7645}, {7646},
    {7647}, {7650}, {7651}, {7652},
    {7653}, {7654}, {7655}, {5033},
    {5879}, {5887}, {5883}, {5884},
}

local dailyAgeWindow

local function getCompletionForQuest(questId)
    return api.Quest:IsCompleted(questId)
end 

local function countCompletedQuests(questIds)
    local completedCount = 0
    for i = 1, #questIds do 
        if api.Quest:IsCompleted(questIds[i]) then 
            completedCount = completedCount + 1
        end 
    end 
    return completedCount
end 

local function colorizeByCompletionCount(textLabel, completedCount, totalCount)
    -- api.Log:Info(tostring(textLabel:GetText()))
    if completedCount == totalCount then 
        ApplyTextColor(textLabel, FONT_COLOR.GREEN)
    else 
        ApplyTextColor(textLabel, FONT_COLOR.DEFAULT)
    end 
end

local function updateCompletedQuestLabels(searchText)
    local questList = dailyAgeWindow.questListWindow.tab.window[2].questScrollList
    -- for key, value in pairs() do 
    --     api.Log:Info("Key: " .. tostring(key) .. " Value: " .. tostring(value))
    -- end 
    questList:DeleteAllDatas()
    local count = 1
    for questKey, questIds in ipairs(quests) do 
        local questData = {
            id = questIds[1],
            questId = questIds[1],
            questTitle = api.Quest:GetQuestContextMainTitle(questIds[1]),
            isCompleted = false,
            isViewData = true,
            isAbstention = false
        }
        for i = 1, #questIds do 
            if api.Quest:IsCompleted(questIds[i]) then 
                questData.isCompleted = true
                break
            end 
        end
        -- questData.questTitle = questData.questTitle .. " (" .. tostring(questData.isCompleted) .. ")"
        if searchText ~= nil then 
            if string.find(questData.questTitle:lower(), searchText:lower()) then 
                questList:InsertData(count, 1, questData, false)
                count = count + 1
            end 
        else 
            questList:InsertData(count, 1, questData, false)
            count = count + 1
        end
    end
    -- Hand-insert the weeklies
    local fishWeeklyQuestData = {
        id = 9000011,
        questId = 9000011,
        questTitle = api.Quest:GetQuestContextMainTitle(9000011),
        isCompleted = api.Quest:IsCompleted(9000011),
        isViewData = true,
        isAbstention = false
    }
    if searchText ~= nil then 
        if string.find(fishWeeklyQuestData.questTitle:lower(), searchText:lower()) then 
            questList:InsertData(count, 1, fishWeeklyQuestData, false)
            count = count + 1
        end 
    else
        questList:InsertData(count, 1, fishWeeklyQuestData, false)
        count = count + 1
    end
    local dsWeeklyQuestData = {
        id = 9000009,
        questId = 9000009,
        questTitle = api.Quest:GetQuestContextMainTitle(9000009),
        isCompleted = false,
        isViewData = true,
        isAbstention = false
    }
    if api.Quest:IsCompleted(9000009) or api.Quest:IsCompleted(9000008) or api.Quest:IsCompleted(9000007) then 
        dsWeeklyQuestData.isCompleted = true
    end
    if searchText ~= nil then 
        if string.find(dsWeeklyQuestData.questTitle:lower(), searchText:lower()) then 
            questList:InsertData(count, 1, dsWeeklyQuestData, false)
            count = count + 1
        end 
    else
        questList:InsertData(count, 1, dsWeeklyQuestData, false)
        count = count + 1
    end
end

local clockTimer = 0
local clockResetTime = 1000
local function OnUpdate(dt)
    if dailyAgeWindow:IsVisible() then 
        local questList = dailyAgeWindow.questListWindow.tab.window[2].questScrollList
        questList:UpdateView()
        for _, item in pairs(questList:GetListCtrlItems()) do
            local isItemCompleted = item.subItems[1].isCompleted

            if isItemCompleted then 
                ApplyTextColor(item.subItems[1].textbox, FONT_COLOR.GREEN)
            else 
                ApplyTextColor(item.subItems[1].textbox, FONT_COLOR.RED)
            end
        end 
    else 
        clockTimer = clockTimer + dt
        if clockTimer > clockResetTime then 
            clockTimer = 0
            updateCompletedQuestLabels()
            dailyAgeWindow.questListWindow.tab.window[2].questSearchTextEdit:SetText("")
        end 
    end 
end 

local function CreateDashboardWindow(wndParent)
    local wnd = wndParent:CreateChildWidget("emptywidget", "dashboardWindow", 0, true)
    wnd:SetExtent(430, 500)
    wnd:AddAnchor("TOPLEFT", wndParent, 0, 10)

    --- ROW 1
    -- Crimson Rift
    local titleLabelCrimsonRift = wnd:CreateChildWidget("label", "titleLabelCrimsonRift", 0, true)
    titleLabelCrimsonRift:SetText("Crimson Rift")
    titleLabelCrimsonRift:AddAnchor("TOPLEFT", wnd, 0, 10)
    titleLabelCrimsonRift.style:SetFontSize(FONT_SIZE.XLARGE)
    titleLabelCrimsonRift.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(titleLabelCrimsonRift, FONT_COLOR.TITLE)
    wnd.titleLabelCrimsonRift = titleLabelCrimsonRift

    local labelCrimsonRiftQuests = wnd:CreateChildWidget("label", "labelCrimsonRiftQuests", 0, true)
    labelCrimsonRiftQuests:SetText("Rift Stages: 0/3")
    labelCrimsonRiftQuests:AddAnchor("TOPLEFT", titleLabelCrimsonRift, "BOTTOMLEFT", 0, 18)
    labelCrimsonRiftQuests.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelCrimsonRiftQuests.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelCrimsonRiftQuests, FONT_COLOR.DEFAULT)
    wnd.labelCrimsonRiftQuests = labelCrimsonRiftQuests

    local labelCrimsonRiftBossQuests = wnd:CreateChildWidget("label", "labelCrimsonRiftBossQuests", 0, true)
    labelCrimsonRiftBossQuests:SetText("Boss Kill: 0/1")
    labelCrimsonRiftBossQuests:AddAnchor("TOPLEFT", labelCrimsonRiftQuests, "BOTTOMLEFT", 0, 18)
    labelCrimsonRiftBossQuests.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelCrimsonRiftBossQuests.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelCrimsonRiftBossQuests, FONT_COLOR.DEFAULT)
    wnd.labelCrimsonRiftBossQuests = labelCrimsonRiftBossQuests

    local labelCrimsonRiftAnthQuests = wnd:CreateChildWidget("label", "labelCrimsonRiftAnthQuests", 0, true)
    labelCrimsonRiftAnthQuests:SetText("Anthalon: 0/1")
    labelCrimsonRiftAnthQuests:AddAnchor("TOPLEFT", labelCrimsonRiftBossQuests, "BOTTOMLEFT", 0, 18)
    labelCrimsonRiftAnthQuests.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelCrimsonRiftAnthQuests.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelCrimsonRiftAnthQuests, FONT_COLOR.DEFAULT)
    wnd.labelCrimsonRiftAnthQuests = labelCrimsonRiftAnthQuests

    -- Grimghast Rift
    local titleLabelGrimghastRift = wnd:CreateChildWidget("label", "titleLabelGrimghastRift", 0, true)
    titleLabelGrimghastRift:SetText("Grimghast Rift")
    -- place to the right of Crimson Rift title
    titleLabelGrimghastRift:AddAnchor("TOPLEFT", titleLabelCrimsonRift, "TOPRIGHT", 130, 0)
    titleLabelGrimghastRift.style:SetFontSize(FONT_SIZE.XLARGE)
    titleLabelGrimghastRift.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(titleLabelGrimghastRift, FONT_COLOR.TITLE)
    wnd.titleLabelGrimghastRift = titleLabelGrimghastRift

    local labelGrimghastRiftConstructionQuests = wnd:CreateChildWidget("label", "labelGrimghastRiftConstructionQuests", 0, true)
    labelGrimghastRiftConstructionQuests:SetText("Construction: 0/1")
    labelGrimghastRiftConstructionQuests:AddAnchor("TOPLEFT", titleLabelGrimghastRift, "BOTTOMLEFT", 0, 18)
    labelGrimghastRiftConstructionQuests.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelGrimghastRiftConstructionQuests.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelGrimghastRiftConstructionQuests, FONT_COLOR.DEFAULT)
    wnd.labelGrimghastRiftConstructionQuests = labelGrimghastRiftConstructionQuests

    local labelGrimghastRiftQuests = wnd:CreateChildWidget("label", "labelGrimghastRiftQuests", 0, true)
    labelGrimghastRiftQuests:SetText("Rift Stages: 0/2")
    labelGrimghastRiftQuests:AddAnchor("TOPLEFT", labelGrimghastRiftConstructionQuests, "BOTTOMLEFT", 0, 18)
    labelGrimghastRiftQuests.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelGrimghastRiftQuests.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelGrimghastRiftQuests, FONT_COLOR.DEFAULT)
    wnd.labelGrimghastRiftQuests = labelGrimghastRiftQuests

    local labelGrimghastRiftBossQuests = wnd:CreateChildWidget("label", "labelGrimghastRiftBossQuests", 0, true)
    labelGrimghastRiftBossQuests:SetText("Boss Kills: 0/2")
    labelGrimghastRiftBossQuests:AddAnchor("TOPLEFT", labelGrimghastRiftQuests, "BOTTOMLEFT", 0, 18)
    labelGrimghastRiftBossQuests.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelGrimghastRiftBossQuests.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelGrimghastRiftBossQuests, FONT_COLOR.DEFAULT)
    wnd.labelGrimghastRiftBossQuests = labelGrimghastRiftBossQuests

    -- Luscas Awakening
    local titleLabelLuscasAwakening = wnd:CreateChildWidget("label", "titleLabelLuscasAwakening", 0, true)
    titleLabelLuscasAwakening:SetText("Luscas Awakening")
    -- place to the right of Grimghast Rift title
    titleLabelLuscasAwakening:AddAnchor("TOPLEFT", titleLabelGrimghastRift, "TOPRIGHT", 130, 0)
    titleLabelLuscasAwakening.style:SetFontSize(FONT_SIZE.XLARGE)
    titleLabelLuscasAwakening.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(titleLabelLuscasAwakening, FONT_COLOR.TITLE)
    wnd.titleLabelLuscasAwakening = titleLabelLuscasAwakening

    local labelLuscasAwakeningQuests = wnd:CreateChildWidget("label", "labelLuscasAwakeningQuests", 0, true)
    labelLuscasAwakeningQuests:SetText("Luscas Kills: 0/1")
    labelLuscasAwakeningQuests:AddAnchor("TOPLEFT", titleLabelLuscasAwakening, "BOTTOMLEFT", 0, 18)
    labelLuscasAwakeningQuests.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelLuscasAwakeningQuests.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelLuscasAwakeningQuests, FONT_COLOR.DEFAULT)
    wnd.labelLuscasAwakeningQuests = labelLuscasAwakeningQuests

    --- ROW 2
    -- The Prophecy (below Crimson Rift, spaced by 120)
    local titleLabelTheProphecy = wnd:CreateChildWidget("label", "titleLabelTheProphecy", 0, true)
    titleLabelTheProphecy:SetText("The Prophecy")
    titleLabelTheProphecy:AddAnchor("TOPLEFT", titleLabelCrimsonRift, "BOTTOMLEFT", 0, 120)
    titleLabelTheProphecy.style:SetFontSize(FONT_SIZE.XLARGE)
    titleLabelTheProphecy.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(titleLabelTheProphecy, FONT_COLOR.TITLE)
    wnd.titleLabelTheProphecy = titleLabelTheProphecy

    local labelTheProphecyJola = wnd:CreateChildWidget("label", "labelTheProphecyJola", 0, true)
    labelTheProphecyJola:SetText("Jola: 0/1")
    labelTheProphecyJola:AddAnchor("TOPLEFT", titleLabelTheProphecy, "BOTTOMLEFT", 0, 18)
    labelTheProphecyJola.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelTheProphecyJola.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelTheProphecyJola, FONT_COLOR.DEFAULT)
    wnd.labelTheProphecyJola = labelTheProphecyJola

    local labelTheProphecyMeina = wnd:CreateChildWidget("label", "labelTheProphecyMeina", 0, true)
    labelTheProphecyMeina:SetText("Meina: 0/1")
    labelTheProphecyMeina:AddAnchor("TOPLEFT", labelTheProphecyJola, "BOTTOMLEFT", 0, 18)
    labelTheProphecyMeina.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelTheProphecyMeina.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelTheProphecyMeina, FONT_COLOR.DEFAULT)
    wnd.labelTheProphecyMeina = labelTheProphecyMeina

    local labelTheProphecyGlenn = wnd:CreateChildWidget("label", "labelTheProphecyGlenn", 0, true)
    labelTheProphecyGlenn:SetText("Glenn: 0/1")
    labelTheProphecyGlenn:AddAnchor("TOPLEFT", labelTheProphecyMeina, "BOTTOMLEFT", 0, 18)
    labelTheProphecyGlenn.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelTheProphecyGlenn.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelTheProphecyGlenn, FONT_COLOR.DEFAULT)
    wnd.labelTheProphecyGlenn = labelTheProphecyGlenn

    -- Whalesong Siege (below Grimghast Rift, spaced by 120)
    local titleLabelWhalesongSiege = wnd:CreateChildWidget("label", "titleLabelWhalesongSiege", 0, true)
    titleLabelWhalesongSiege:SetText("Whalesong")
    titleLabelWhalesongSiege:AddAnchor("TOPLEFT", titleLabelGrimghastRift, "BOTTOMLEFT", 0, 120)
    titleLabelWhalesongSiege.style:SetFontSize(FONT_SIZE.XLARGE)
    titleLabelWhalesongSiege.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(titleLabelWhalesongSiege, FONT_COLOR.TITLE)
    wnd.titleLabelWhalesongSiege = titleLabelWhalesongSiege

    local labelWhalesongSiegeWaves = wnd:CreateChildWidget("label", "labelWhalesongSiegeWaves", 0, true)
    labelWhalesongSiegeWaves:SetText("Waves: 0/3")
    labelWhalesongSiegeWaves:AddAnchor("TOPLEFT", titleLabelWhalesongSiege, "BOTTOMLEFT", 0, 18)
    labelWhalesongSiegeWaves.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelWhalesongSiegeWaves.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelWhalesongSiegeWaves, FONT_COLOR.DEFAULT)
    wnd.labelWhalesongSiegeWaves = labelWhalesongSiegeWaves

    local labelWhalesongSiegeBoss = wnd:CreateChildWidget("label", "labelWhalesongSiegeBoss", 0, true)
    labelWhalesongSiegeBoss:SetText("Boss Kill: 0/1")
    labelWhalesongSiegeBoss:AddAnchor("TOPLEFT", labelWhalesongSiegeWaves, "BOTTOMLEFT", 0, 18)
    labelWhalesongSiegeBoss.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelWhalesongSiegeBoss.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelWhalesongSiegeBoss, FONT_COLOR.DEFAULT)
    wnd.labelWhalesongSiegeBoss = labelWhalesongSiegeBoss

    -- Aegis Island (below Luscas Awakening, spaced by 120)
    local titleLabelAegisIsland = wnd:CreateChildWidget("label", "titleLabelAegisIsland", 0, true)
    titleLabelAegisIsland:SetText("Aegis Island")
    titleLabelAegisIsland:AddAnchor("TOPLEFT", titleLabelLuscasAwakening, "BOTTOMLEFT", 0, 120)
    titleLabelAegisIsland.style:SetFontSize(FONT_SIZE.XLARGE)
    titleLabelAegisIsland.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(titleLabelAegisIsland, FONT_COLOR.TITLE)
    wnd.titleLabelAegisIsland = titleLabelAegisIsland

    local labelAegisIslandWaves = wnd:CreateChildWidget("label", "labelAegisIslandWaves", 0, true)
    labelAegisIslandWaves:SetText("Waves: 0/3")
    labelAegisIslandWaves:AddAnchor("TOPLEFT", titleLabelAegisIsland, "BOTTOMLEFT", 0, 18)
    labelAegisIslandWaves.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelAegisIslandWaves.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelAegisIslandWaves, FONT_COLOR.DEFAULT)
    wnd.labelAegisIslandWaves = labelAegisIslandWaves

    local labelAegisIslandBoss = wnd:CreateChildWidget("label", "labelAegisIslandBoss", 0, true)
    labelAegisIslandBoss:SetText("Boss Kill: 0/1")
    labelAegisIslandBoss:AddAnchor("TOPLEFT", labelAegisIslandWaves, "BOTTOMLEFT", 0, 18)
    labelAegisIslandBoss.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelAegisIslandBoss.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelAegisIslandBoss, FONT_COLOR.DEFAULT)
    wnd.labelAegisIslandBoss = labelAegisIslandBoss

    --- ROW 3
    -- Comet Rift (below The Prophecy, spaced by 120)
    local titleLabelCometRift = wnd:CreateChildWidget("label", "titleLabelCometRift", 0, true)
    titleLabelCometRift:SetText("Comet Rift")
    titleLabelCometRift:AddAnchor("TOPLEFT", titleLabelTheProphecy, "BOTTOMLEFT", 0, 120)
    titleLabelCometRift.style:SetFontSize(FONT_SIZE.XLARGE)
    titleLabelCometRift.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(titleLabelCometRift, FONT_COLOR.TITLE)
    wnd.titleLabelCometRift = titleLabelCometRift

    local labelCometRiftStages = wnd:CreateChildWidget("label", "labelCometRiftStages", 0, true)
    labelCometRiftStages:SetText("Rift Stages: 0/3")
    labelCometRiftStages:AddAnchor("TOPLEFT", titleLabelCometRift, "BOTTOMLEFT", 0, 18)
    labelCometRiftStages.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelCometRiftStages.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelCometRiftStages, FONT_COLOR.DEFAULT)
    wnd.labelCometRiftStages = labelCometRiftStages

    local labelCometRiftBoss = wnd:CreateChildWidget("label", "labelCometRiftBoss", 0, true)
    labelCometRiftBoss:SetText("Boss Kill: 0/1")
    labelCometRiftBoss:AddAnchor("TOPLEFT", labelCometRiftStages, "BOTTOMLEFT", 0, 18)
    labelCometRiftBoss.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelCometRiftBoss.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelCometRiftBoss, FONT_COLOR.DEFAULT)
    wnd.labelCometRiftBoss = labelCometRiftBoss

    -- Ocleera Rift (below Whalesong, spaced by 120)
    local titleLabelOcleeraRift = wnd:CreateChildWidget("label", "titleLabelOcleeraRift", 0, true)
    titleLabelOcleeraRift:SetText("Ocleera Rift")
    titleLabelOcleeraRift:AddAnchor("TOPLEFT", titleLabelWhalesongSiege, "BOTTOMLEFT", 0, 120)
    titleLabelOcleeraRift.style:SetFontSize(FONT_SIZE.XLARGE)
    titleLabelOcleeraRift.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(titleLabelOcleeraRift, FONT_COLOR.TITLE)
    wnd.titleLabelOcleeraRift = titleLabelOcleeraRift

    local labelOcleeraRiftStages = wnd:CreateChildWidget("label", "labelOcleeraRiftStages", 0, true)
    labelOcleeraRiftStages:SetText("Rift Stages: 0/3")
    labelOcleeraRiftStages:AddAnchor("TOPLEFT", titleLabelOcleeraRift, "BOTTOMLEFT", 0, 18)
    labelOcleeraRiftStages.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelOcleeraRiftStages.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelOcleeraRiftStages, FONT_COLOR.DEFAULT)
    wnd.labelOcleeraRiftStages = labelOcleeraRiftStages

    local labelOcleeraRiftBoss = wnd:CreateChildWidget("label", "labelOcleeraRiftBoss", 0, true)
    labelOcleeraRiftBoss:SetText("Boss Kill: 0/1")
    labelOcleeraRiftBoss:AddAnchor("TOPLEFT", labelOcleeraRiftStages, "BOTTOMLEFT", 0, 18)
    labelOcleeraRiftBoss.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelOcleeraRiftBoss.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelOcleeraRiftBoss, FONT_COLOR.DEFAULT)
    wnd.labelOcleeraRiftBoss = labelOcleeraRiftBoss

    -- Library Floors (below Aegis Island, spaced by 120)
    local titleLabelLibraryFloors = wnd:CreateChildWidget("label", "titleLabelLibraryFloors", 0, true)
    titleLabelLibraryFloors:SetText("Library Floors")
    titleLabelLibraryFloors:AddAnchor("TOPLEFT", titleLabelAegisIsland, "BOTTOMLEFT", 0, 120)
    titleLabelLibraryFloors.style:SetFontSize(FONT_SIZE.XLARGE)
    titleLabelLibraryFloors.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(titleLabelLibraryFloors, FONT_COLOR.TITLE)
    wnd.titleLabelLibraryFloors = titleLabelLibraryFloors

    local labelLibraryFloorOne = wnd:CreateChildWidget("label", "labelLibraryFloorOne", 0, true)
    labelLibraryFloorOne:SetText("Floor One: 0/3")
    labelLibraryFloorOne:AddAnchor("TOPLEFT", titleLabelLibraryFloors, "BOTTOMLEFT", 0, 18)
    labelLibraryFloorOne.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelLibraryFloorOne.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelLibraryFloorOne, FONT_COLOR.DEFAULT)
    wnd.labelLibraryFloorOne = labelLibraryFloorOne

    local labelLibraryFloorTwo = wnd:CreateChildWidget("label", "labelLibraryFloorTwo", 0, true)
    labelLibraryFloorTwo:SetText("Floor Two: 0/3")
    labelLibraryFloorTwo:AddAnchor("TOPLEFT", labelLibraryFloorOne, "BOTTOMLEFT", 0, 18)
    labelLibraryFloorTwo.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelLibraryFloorTwo.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelLibraryFloorTwo, FONT_COLOR.DEFAULT)
    wnd.labelLibraryFloorTwo = labelLibraryFloorTwo

    local labelLibraryFloorThree = wnd:CreateChildWidget("label", "labelLibraryFloorThree", 0, true)
    labelLibraryFloorThree:SetText("Floor Three: 0/3")
    labelLibraryFloorThree:AddAnchor("TOPLEFT", labelLibraryFloorTwo, "BOTTOMLEFT", 0, 18)
    labelLibraryFloorThree.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelLibraryFloorThree.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelLibraryFloorThree, FONT_COLOR.DEFAULT)
    wnd.labelLibraryFloorThree = labelLibraryFloorThree

    local labelLibraryAllFloors = wnd:CreateChildWidget("label", "labelLibraryAllFloors", 0, true)
    labelLibraryAllFloors:SetText("All Floors: 0/3")
    labelLibraryAllFloors:AddAnchor("TOPLEFT", labelLibraryFloorThree, "BOTTOMLEFT", 0, 18)
    labelLibraryAllFloors.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelLibraryAllFloors.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelLibraryAllFloors, FONT_COLOR.DEFAULT)
    wnd.labelLibraryAllFloors = labelLibraryAllFloors

    --- ROW 4
    -- Activity Tokens (below Library Floors, spaced by 120)
    local titleLabelActivityTokens = wnd:CreateChildWidget("label", "titleLabelActivityTokens", 0, true)
    titleLabelActivityTokens:SetText("Activity Tokens")
    titleLabelActivityTokens:AddAnchor("TOPLEFT", titleLabelLibraryFloors, "BOTTOMLEFT", 0, 120)
    titleLabelActivityTokens.style:SetFontSize(FONT_SIZE.XLARGE)
    titleLabelActivityTokens.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(titleLabelActivityTokens, FONT_COLOR.TITLE)
    wnd.titleLabelActivityTokens = titleLabelActivityTokens

    local labelActivityTokensDSPvP = wnd:CreateChildWidget("label", "labelActivityTokensDSPvP", 0, true)
    labelActivityTokensDSPvP:SetText("DS PvP: 0/1")
    labelActivityTokensDSPvP:AddAnchor("TOPLEFT", titleLabelActivityTokens, "BOTTOMLEFT", 0, 18)
    labelActivityTokensDSPvP.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelActivityTokensDSPvP.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelActivityTokensDSPvP, FONT_COLOR.DEFAULT)
    wnd.labelActivityTokensDSPvP = labelActivityTokensDSPvP

    local labelActivityTokensFishing = wnd:CreateChildWidget("label", "labelActivityTokensFishing", 0, true)
    labelActivityTokensFishing:SetText("Fishing: 0/1")
    labelActivityTokensFishing:AddAnchor("TOPLEFT", labelActivityTokensDSPvP, "BOTTOMLEFT", 0, 18)
    labelActivityTokensFishing.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelActivityTokensFishing.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelActivityTokensFishing, FONT_COLOR.DEFAULT)
    wnd.labelActivityTokensFishing = labelActivityTokensFishing

    local labelActivityTokensAnthalon = wnd:CreateChildWidget("label", "labelActivityTokensAnthalon", 0, true)
    labelActivityTokensAnthalon:SetText("Anthalon: 0/1")
    labelActivityTokensAnthalon:AddAnchor("TOPLEFT", labelActivityTokensFishing, "BOTTOMLEFT", 0, 18)
    labelActivityTokensAnthalon.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelActivityTokensAnthalon.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelActivityTokensAnthalon, FONT_COLOR.DEFAULT)
    wnd.labelActivityTokensAnthalon = labelActivityTokensAnthalon

    local labelActivityTokensLibrary = wnd:CreateChildWidget("label", "labelActivityTokensLibrary", 0, true)
    labelActivityTokensLibrary:SetText("Library: 0/2")
    labelActivityTokensLibrary:AddAnchor("TOPLEFT", labelActivityTokensAnthalon, "BOTTOMLEFT", 0, 18)
    labelActivityTokensLibrary.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelActivityTokensLibrary.style:SetAlign(ALIGN.LEFT)
    ApplyTextColor(labelActivityTokensLibrary, FONT_COLOR.DEFAULT)
    wnd.labelActivityTokensLibrary = labelActivityTokensLibrary

end 

local function refreshDashboardCompletions(questListWindow)
    local dashboardWnd = questListWindow.tab.window[1].dashboardWindow
    --- ROW 1
    -- Crimson Rift
    local crimsonRiftQuestsCompleted = countCompletedQuests({
        2941, 2942, 2943
    })
    dashboardWnd.labelCrimsonRiftQuests:SetText("Rift Stages: " .. tostring(crimsonRiftQuestsCompleted) .. "/3")
    colorizeByCompletionCount(dashboardWnd.labelCrimsonRiftQuests, crimsonRiftQuestsCompleted, 3)
    local crimsonRiftBossCompleted = getCompletionForQuest(5886)
    dashboardWnd.labelCrimsonRiftBossQuests:SetText("Boss Kill: " .. tostring(crimsonRiftBossCompleted and 1 or 0) .. "/1")
    colorizeByCompletionCount(dashboardWnd.labelCrimsonRiftBossQuests, crimsonRiftBossCompleted, 1)
    local crimsonRiftAnthalonCompleted = getCompletionForQuest(5885)
    dashboardWnd.labelCrimsonRiftAnthQuests:SetText("Anthalon: " .. tostring(crimsonRiftAnthalonCompleted and 1 or 0) .. "/1")
    colorizeByCompletionCount(dashboardWnd.labelCrimsonRiftAnthQuests, crimsonRiftAnthalonCompleted, 1)
    -- Grimghast Rift
    local grimghastRiftConstructionCompleted = countCompletedQuests({
        5142, 5157
    })
    dashboardWnd.labelGrimghastRiftConstructionQuests:SetText("Construction: " .. tostring(grimghastRiftConstructionCompleted) .. "/1")
    colorizeByCompletionCount(dashboardWnd.labelGrimghastRiftConstructionQuests, grimghastRiftConstructionCompleted, 1)
    local grimghastRiftQuestsCompleted = countCompletedQuests({
        5143, 5144
    })
    dashboardWnd.labelGrimghastRiftQuests:SetText("Rift Stages: " .. tostring(grimghastRiftQuestsCompleted) .. "/2")
    colorizeByCompletionCount(dashboardWnd.labelGrimghastRiftQuests, grimghastRiftQuestsCompleted, 2)
    local grimghastRiftBossCompleted = countCompletedQuests({
        7648, 7649
    })
    dashboardWnd.labelGrimghastRiftBossQuests:SetText("Boss Kills: " .. tostring(grimghastRiftBossCompleted) .. "/2")
    colorizeByCompletionCount(dashboardWnd.labelGrimghastRiftBossQuests, grimghastRiftBossCompleted, 2)
    -- Luscas Awakening
    local luscasAwakeningCompleted = getCompletionForQuest(5765)
    dashboardWnd.labelLuscasAwakeningQuests:SetText("Luscas Kills: " .. tostring(luscasAwakeningCompleted and 1 or 0) .. "/1")
    colorizeByCompletionCount(dashboardWnd.labelLuscasAwakeningQuests, luscasAwakeningCompleted, 1)
    --- ROW 2
    -- The Prophecy
    local theProphecyJolaCompleted = getCompletionForQuest(5971)
    dashboardWnd.labelTheProphecyJola:SetText("Jola: " .. tostring(theProphecyJolaCompleted and 1 or 0) .. "/1")
    colorizeByCompletionCount(dashboardWnd.labelTheProphecyJola, theProphecyJolaCompleted, 1)
    local theProphecyMeinaCompleted = getCompletionForQuest(5969)
    dashboardWnd.labelTheProphecyMeina:SetText("Meina: " .. tostring(theProphecyMeinaCompleted and 1 or 0) .. "/1")
    colorizeByCompletionCount(dashboardWnd.labelTheProphecyMeina, theProphecyMeinaCompleted, 1)
    local theProphecyGlennCompleted = getCompletionForQuest(5970)
    dashboardWnd.labelTheProphecyGlenn:SetText("Glenn: " .. tostring(theProphecyGlennCompleted and 1 or 0) .. "/1")
    colorizeByCompletionCount(dashboardWnd.labelTheProphecyGlenn, theProphecyGlennCompleted, 1)
    -- Whalesong Siege
    local whalesongSiegeWavesCompleted = countCompletedQuests({
        8602, 8609, 8610, 8611, 8603, 8612, 8613, 8614, 8604, 8615, 8616, 8617
    })
    dashboardWnd.labelWhalesongSiegeWaves:SetText("Waves: " .. tostring(whalesongSiegeWavesCompleted) .. "/3")
    colorizeByCompletionCount(dashboardWnd.labelWhalesongSiegeWaves, whalesongSiegeWavesCompleted, 3)
    local whalesongSiegeBossCompleted = getCompletionForQuest({8605, 8606, 8607, 8608})
    dashboardWnd.labelWhalesongSiegeBoss:SetText("Boss Kill: " .. tostring(whalesongSiegeBossCompleted and 1 or 0) .. "/1")
    colorizeByCompletionCount(dashboardWnd.labelWhalesongSiegeBoss, whalesongSiegeBossCompleted, 1)
    -- Aegis Island
    local aegisIslandWavesCompleted = countCompletedQuests({
        8623, 8624, 8625, 8626, 8627, 8628, 8629, 8630, 8631, 8632, 8633, 8634
    })
    dashboardWnd.labelAegisIslandWaves:SetText("Waves: " .. tostring(aegisIslandWavesCompleted) .. "/3")
    colorizeByCompletionCount(dashboardWnd.labelAegisIslandWaves, aegisIslandWavesCompleted, 3)
    local aegisIslandBossCompleted = countCompletedQuests({8618, 8619, 8620, 8621})
    dashboardWnd.labelAegisIslandBoss:SetText("Boss Kill: " .. tostring(aegisIslandBossCompleted) .. "/1")
    colorizeByCompletionCount(dashboardWnd.labelAegisIslandBoss, aegisIslandBossCompleted, 1)
    --- ROW 3
    -- Comet Rift
    local cometRiftStagesCompleted = countCompletedQuests({
        9000134, 9000135, 9000136
    })
    dashboardWnd.labelCometRiftStages:SetText("Rift Stages: " .. tostring(cometRiftStagesCompleted) .. "/3")
    colorizeByCompletionCount(dashboardWnd.labelCometRiftStages, cometRiftStagesCompleted, 3)
    local cometRiftBossCompleted = getCompletionForQuest(9000143)
    dashboardWnd.labelCometRiftBoss:SetText("Boss Kill: " .. tostring(cometRiftBossCompleted and 1 or 0) .. "/1")
    colorizeByCompletionCount(dashboardWnd.labelCometRiftBoss, cometRiftBossCompleted, 1)
    -- Ocleera Rift
    local ocleeraRiftStagesCompleted = countCompletedQuests({
         7327, 7328, 7329
    })
    dashboardWnd.labelOcleeraRiftStages:SetText("Rift Stages: " .. tostring(ocleeraRiftStagesCompleted) .. "/3")
    colorizeByCompletionCount(dashboardWnd.labelOcleeraRiftStages, ocleeraRiftStagesCompleted, 3)
    local ocleeraRiftBossCompleted = getCompletionForQuest(7330)
    dashboardWnd.labelOcleeraRiftBoss:SetText("Boss Kill: " .. tostring(ocleeraRiftBossCompleted and 1 or 0) .. "/1")
    colorizeByCompletionCount(dashboardWnd.labelOcleeraRiftBoss, ocleeraRiftBossCompleted, 1)
    -- Library Floors
    local libraryFloorOneCompleted = countCompletedQuests({
        6095, 6096, 6430
    })
    dashboardWnd.labelLibraryFloorOne:SetText("Floor One: " .. tostring(libraryFloorOneCompleted) .. "/3")
    colorizeByCompletionCount(dashboardWnd.labelLibraryFloorOne, libraryFloorOneCompleted, 3)
    local libraryFloorTwoCompleted = countCompletedQuests({
        6118, 6119, 6431
    })
    dashboardWnd.labelLibraryFloorTwo:SetText("Floor Two: " .. tostring(libraryFloorTwoCompleted) .. "/3")
    colorizeByCompletionCount(dashboardWnd.labelLibraryFloorTwo, libraryFloorTwoCompleted, 3)
    local libraryFloorThreeCompleted = countCompletedQuests({
        6141, 6142, 6432
    })
    dashboardWnd.labelLibraryFloorThree:SetText("Floor Three: " .. tostring(libraryFloorThreeCompleted) .. "/3")
    colorizeByCompletionCount(dashboardWnd.labelLibraryFloorThree, libraryFloorThreeCompleted, 3)
    local libraryAllFloorsCompleted = countCompletedQuests({
        6637, 6638, 6639
    })
    dashboardWnd.labelLibraryAllFloors:SetText("All Floors: " .. tostring(libraryAllFloorsCompleted) .. "/3")
    colorizeByCompletionCount(dashboardWnd.labelLibraryAllFloors, libraryAllFloorsCompleted, 3)
    --- ROW 4
    -- Activity Tokens
    local activityTokensDSPvPCompleted = getCompletionForQuest({9000007, 9000008, 9000009})
    dashboardWnd.labelActivityTokensDSPvP:SetText("DS PvP: " .. tostring(activityTokensDSPvPCompleted and 1 or 0) .. "/1")
    colorizeByCompletionCount(dashboardWnd.labelActivityTokensDSPvP, activityTokensDSPvPCompleted, 1)
    local activityTokensFishingCompleted = getCompletionForQuest(9000011)
    dashboardWnd.labelActivityTokensFishing:SetText("Fishing: " .. tostring(activityTokensFishingCompleted and 1 or 0) .. "/1")
    colorizeByCompletionCount(dashboardWnd.labelActivityTokensFishing, activityTokensFishingCompleted, 1)
    local activityTokensAnthalonCompleted = getCompletionForQuest({9000012, 9000139})
    dashboardWnd.labelActivityTokensAnthalon:SetText("Anthalon: " .. tostring(activityTokensAnthalonCompleted and 1 or 0) .. "/1")
    colorizeByCompletionCount(dashboardWnd.labelActivityTokensAnthalon, activityTokensAnthalonCompleted, 1)
    local activityTokensLibraryCompleted = countCompletedQuests({
        9000171, 9000172
    })
    dashboardWnd.labelActivityTokensLibrary:SetText("Library: " .. tostring(activityTokensLibraryCompleted) .. "/2")
    colorizeByCompletionCount(dashboardWnd.labelActivityTokensLibrary, activityTokensLibraryCompleted, 2)

end 

local function CreateHonorPointsWindow(wndParent)

end

local function CreateLeadershipWindow(wndParent)

end

local function CreateSearchWindow(wndParent)
    local questListWindow = wndParent:CreateChildWidget("emptywidget", "questListWindow", 0, true)
    questListWindow:SetExtent(430, 500)
    questListWindow:AddAnchor("TOPLEFT", wndParent, 0, 0)

    -- Helper functions for scroll list
    local function DataSetFunc(subItem, data, setValue)
        if setValue then
            local questId = data.id
            local questTitle = data.questTitle
            local isCompleted = data.isCompleted
            subItem.questId = questId
            subItem.questTitle = questTitle
            subItem.isCompleted = isCompleted
            subItem.textbox:SetText(questTitle)
            if subItem.isCompleted then 
                ApplyTextColor(subItem.textbox, FONT_COLOR.GREEN)
                -- api.Log:Info(data.questTitle .. " " .. tostring(subItem.isCompleted))
            else 
                -- api.Log:Info(data.questTitle .. " " .. tostring(subItem.isCompleted))
                ApplyTextColor(subItem.textbox, FONT_COLOR.RED)
            end
            
        end
        
    end
    
    local function LayoutSetFunc(frame, rowIndex, colIndex, subItem)
        subItem:SetExtent(300, 25)
        local textbox = subItem:CreateChildWidget("textbox", "textbox", 0, true)
        textbox:AddAnchor("TOPLEFT", subItem, 45, 0)
        textbox:AddAnchor("BOTTOMRIGHT", subItem, 0, 0)
        textbox.style:SetAlign(ALIGN.LEFT)
        ApplyTextColor(textbox, FONT_COLOR.GREEN)
        subItem.textbox = textbox
    end
    
    -- List of quests
    local questScrollList = W_CTRL.CreatePageScrollListCtrl("questScrollList", questListWindow)
    -- questScrollList:SetWidth(300)
    questScrollList:AddAnchor("TOPLEFT", questListWindow, -30, 0)
    questScrollList:AddAnchor("BOTTOMRIGHT", questListWindow, -30, -10)
    questScrollList.scroll:AddAnchor("TOPRIGHT", questScrollList, -15, 0)
    questScrollList.scroll:AddAnchor("BOTTOMRIGHT", questScrollList, -15, 0)
    -- questScrollList.scroll:SetWheelMoveStep(0)
    -- questScrollList.scroll:SetButtonMoveStep(0)
    questScrollList.pageControl:Show(false)
    questScrollList:InsertColumn("", 300, 0, DataSetFunc, nil, nil, LayoutSetFunc)
    questScrollList:InsertRows(25, true)
    questScrollList:SetColumnHeight(40)
    wndParent.questScrollList = questScrollList
    dailyAgeWindow.questListWindow = wndParent

    -- Quest Name Search
    local questSearchTextEdit = W_CTRL.CreateEdit("questSearchTextEdit", questListWindow)
    questSearchTextEdit:SetExtent(280, 24)
    questSearchTextEdit:AddAnchor("TOPLEFT", questScrollList, 140, 10)
    questSearchTextEdit.style:SetFontSize(FONT_SIZE.XLARGE)
    questSearchLabel = questSearchTextEdit:CreateChildWidget("label", "questSearchLabel", 0, true)
    questSearchLabel:SetText("Quest Name: ")
    questSearchLabel.style:SetAlign(ALIGN.RIGHT)
    questSearchLabel.style:SetFontSize(FONT_SIZE.XLARGE)
    ApplyTextColor(questSearchLabel, FONT_COLOR.DEFAULT)
    questSearchLabel:AddAnchor("TOPRIGHT", questSearchTextEdit, "LEFT", 0, 0)
    -- Quest Name Search OnTextChanged
    function questSearchTextEdit:OnTextChanged()
        local searchText = questSearchTextEdit:GetText()
        if #searchText > 2 or #searchText == 0 then 
            updateCompletedQuestLabels(searchText)
        end 
	end
	questSearchTextEdit:SetHandler("OnTextChanged", questSearchTextEdit.OnTextChanged)
end 

local function OnLoad()
	local settings = api.GetSettings("dailyage")

	dailyAgeWindow = api.Interface:CreateEmptyWindow("dailyAgeWindow", "UIParent")
    local overlayBtn = dailyAgeWindow:CreateChildWidget("button", "overlayBtn", 0, true)
    local overlayBtnStyle = {
        drawableType = "drawable",
        path = TEXTURE_PATH.HUD,
        coords = {
          normal = {
            893,
            66,
            32,
            32
          },
          over = {
            926,
            66,
            32,
            32
          },
          click = {
            959,
            66,
            32,
            32
          },
          disable = {
            992,
            66,
            32,
            32
          }
        },
        width = 32,
        height = 32
    }
    ApplyButtonSkin(overlayBtn, overlayBtnStyle)
    overlayBtn:SetTextColor(FONT_COLOR.WHITE[1], FONT_COLOR.WHITE[2], FONT_COLOR.WHITE[3], FONT_COLOR.WHITE[4])
    overlayBtn:SetHighlightTextColor(FONT_COLOR.WHITE[1], FONT_COLOR.WHITE[2], FONT_COLOR.WHITE[3], FONT_COLOR.WHITE[4])
    overlayBtn:SetPushedTextColor(FONT_COLOR.WHITE[1], FONT_COLOR.WHITE[2], FONT_COLOR.WHITE[3], FONT_COLOR.WHITE[4])
    overlayBtn:SetDisabledTextColor(FONT_COLOR.WHITE[1], FONT_COLOR.WHITE[2], FONT_COLOR.WHITE[3], FONT_COLOR.WHITE[4])
    overlayBtn:SetExtent(100, 64)
    overlayBtn:SetText("DailyAge ")
    overlayBtn.style:SetFontSize(13)
    overlayBtn:Show(true)
    overlayBtn:AddAnchor("TOPRIGHT", "UIParent", -350, -10)
    function overlayBtn:OnClick()
        local showWnd = not dailyAgeWindow.questListWindow:IsVisible()
        dailyAgeWindow.questListWindow:Show(showWnd)
    end 
    overlayBtn:SetHandler("OnClick", overlayBtn.OnClick)
    dailyAgeWindow.overlayBtn = overlayBtn

    local tabInfo = {
        {
            validationCheckFunc = function()
                return true
            end,
            title = "Dashboard",
            subWindowConstructor = function(parent)
                CreateDashboardWindow(parent)
            end
        },
        -- {
        --     validationCheckFunc = function()
        --         return true
        --     end,
        --     title = "Honor Points",
        --     subWindowConstructor = function(parent)
        --         CreateHonorPointsWindow(parent)
        --     end
        -- },
        -- {
        --     validationCheckFunc = function()
        --         return true
        --     end,
        --     title = "Leadership",
        --     subWindowConstructor = function(parent)
        --         CreateLeadershipWindow(parent)
        --     end
        -- },
        {
            validationCheckFunc = function()
                return true
            end,
            title = "Quest Search",
            subWindowConstructor = function(parent)
                CreateSearchWindow(parent)
            end
        }
    }
    local questListWindow = api.Interface:CreateWindow("questListWindow", "Daily Age", 430, 600, tabInfo)
    questListWindow:AddAnchor("CENTER", "UIParent", 0, 0)
    questListWindow:Show(false)
    questListWindow:SetExtent(430, 600)
    local oldOnShow = questListWindow.OnShow
    function questListWindow:OnShow()
        oldOnShow(self)
        refreshDashboardCompletions(questListWindow)
        updateCompletedQuestLabels()
    end
    questListWindow:SetHandler("OnShow", questListWindow.OnShow)


    dailyAgeWindow.questListWindow = questListWindow


    updateCompletedQuestLabels() --> Fill quest labels
    dailyAgeWindow:Show(true)

    api.Log:Info("[DailyAge] Successfully loaded. Please find the DailyAge button in the top right of your screen.")
    api.On("UPDATE", OnUpdate)
	api.SaveSettings()
end

local function OnUnload()
	api.On("UPDATE", function() return end)
	if dailyAgeWindow ~= nil then 
        dailyAgeWindow:Show(false)
    end 
    
    dailyAgeWindow = nil
end

dailyAge_addon.OnLoad = OnLoad
dailyAge_addon.OnUnload = OnUnload

return dailyAge_addon
