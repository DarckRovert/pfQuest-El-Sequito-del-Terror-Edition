-- ============================================================
--  pfQuest :: Extend Module :: Localización en Español (esES)
--  Traducción completa - El Séquito del Terror - DarckRovert
-- ============================================================

pfExtend_Locales["esES"] = {
    -- Ventanas
    ["windowTitle_ShowLoots"]   = "|cff33ffccMostrar|rBotín",
    ["windowTitle_QuestHelper"] = "|cff33ffccAyudante de|rMisiones",
    ["windowTitle_Config"]      = "|cff33ffccC|ronfiguración",

    -- Botín / Tooltips
    ["Looted from"]             = "Obtenido de",
    ["Sold by"]                 = "Vendido por",
    ["ToolTips_and"]            = "y",
    ["ToolTips_others"]         = "otros",
    ["No loots"]                = "Sin botín",
    ["All %d loots"]            = "Todos: %d botines",
    ["No %s or better loots"]   = "Sin botines %s o mejores",
    ["%d %s or better loots(of %d)"] = "%d botines %s o mejores (de %d)",
    ["... %d loots hidden ..."] = "... %d botines ocultos ...",
    ["Press <Alt> for details"] = "Presiona <Ctrl+Alt> para ver detalles",

    -- UI General
    ["Close"]                   = "Cerrar",
    ["Hide browser window"]     = "Ocultar ventana",
    ["Search"]                  = "Buscar",
    ["Show pfQuest Browser"]    = "Abrir Navegador pfQuest",
    ["Setting"]                 = "Configurar",
    ["Open Config Window"]      = "Abrir configuración",
    ["Click to fix on the map"] = "Clic para fijar en el mapa",
    ["Click to track the quest on the other map"] =
        "Clic para rastrear la misión en el otro mapa",
    ["Hold <Ctrl> and Click to track Pre-quest on the other map"] =
        "Mantén <Ctrl> y haz clic para rastrear la pre-misión en el otro mapa",

    -- Flags de misiones
    ["QuestHelper_FLAG_Finished"]   = "(Completada)",
    ["QuestHelper_FLAG_Active"]     = "(Activa)",
    ["QuestHelper_FLAG_Race"]       = "(Raza)",
    ["QuestHelper_FLAG_Class"]      = "(Clase)",
    ["QuestHelper_FLAG_Skill"]      = "(Habilidad)",
    ["QuestHelper_FLAG_Event"]      = "(Evento)",
    ["QuestHelper_FLAG_Prereq"]     = "(Prerequisito)",
    ["QuestHelper_FLAG_High-Level"] = "(Nivel Alto)",
    ["QuestHelper_FLAG_Hidden"]     = "(Oculta)",
    ["QuestHelper_FLAG_Available"]  = "(Disponible)",

    -- Configuración - Acerca de
    ["Config_About"]             = "Acerca de",
    ["Config_About_Author"]      = "Autor",
    ["Config_About_Version"]     = "Versión",
    ["Config_About_Github"]      = "Github",

    -- Configuración - ShowLoots
    ["Config_ShowLoots"]         = "MostrarBotín",
    ["Config_ShowLoots_enable"]  = "Activado",
    ["Config_ShowLoots_showNum"] = "Número de líneas en descripciones emergentes",
    ["Config_ShowLoots_showIds"] = "Mostrar ID del objeto",
    ["Config_ShowLoots_itemQualityFilter"]   = "Filtro de calidad de objetos",
    ["Config_ShowLoots_itemQualityFilter_0"] = "|cff9d9d9dPobre",
    ["Config_ShowLoots_itemQualityFilter_1"] = "|cffffffffNormal",
    ["Config_ShowLoots_itemQualityFilter_2"] = "|cff1eff00Poco común",
    ["Config_ShowLoots_itemQualityFilter_3"] = "|cff0070ddRaro",
    ["Config_ShowLoots_itemQualityFilter_4"] = "|cffa335eeÉpico",
    ["Config_ShowLoots_itemQualityFilter_5"] = "|cffff8000Legendario",
    ["Config_ShowLoots_updateData"] = "Base de Datos",

    -- Configuración - QuestHelper
    ["Config_QuestHelper"]              = "AyudanteMisiones",
    ["Config_QuestHelper_enable"]       = "Activado",
    ["Config_QuestHelper_updateData"]   = "Base de Datos",
    ["Config_QuestHelper_hideRace"]     = "Ocultar misiones de otra RAZA",
    ["Config_QuestHelper_hideClass"]    = "Ocultar misiones de otra CLASE",
    ["Config_QuestHelper_hideSkill"]    = "Ocultar misiones de otra HABILIDAD",
    ["Config_QuestHelper_hideEvent"]    = "Ocultar misiones de EVENTO",

    -- Botones de acción
    ["Btn_updateData"]      = "Actualizar",
    ["Btn_updateSuccess"]   = "¡Éxito!",
    ["Btn_updateFailed"]    = "Error",
    ["Update_Error_Hint"]   = "Error: base de datos de pfQuest no encontrada. Verifica que pfQuest esté instalado.",
    ["Update_Success_Hint"] = "¡Base de datos de pfQuest Extend actualizada correctamente!",

    -- Ordenamiento
    ["Sort_Chance"]  = "Probabilidad",
    ["Sort_ID"]      = "ID",
    ["Sort_Quality"] = "Calidad",

    -- General
    ["Quests"] = "Misiones",
}

-- Alias para México
pfExtend_Locales["esMX"] = pfExtend_Locales["esES"]
