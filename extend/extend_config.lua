-- ============================================================
--  pfQuest :: Extend Module :: ShowLoots Config
--  Fuente: Cliencer/pfExtend - adaptado para pfQuest integrado
--  El Séquito del Terror - DarckRovert
-- ============================================================

ItemQuality = {
    ["Poor"]      = 0,
    ["Common"]    = 1,
    ["Uncommon"]  = 2,
    ["Rare"]      = 3,
    ["Epic"]      = 4,
    ["Legendary"] = 5,
}

PfExtend_Config["ShowLoots"] = {}
PfExtend_Config_Index["ShowLoots"] = { "enable", "showNum", "itemQualityFilter", "showIds", "updateData" }
PfExtend_Config_Template["ShowLoots"] = {
    ["enable"]  = true,
    ["showNum"] = 5,
    ["showIds"] = true,
    ["itemQualityFilter"] = {
        ["selectTable"] = {
            ItemQuality.Poor,
            ItemQuality.Common,
            ItemQuality.Uncommon,
            ItemQuality.Rare,
            ItemQuality.Epic,
            ItemQuality.Legendary,
        },
        ["select"] = ItemQuality.Poor
    },
    ["updateData"] = function()
        return {
            text = pfExtend_Loc["Btn_updateData"],
            func = function()
                if PFEXShowLoots.UpdateDatabase() then
                    return pfExtend_Loc["Btn_updateSuccess"]
                else
                    return pfExtend_Loc["Btn_updateFailed"]
                end
            end
        }
    end
}


-- ============================================================
--  pfQuest :: Extend Module :: QuestHelper Config
-- ============================================================

PfExtend_Config["QuestHelper"] = {}
PfExtend_Config_Index["QuestHelper"] = { "enable", "updateData", "hideRace", "hideClass", "hideSkill", "hideEvent" }
PfExtend_Config_Template["QuestHelper"] = {
    ["enable"] = true,
    ["updateData"] = function()
        return {
            text = pfExtend_Loc["Btn_updateData"],
            func = function()
                if PFEXQuestHelper.UpdateDatabase() then
                    return pfExtend_Loc["Btn_updateSuccess"]
                else
                    return pfExtend_Loc["Btn_updateFailed"]
                end
            end
        }
    end,
    ["hideRace"]  = true,
    ["hideClass"] = true,
    ["hideSkill"] = true,
    ["hideEvent"] = false,
}


-- ============================================================
--  pfQuest :: Extend Module :: About Config
-- ============================================================

PfExtend_Config_Index["About"] = { "Author", "Version", "Github" }
PfExtend_Config_Template["About"] = {
    ["Author"]  = function() return { text = "El Séquito del Terror" } end,
    ["Version"] = function()
        local v = "5.3.2 [Lag-Free]"
        return { text = v }
    end,
    ["Github"]  = function() return { text = "github.com/DarckRovert/pfQuest-El-Sequito-del-Terror-Edition" } end,
}
-- Función de versión accesible globalmente para comparaciones internas
PfExtend_Config_Template["About"].Version = function()
    return "5.3.2"
end
