-- ============================================================
--  pfQuest :: Extend Module :: Global State & Utilities
--  Integración de pfExtend en pfQuest
--  El Séquito del Terror - DarckRovert
-- ============================================================

pfExtend_Locales         = {}
PfExtend_Database        = {}
PfExtend_Config          = {}
PfExtend_Config_Template = {}
PfExtend_Config_Index    = {}
PfExtend_Global          = {}

-- Ruta base del addon (ahora dentro de pfQuest)
pfExtend_Path = "Interface\\AddOns\\pfQuest"

-- ============================================================
-- Utilidades de tabla
-- ============================================================

function table.shallowCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = value["select"]
        else
            copy[key] = value
        end
    end
    return copy
end

table.unique = function(t)
    local seen   = {}
    local result = {}
    for _, v in ipairs(t) do
        if not seen[v] then
            seen[v] = true
            table.insert(result, v)
        end
    end
    return result
end

table.add = function(t1, t2)
    for _, v in ipairs(t2) do
        table.insert(t1, v)
    end
    return t1
end

table.countNum = function(t)
    local ret = 0
    for k, v in pairs(t) do
        ret = ret + 1
    end
    return ret
end

table.contain = function(tbl, value)
    if tbl == nil then return false end
    for _, v in pairs(tbl) do
        if v == value then return true end
    end
    return false
end

table.IsEmpty = function(tbl)
    for k, v in pairs(tbl) do
        return false
    end
    return true
end

-- ============================================================
-- Sistema de configuración
-- ============================================================

PfExtend_Global.ReadSetting = function(module, config)
    if PfExtend_Config[module] == nil then
        PfExtend_Config[module] = table.shallowCopy(PfExtend_Config_Template[module])
        return PfExtend_Config_Template[module][config]
    end
    if PfExtend_Config[module][config] == nil then
        if type(PfExtend_Config_Template[module][config]) == "table" then
            PfExtend_Config[module][config] = PfExtend_Config_Template[module][config]["select"]
        else
            PfExtend_Config[module][config] = PfExtend_Config_Template[module][config]
        end
    end
    return PfExtend_Config[module][config]
end

-- Ordenar tabla por clave o valor
PfExtend_Global.sortKeyValueTable = function(t, sortBy, descending)
    sortBy    = sortBy    or "key"
    descending = descending or false
    local arr = {}
    for k, v in pairs(t) do
        table.insert(arr, { key = k, value = v })
    end
    local cmp
    if sortBy == "key" then
        cmp = function(a, b)
            local ak, bk = a.key, b.key
            if type(ak) ~= type(bk) then return type(ak) < type(bk) end
            if ak == bk then return false end
            
            if descending then return ak > bk end
            return ak < bk
        end
    else
        cmp = function(a, b)
            local av, bv = a.value, b.value
            if type(av) ~= type(bv) then return type(av) < type(bv) end
            if av == bv then return false end
            
            if descending then return av > bv end
            return av < bv
        end
    end
    table.sort(arr, cmp)
    return arr
end
