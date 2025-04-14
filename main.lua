local api = require("api")

local dailyAge_addon = {
	name = "DailyAge",
	author = "Michaelqt",
	version = "1.0",
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



local function updateCompletedQuestLabels(searchText)
    local questList = dailyAgeWindow.questListWindow.questScrollList
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
        dailyAgeWindow.questListWindow.questScrollList:UpdateView()
        for _, item in pairs(dailyAgeWindow.questListWindow.questScrollList:GetListCtrlItems()) do
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
            dailyAgeWindow.questListWindow.questSearchTextEdit:SetText("")
        end 
    end 
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

    local questListWindow = api.Interface:CreateWindow("questListWindow", "Daily Age")
    questListWindow:AddAnchor("CENTER", "UIParent", 0, 0)
    questListWindow:Show(false)
    questListWindow:SetExtent(430, 600)
    dailyAgeWindow.questListWindow = questListWindow

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
    questScrollList:AddAnchor("TOPLEFT", questListWindow, -10, 40)
    questScrollList:AddAnchor("BOTTOMRIGHT", questListWindow, -10, -10)
    questScrollList.scroll:AddAnchor("TOPRIGHT", questScrollList, 0, 0)
    questScrollList.scroll:AddAnchor("BOTTOMRIGHT", questScrollList, 0, 0)
    -- questScrollList.scroll:SetWheelMoveStep(0)
    -- questScrollList.scroll:SetButtonMoveStep(0)
    questScrollList.pageControl:Show(false)
    questScrollList:InsertColumn("", 300, 0, DataSetFunc, nil, nil, LayoutSetFunc)
    questScrollList:InsertRows(25, true)
    questScrollList:SetColumnHeight(40)
    questListWindow.questScrollList = questScrollList
    updateCompletedQuestLabels() --> Fill quest labels
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
