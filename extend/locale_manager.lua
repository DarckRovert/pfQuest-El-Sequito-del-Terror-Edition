-- ============================================================
--  pfQuest :: Extend Module :: Localization Manager
--  El Séquito del Terror - DarckRovert
-- ============================================================

-- El sistema de localización de pfExtend es independiente de
-- pfQuest_Loc para no colisionar con las claves ya existentes.

pfExtend_Locales = pfExtend_Locales or {}

-- Selecciona el idioma activo con fallback a enUS
pfExtend_Loc = setmetatable(
    pfExtend_Locales[GetLocale()] or pfExtend_Locales["esMX"] or pfExtend_Locales["enUS"] or {},
    {
        __index = function(tab, key)
            -- Busca en enUS como fallback
            local fallback = pfExtend_Locales["enUS"]
            if fallback and fallback[key] then
                return fallback[key]
            end
            return tostring(key)
        end
    }
)
