function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

function inTable(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then return key end
    end
    return false
end

function getRandomType()
    local newType = listeTypeElement[love.math.random(#listeTypeElement)]
    return newType
end