-- MAPS DE JEU
local maps = {}
maps = require('includes/maps')

local grille = {1,2,3,4,5,6}
local grille_begin = grille[love.math.random(#grille)]

local map = {
    image = grille_begin..'_1',
    x = 0,
    y = 0,
    grid = grille_begin,
    grid_lvl = 1,
    col = 23,
    row = 21,
    widthCol = 64,
    heightCol = 64,
    frames = {},
    activeMenuPersoVendeur = false
}

local imgMap_1_1 = love.graphics.newImage('assets/maps/1_1.png')
local imgMap_1_2 = love.graphics.newImage('assets/maps/1_2.png')
local imgMap_1_3 = love.graphics.newImage('assets/maps/1_3.png')
local imgMap_1_4 = love.graphics.newImage('assets/maps/1_4.png')

local imgMap_2_1 = love.graphics.newImage('assets/maps/2_1.png')
local imgMap_2_2 = love.graphics.newImage('assets/maps/2_2.png')
local imgMap_2_3 = love.graphics.newImage('assets/maps/2_3.png')
local imgMap_2_4 = love.graphics.newImage('assets/maps/2_4.png')

local imgMap_3_1 = love.graphics.newImage('assets/maps/3_1.png')
local imgMap_3_2 = love.graphics.newImage('assets/maps/3_2.png')
local imgMap_3_3 = love.graphics.newImage('assets/maps/3_3.png')
local imgMap_3_4 = love.graphics.newImage('assets/maps/3_4.png')

local imgMap_4_1 = love.graphics.newImage('assets/maps/4_1.png')
local imgMap_4_2 = love.graphics.newImage('assets/maps/4_2.png')
local imgMap_4_3 = love.graphics.newImage('assets/maps/4_3.png')
local imgMap_4_4 = love.graphics.newImage('assets/maps/4_4.png')

local imgMap_5_1 = love.graphics.newImage('assets/maps/5_1.png')
local imgMap_5_2 = love.graphics.newImage('assets/maps/5_2.png')
local imgMap_5_3 = love.graphics.newImage('assets/maps/5_3.png')
local imgMap_5_4 = love.graphics.newImage('assets/maps/5_4.png')

local imgMap_6_1 = love.graphics.newImage('assets/maps/6_1.png')
local imgMap_6_2 = love.graphics.newImage('assets/maps/6_2.png')
local imgMap_6_3 = love.graphics.newImage('assets/maps/6_3.png')
local imgMap_6_4 = love.graphics.newImage('assets/maps/6_4.png')

map.grilleName = {'Juin','Décembre','Mars','Novembre','Octobre','Janvier'}

function map.Load()

    map.activeMenuPersoVendeur = false
    personnageVendeur = love.graphics.newImage('assets/interface/succes/pnjvendeur.png')
    map.width = imgMap_1_1:getWidth()
    map.height = imgMap_1_1:getHeight()
    map.resetPersoVendeurVisibility()

    if map.image == "1_1" then
        imgMap = imgMap_1_1
    end
    if map.image == '2_1' then
        imgMap = imgMap_2_1
    end
    if map.image == '3_1' then
        imgMap = imgMap_3_1
    end
    if map.image == '4_1' then
        imgMap = imgMap_4_1
    end
    if map.image == '5_1' then
        imgMap = imgMap_5_1
    end
    if map.image == '6_1' then
        imgMap = imgMap_6_1
    end
end

function map.Update(dt)
    map.gridGame = maps[map.grid][map.grid_lvl]

    -- map 1
    if map.image == '1_1' then
        imgMap = imgMap_1_1
    elseif map.image == '1_2' then
        imgMap = imgMap_1_2
    elseif map.image == '1_3' then
        imgMap = imgMap_1_3
    elseif map.image == '1_4' then
        imgMap = imgMap_1_4
    end
    -- map 2
    if map.image == '2_1' then
        imgMap = imgMap_2_1
    elseif map.image == '2_2' then
        imgMap = imgMap_2_2
    elseif map.image == '2_3' then
        imgMap = imgMap_2_3
    elseif map.image == '2_4' then
        imgMap = imgMap_2_4
    end
    -- map 3
    if map.image == '3_1' then
        imgMap = imgMap_3_1
    elseif map.image == '3_2' then
        imgMap = imgMap_3_2
    elseif map.image == '3_3' then
        imgMap = imgMap_3_3
    elseif map.image == '3_4' then
        imgMap = imgMap_3_4
    end
    -- map 4
    if map.image == '4_1' then
        imgMap = imgMap_4_1
    elseif map.image == '4_2' then
        imgMap = imgMap_4_2
    elseif map.image == '4_3' then
        imgMap = imgMap_4_3
    elseif map.image == '4_4' then
        imgMap = imgMap_4_4
    end
    -- map 5
    if map.image == '5_1' then
        imgMap = imgMap_5_1
    elseif map.image == '5_2' then
        imgMap = imgMap_5_2
    elseif map.image == '5_3' then
        imgMap = imgMap_5_3
    elseif map.image == '5_4' then
        imgMap = imgMap_5_4
    end
    -- map 6
    if map.image == '6_1' then
        imgMap = imgMap_6_1
    elseif map.image == '6_2' then
        imgMap = imgMap_6_2
    elseif map.image == '6_3' then
        imgMap = imgMap_6_3
    elseif map.image == '6_4' then
        imgMap = imgMap_6_4
    end
end

function map.Draw()
    love.graphics.draw(imgMap, 1, map.x, map.y)
    if map.isPersoVisible then
        love.graphics.draw(personnageVendeur,448,160,0,2)
    end

    if debug_mode then
    -- grille de test
        for n=1,15 do
            i = 64*n
            love.graphics.print(tostring(i),i,50,screenWidth)
            love.graphics.line(i,0,i,screenHeight)
            love.graphics.line(0,i,screenWidth,i)
        end
        --832
        --704
    end
end

function map.resetPersoVendeurVisibility()
    local random = love.math.random(1,45)
    map.isPersoVisible = false
    if random > 40 then
        map.isPersoVisible = true
    end
end

return map