local hero = {}
local listHeros = {}

function CreateHero(choice)

    local typeHeroElement = getRandomType()

    hero = spriteManager.CreateSpriteHero(choice,6,32,32,32)
    hero.x = screenWidth-(64*5)+32 --(-5 colonnes+ la moitié de l'image)
    hero.y = (64*5)-32
    hero.height = 16
    hero.ID = choice
    hero.direction = -1
    hero.life = 300
    hero.visible = true
    hero.element = typeHeroElement
    hero.Hurt = function()
        if debug_mode == false then
            hero.life = math.floor(hero.life - 0.1)
            gameState.life = hero.life
        end
    end

    table.insert(listHeros, hero)
    table.insert(spriteManager.listSprites, hero)

    
    gameState.ID = hero.ID
    gameState.typeHeroElement = typeHeroElement
    gameState.life = hero.life
end


function hero.Load()
    CreateHero('blob')
    CreateHero('lapin')
end

function hero.Update(dt,pMap,choice,Monster)

    -- Traitement des items
    local nItem
    for nItem=1,#itemManager.liste_items do
        local item = itemManager.liste_items[nItem]

        if collideItem(hero,item) and item.pickup == false then

            print("item de type",item.type)
            local angle = math.angle(item.x, item.y, 200, 600)

            if item.type == 'changeType' then
                interfaceManager.nbrChangeType = interfaceManager.nbrChangeType + 1
                if interfaceManager.nbrChangeType > interfaceManager.maxchangeType then
                    item.pickup = false
                    interfaceManager.nbrChangeType = interfaceManager.maxchangeType
                    break
                else
                    if itemManager.liste_place.q == false then 
                        item.key = 'q'
                        item.x = interfaceManager.inventaire.slot[1].x
                        itemManager.liste_place.q = true
                    elseif itemManager.liste_place.s == false then 
                        item.key = 's'
                        item.x = interfaceManager.inventaire.slot[2].x
                        itemManager.liste_place.s = true
                    elseif itemManager.liste_place.d == false then 
                        item.key = 'd'
                        item.x = interfaceManager.inventaire.slot[3].x
                        itemManager.liste_place.d = true
                    end
                    -- même y pour tous
                    item.y = interfaceManager.inventaire.slot[1].y
                end
            end

            if item.type == 'changeType' then
                item.pickup = true
                sonItemMagie:play()
            else
                -- heal et collector
                if item.type == 'heal' then
                    SUCCESS.heal = true

                    succesDelock:play()
                    sonHeal:play()

                    if hero.life < 100 then
                        gameState.life = 100
                        hero.life = 100
                    else
                        gameState.score = gameState.score + 1
                    end

                    CreeAnim(hero.x,hero.y)
                else
                    succesDelock:play()
                    SUCCESS.luck = true
                end

                item.supprime = true
            end
        end
    end

    for k, v in ipairs(listHeros) do
        if v.ID == choice then
            hero = listHeros[k]
            gameState.typeHeroElement = hero.element
            break
        end
    end

    hero.currentFrame = hero.currentFrame + 3*dt
    if hero.currentFrame >= #hero.images + 1 then
        hero.currentFrame = 1
    end

    -- Réduction de la vélocité 
    hero.vx = hero.vx * 0.9
    hero.vy = hero.vy * 0.9

    if math.abs(hero.vx) < 0.01 then hero.vx = 0 end
    if math.abs(hero.vy) < 0.01 then hero.vy = 0 end

    -- Application de vélocité
    hero.x = hero.x + hero.vx*dt*100
    hero.y = hero.y + hero.vy*dt*100

    if love.keyboard.isDown('up','right','down','left') then
        if love.keyboard.isDown("right") then
            hero.vx = hero.vx + 0.5
            hero.direction = 1
        end
        if love.keyboard.isDown("left") then
            hero.vx = hero.vx - 0.5
            hero.direction = -1
        end
        if love.keyboard.isDown("up") then
            hero.vy = hero.vy - 0.5
        end
        if love.keyboard.isDown("down") then
            hero.vy = hero.vy + 0.5
        end

        local nbColcollision = math.floor(hero.x/pMap.widthCol)+1
        local nbLignecollision = math.floor(hero.y/pMap.heightCol)+1
        local posMapHero = pMap.gridGame[nbLignecollision][nbColcollision]
        hero.positionMap = posMapHero
        
        -- tp
        if posMapHero == 1.2 or posMapHero == 3.2 then
            pMap.image = pMap.grid..'_2'
            pMap.grid_lvl = 2 
        elseif posMapHero == 1.1 or posMapHero == 3.1 then
            pMap.image = pMap.grid..'_4'
            pMap.grid_lvl = 4
        elseif posMapHero == 2.1 or posMapHero == 4.1 then
            pMap.image = pMap.grid..'_1'
            pMap.grid_lvl = 1
        elseif posMapHero == 2.2 or posMapHero == 4.2 then
            pMap.image = pMap.grid..'_3'
            pMap.grid_lvl = 3
        end  

        local posTeleport = {1.1,1.2,2.1,2.2,3.1,3.2,4.1,4.2}
        if inTable(posTeleport, posMapHero) then
            for k, v in ipairs(spriteManager.listMonsters) do
                v.supprime = true
            end

            spriteManager.newType = getRandomType()
            for k, v in ipairs(itemManager.liste_items) do
                if v.key == nil then
                    v.supprime = true
                end 
            end

            spriteManager.listeTirs = {}
            itemManager.liste_items = {}
            gameState.SUCCESS = {}
            pMap.resetPersoVendeurVisibility()
            Monster.Reset()
            Monster.Load()

        end
    end

    if hero.x > 768 then
        hero.x = 767
    end
    if hero.x < 64 then
        hero.x = 65
    end
    if hero.y < 192 then
        hero.y = 193
    end
    if hero.y > 640 then
        hero.y = 639
    end

    -- Gestion des tirs
    for n=#spriteManager.listeTirs,1,-1 do
        local tir = spriteManager.listeTirs[n]
        tir.x = tir.x + tir.vx*dt*160
        tir.y = tir.y + tir.vy*dt*160

        if tir.type == 'monster' then
            for nMonster=#spriteManager.listMonsters,1,-1 do
                local monster = spriteManager.listMonsters[nMonster]

                if collide(tir,hero) then

                    sonTouch:play()

                    if hero.element == monster.element then
                        -- même élément, on soigne le héros
                        hero.life = math.floor(hero.life + 6)
                        gameState.life = hero.life

                    -- element contraire, on ne fait rien    
                    elseif hero.element == 'feu' and tir.element == 'plante' then
                        -- nothing
                    elseif hero.element == 'plante' and tir.element == 'eau' then
                        -- nothing
                    elseif hero.element == 'eau' and tir.element == 'feu' then
                        -- nothing 
                    -- le reste
                    elseif hero.element == 'feu' and tir.element == 'eau' then
                        hero.life = math.floor(hero.life - 6)
                        gameState.life = hero.life
                    elseif hero.element == 'plante' and tir.element == 'feu' then
                        hero.life = math.floor(hero.life - 6)
                        gameState.life = hero.life
                    elseif hero.element == 'eau' and tir.element == 'plante' then
                        hero.life = math.floor(hero.life - 6)
                        gameState.life = hero.life
                    end

                    if hero.life > 300 then
                        hero.life = 300
                        gameState.life = hero.life
                    end

                    tir.supprime = true
                    table.remove(spriteManager.listeTirs, n)
                end
            end
        end
    
        if tir.type == 'hero' then

            local nMonster
            for nMonster=#spriteManager.listMonsters,1,-1 do
                local monster = spriteManager.listMonsters[nMonster]
                local distance = math.dist(monster.x, monster.y, tir.x, tir.y)
                if distance < tir.range then
                    tir.target = monster
                    local angle = math.angle(hero.x, hero.y, tir.target.x, tir.target.y)
                    tir.vx = tir.speed* math.cos(angle)
                    tir.vy = tir.speed* math.sin(angle)
                end

                if collide(tir,monster) then

                    -- monstre elite en mode bouclier, le tir ricoche
                    if monster.isBoss and monster.isInvincible then
                        tir.speed = -2
                    else
                        tir.supprime = true
                        table.remove(spriteManager.listeTirs, n)
                    end
   
                    if monster.isInvincible == false then
                        if monster.element == tir.element then
                            -- même élément, on soigne le monstre
                            monster.energie = monster.energie + 1
                        -- normal
                        elseif monster.element == 'feu' and tir.element == 'plante' then
                            monster.energie = monster.energie - 1
                        elseif monster.element == 'plante' and tir.element == 'eau' then  
                            monster.energie = monster.energie - 1
                        elseif monster.element == 'eau' and tir.element == 'feu' then  
                            monster.energie = monster.energie - 1
                        -- très efficace
                        elseif monster.element == 'plante' and tir.element == 'feu' then  
                            monster.energie = monster.energie - 2
                        elseif monster.element == 'eau' and tir.element == 'plante' then  
                            monster.energie = monster.energie - 2
                        elseif monster.element == 'feu' and tir.element == 'eau' then
                            monster.energie = monster.energie - 2
                        end

                        sonTouch:play()
                    end    
                    
                    if monster.energie <= 0 then
                        sonWin:play()

                        if monster.isBoss then
                            gameState.score = gameState.score + 25
                        else
                            gameState.score = gameState.score + 1
                        end
     
                        local drop = love.math.random(1,100)
                        monster.x = math.floor(monster.x)

                        -- SUCCESS
                        if gameState.score > 50 and gameState.score < 99 and SUCCESS.kill == false then
                            SUCCESS.kill = true
                            succesDelock:play()
                        end

                        if gameState.score > 100  and SUCCESS.killMax == false then
                            SUCCESS.killMax = true
                            succesDelock:play()
                        end

                        if monster.isBoss and SUCCESS.killElite == false then
                            SUCCESS.killElite = true
                            succesDelock:play()
                        end

                        if drop > 95 then
                           itemManager.CreerItem('collector',monster.x,monster.y,0,0)
                        elseif drop > 55 then
                            itemManager.CreerItem('changeType',monster.x,monster.y,0,0)
                        elseif drop <= 55 then
                            itemManager.CreerItem('heal',monster.x,monster.y,0,0)
                        end
                        -- end SUCCESS

                        monster.supprime = true
                        table.remove(spriteManager.listMonsters, nMonster)
                    end
                end
            end
        end
    
        -- Vérifier si le tir est en dehors de l'écran
        if (tir.y < (64*3) -32 -- -3 col - moitié de colonne
            or tir.y > screenHeight-(64*2)
            or tir.x < 64
            or tir.x > screenWidth-(64*4)
            ) 
            and tir.supprime == false then
            sonCollision:play()

            tir.supprime = true
            table.remove(spriteManager.listeTirs, n)
        end
    end

    if hero.life <= 0 then
        SCENE = 'gameover'
        itemManager.Reset()
        spriteManager.listeTirs = {}
        pMap.resetPersoVendeurVisibility()
        Monster.Reset()
    end

    for n=1,#itemManager.liste_items do
        local i = itemManager.liste_items[n]
        i.currentFrame = i.currentFrame + 4*dt
        if i.currentFrame >= #i.images + 1 then
            i.currentFrame = 1
        end

        frameCurrent = i.images[math.floor(i.currentFrame)]
    end

    for n=1,#spriteManager.listeAnims do
        local sprite = spriteManager.listeAnims[n]
        if sprite then
            if sprite.maxFrame > 1 then
                sprite.frame = sprite.frame + 0.1
                if math.floor(sprite.frame) > sprite.maxFrame then
                    sprite.supprime = true
                    table.remove(spriteManager.listeAnims, n)
                else
                    sprite.image = sprite.listeFrames[math.floor(sprite.frame)]
                end
            end
        end
    end

    -- si le joueur kill l'ensemble des monstres de la map: gain bonus de 25 points
    local mapIsEmpty = false
    if #spriteManager.listMonsters == 0 then
        gameState.mapIsEmpty = true
    end

    if gameState.mapIsEmpty == true and scoreSet == false then
        gameState.setScore()
        scoreSet = true
    end
end

function hero.Draw()
    local frameArrondie = math.floor(hero.currentFrame)
    love.graphics.draw(hero.image, hero.images[frameArrondie],hero.x, hero.y,0,hero.direction,1,16,16)
    love.graphics.circle('fill', hero.x, hero.y, 2)

    local n 
    for n=1,#itemManager.liste_items do
        local i = itemManager.liste_items[n]
        if i.shine == true then
            love.graphics.draw(frameCurrent, i.x,i.y,0,2,2,i.width/2,i.height/2)
        end
    end
    for n=1,#spriteManager.listeTirs do
        local s = spriteManager.listeTirs[n]
        love.graphics.draw(s.image, s.x, s.y, 0,2,2,s.width/2,s.height/2)
    end

    for n=1,#spriteManager.listeAnims do
        local s = spriteManager.listeAnims[n]
        love.graphics.draw(s.image,hero.x, hero.y, 0,2,2,s.width/2,s.height/2)
    end

    font = love.graphics.setNewFont( 20 )

    -- débug
    if debug_mode then
        love.graphics.circle('line', hero.x, hero.y, 120)
        love.graphics.print('sprites : '..#spriteManager.listSprites..' - Tir :'..#spriteManager.listeTirs..' - Sprites anim :'..#spriteManager.listeAnims.." - Monster :"..#spriteManager.listMonsters,0,0)
    end
end

function hero.Keypressed(key,Map,heroData,dt)
    if key == "space" then
        heroData.CreeTir('hero',hero.element,hero.x,hero.y,hero.direction,0)
    end

    if key == "space" and hero.positionMap == 4 and Map.isPersoVisible then
        SCENE = 'buy'
        shop.cantBuy = false
    end
end

function hero.useItem(pPlaceItem, pListTypeChange, pListItems, pListSprites)
    local n
    for n=#pListTypeChange,1,-1 do
        local item = pListTypeChange[n]
        if item.key == pPlaceItem then
            hero.element = item.newElementType
            gameState.typeHeroElement = item.newElementType
            item.supprime = 1

            -- on indique que la place est libre
            itemManager.liste_place[pPlaceItem] = false
            interfaceManager.nbrChangeType = interfaceManager.nbrChangeType -1
            table.remove(pListTypeChange,n)
        end
    end

    for n=#pListItems,1,-1 do
        local item = pListItems[n]
        if item.key == pPlaceItem then
            item.supprime = 1
            table.remove(pListItems,n)
        end
    end

    for n=#pListSprites,1,-1 do
        local item = pListSprites[n]
        if item.key == pPlaceItem then
            item.supprime = 1
            table.remove(pListSprites,n)
        end
    end
end

--tir, puis monster
function collide(a1,a2)
    local x1,y1,x2,y2
    x1 = a1.x-a1.width
    x2 = a2.x-a2.width/2
    y1 = a1.y-a1.height
    y2 = a2.y-a2.height/2

    return x1 < x2+a2.width/2 and
           x2 < x1+a1.width/2 and
           y1 < y2+a2.height/2 and
           y2 < y1+a1.height/2
end

-- hero, item
function collideItem(a1,a2)
    local x1,y1,x2,y2
    x1 = a1.x-a1.width
    x2 = a2.x-a2.width
    y1 = a1.y-a1.height
    y2 = a2.y-a2.height

    return x1 < x2+a2.width and
           x2 < x1+a1.width and
           y1 < y2+a2.height and
           y2 < y1+a1.height
end

function hero.CreeTir(pType,pNomImage,pX,pY,pVitesseX,pVitesseY)
    
    local nameFile = 'tir'..pNomImage
    local tir = spriteManager.CreateSpriteTirs(nameFile,pX,pY)
    tir.type = pType
    tir.vx = pVitesseX
    tir.vy = pVitesseY
    tir.range = 120
    tir.speed = 2
    tir.element = pNomImage

    table.insert(spriteManager.listeTirs, tir)
    table.insert(spriteManager.listSprites, tir)

    sonShoot:play()
end

function CreeAnim(pX,pY)
    local sprite = spriteManager.CreateSpriteAnim("potion1", pX, pY)
    sprite.listeFrames = potion
    sprite.maxFrame = 5

    table.insert(spriteManager.listeAnims, sprite)
    table.insert(spriteManager.listSprites, sprite)
end

function hero.Reset()
    listHeros = {}
end

heros = {hero, listHeros}

return heros