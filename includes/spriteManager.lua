local spriteManager = {
    listSprites = {},
    listMonsters = {},
    listeAnims = {},
    listeTirs = {},
    imgElite = {
        feu = {
            image = love.graphics.newImage('assets/player/bossplante.png'),
            images = {}
        },
        eau = {
            image = love.graphics.newImage('assets/player/bosseau.png'),
            images = {}
        },
        plante = {
            image = love.graphics.newImage('assets/player/bossfeu.png'),
            images = {}
        },
        mercure = {
            image = love.graphics.newImage('assets/player/bossmercure.png'),
            images = {}
        },
    },

    newType = getRandomType()
}

local pMarge = 0
for i=1, 6 do 
    spriteManager.imgElite.feu.images[i] = love.graphics.newQuad(pMarge, 0, 106, 152, spriteManager.imgElite.feu.image:getWidth(), spriteManager.imgElite.feu.image:getHeight())
    spriteManager.imgElite.eau.images[i] = love.graphics.newQuad(pMarge, 0, 106, 152, spriteManager.imgElite.eau.image:getWidth(), spriteManager.imgElite.eau.image:getHeight())
    spriteManager.imgElite.plante.images[i] = love.graphics.newQuad(pMarge, 0, 106, 152, spriteManager.imgElite.plante.image:getWidth(), spriteManager.imgElite.plante.image:getHeight())
    spriteManager.imgElite.mercure.images[i] = love.graphics.newQuad(pMarge, 0, 106, 152, spriteManager.imgElite.mercure.image:getWidth(), spriteManager.imgElite.mercure.image:getHeight())
    pMarge = pMarge+106
end

potion = {}
for n=1,5 do
    potion[n] = love.graphics.newImage('assets/interface/effects/potion'..n..'.png')
end

function spriteManager.CreateSpriteMonster(pType,pImageFile,pNbFrames,pMargeX,quadX,quadY,typeElement)

    local sprite = {}
    sprite.type = pType
    sprite.images = {}
    sprite.currentFrame = 1
    sprite.supprime = false
    sprite.isMobFixe = false

    sprite.element = pImageFile
    local fileName = pImageFile..".png"
    
    sprite.image = love.graphics.newImage(fileName)
 
    if sprite.type  == 'boss' then
        spriteManager.imgElite[typeElement].image = sprite.image
    end

    sprite.width = quadX
    sprite.height = quadY

    local i
    local pMarge = 0
    for i=1, pNbFrames do 
        sprite.images[i] = love.graphics.newQuad(pMarge, 0, quadX, quadY, sprite.image:getWidth(),sprite.image:getHeight())
        pMarge = pMarge+pMargeX
    end

    if sprite.type =='boss' then
        spriteManager.imgElite[typeElement].images = sprite.images
    end

    sprite.y = 0
    sprite.x = 0
    sprite.vx = 0
    sprite.vy = 0

    return sprite
end

function spriteManager.CreateSpriteHero(pChoice,pNbFrames,pMargeX,quadX,quadY)

    local sprite = {}
    local pathImg = 'assets/player/'..pChoice..'_player.png'
    
    sprite.type = 'hero'
    sprite.images = {}
    sprite.currentFrame = 1
    sprite.supprime = false
    sprite.image = love.graphics.newImage(pathImg)
    sprite.width = quadX
    sprite.height = quadY
    sprite.vx = 0
    sprite.vy = 0
    sprite.x = 0
    sprite.y = 0

    local i
    local pMarge = 0
    for i=1, pNbFrames do 
        sprite.images[i] = love.graphics.newQuad(pMarge, 0, quadX, quadY, sprite.image:getWidth(), sprite.image:getHeight())
        pMarge = pMarge+pMargeX
    end

    return sprite
end

function spriteManager.CreateSpriteAnim(pNomImage,pX,pY)
    sprite = {}
    sprite.x = pX
    sprite.y = pY
    sprite.image = love.graphics.newImage("assets/interface/effects/"..pNomImage..".png")
    sprite.width = sprite.image:getWidth()
    sprite.height = sprite.image:getHeight()
    sprite.frame = 1
    sprite.listeFrames = potion
    sprite.maxFrame = 1
    sprite.supprime = false
    return sprite
end

function spriteManager.CreateSpriteTirs(pNomImage,pX,pY)
    sprite = {}
    sprite.x = pX
    sprite.y = pY
    sprite.image = love.graphics.newImage("assets/interface/tirs/"..pNomImage..".png")
    sprite.width = sprite.image:getWidth()
    sprite.height = sprite.image:getHeight()
    sprite.frame = 1
    sprite.maxFrame = 1
    sprite.supprime = false
    return sprite
end

local timer_to_activate_shield = 0
local timer_shield_actif = 0
local timer_shield_activate = love.math.random(5,25)
local timer_random_shield = love.math.random(20,25)

function spriteManager.UpdateMonster(MONSTER_STATES,pMonster,hero,dt)
    -- etat conditionnel
    timer_to_activate_shield = timer_to_activate_shield+dt

    if pMonster.isBoss and timer_to_activate_shield > timer_random_shield and pMonster.energie < 40 then

        timer_to_activate_shield = timer_to_activate_shield+dt/16

        pMonster.state = MONSTER_STATES.SHIELD
        timer_to_activate_shield = 0
    end

    if timer_to_activate_shield > 25 then
        timer_to_activate_shield = 0
    end
    if pMonster.isBoss and pMonster.energie <= 20 and pMonster.switch == false then
        pMonster.state = MONSTER_STATES.SWITCH
    end

    if pMonster.isMobFixe then
        pMonster.state = MONSTER_STATES.SHOOT
    end

    local j
    for i,sprite in ipairs(spriteManager.listSprites) do

        if sprite.type == 'hero' and sprite.visible == true then
            if sprite.ID  == hero then
                pMonster.target = sprite
            end
        end
    end

    -------------------------------
    -- si ne fait rien
    if pMonster.state == MONSTER_STATES.NONE then
        pMonster.state = MONSTER_STATES.CHANGEDIR
    -- rôde    
    elseif pMonster.state == MONSTER_STATES.WALK then
        -- COLLISIONS WITH BORDER
        local bCollide = false
        if pMonster.x < 64 then
            pMonster.x = 64
            bCollide = true
        end       
        if pMonster.x > screenWidth-(64*4) then
            pMonster.x = screenWidth-(64*4)
            bCollide = true
        end
        if pMonster.y < (64*3) then
            pMonster.y = 64*3
            bCollide = true
        end       
        if pMonster.y > screenHeight-(64*3) then
            pMonster.y = screenHeight-(64*3)
            bCollide = true
        end

        if bCollide then
            pMonster.state = MONSTER_STATES.CHANGEDIR 
        end

        -- LOOK HUMAIN
        local i
        for i,sprite in ipairs(spriteManager.listSprites) do

            if sprite.type == 'hero' and sprite.visible == true then
                if sprite.ID  == hero then
                    local distance = math.dist(pMonster.x, pMonster.y, sprite.x, sprite.y)
                    if distance < pMonster.range and pMonster.isMobFixe == false then
                        pMonster.state = MONSTER_STATES.TRIGGER
                        pMonster.target = sprite
                        pMonster.maxFrame = 4
                    end
                end
            end
        end
    -- tir une boule d'énergie    
    elseif pMonster.state == MONSTER_STATES.SHOOT then
        local angle = math.angle(pMonster.x, pMonster.y, pMonster.target.x, pMonster.target.y)
        pMonster.vx = math.cos(angle)
        pMonster.vy = math.sin(angle)
        
        -- boss elite
        if pMonster.isBoss == true then
            spriteManager.dataHero[1].CreeTir('monster',pMonster.element,pMonster.x,pMonster.y,pMonster.vx,pMonster.vy)
            -- monstre classique
        elseif pMonster.isMobFixe then
            pMonster.chronotir = pMonster.chronotir + 1
            if pMonster.chronotir >= 190 then
                pMonster.chronotir = 0
                spriteManager.dataHero[1].CreeTir('monster',pMonster.element,pMonster.x,pMonster.y,pMonster.vx,pMonster.vy)
            end
        end
        pMonster.state = MONSTER_STATES.CHANGEDIR
    -- est attiré
    elseif pMonster.state == MONSTER_STATES.TRIGGER then
        if pMonster.target == nil then
            pMonster.state = MONSTER_STATES.CHANGEDIR 
        elseif math.dist(pMonster.x, pMonster.y,pMonster.target.x, pMonster.target.y) > pMonster.range and pMonster.target.type == 'hero' and pMonster.isBoss == false then
            pMonster.state = MONSTER_STATES.CHANGEDIR 
        elseif math.dist(pMonster.x, pMonster.y,pMonster.target.x, pMonster.target.y) > pMonster.range and pMonster.target.type == 'hero' and pMonster.isBoss then
            pMonster.state = MONSTER_STATES.SHOOT
        elseif math.dist(pMonster.x, pMonster.y,pMonster.target.x, pMonster.target.y) < 5 then
            pMonster.state = MONSTER_STATES.ATTACK
            pMonster.maxFrame = 6
            pMonster.vx = 0
            pMonster.vy = 0
        else
            local angle = math.angle(pMonster.x, pMonster.y, pMonster.target.x, pMonster.target.y)
            pMonster.vx = pMonster.speed*2*60 * math.cos(angle)
            pMonster.vy = pMonster.speed*2*60 * math.sin(angle)
        end
    -- monstre attaque
    elseif pMonster.state == MONSTER_STATES.ATTACK then
        if math.dist(pMonster.x, pMonster.y,pMonster.target.x,pMonster.target.y) > 5 then
            pMonster.state = MONSTER_STATES.CHANGEDIR
        else
            if pMonster.target.Hurt ~= nil then
                camera.shake = true
                camera.shakeTimer = .2
                pMonster.target.Hurt()  
            end

            if pMonster.target.visible == false then
                pMonster.state = MONSTER_STATES.CHANGEDIR
            end
        end
    -- monstre choisie une direction    
    elseif pMonster.state == MONSTER_STATES.CHANGEDIR then
        local angle = math.angle(pMonster.x, pMonster.y, love.math.random(0,screenWidth), love.math.random(0,screenHeight))
        pMonster.vx = pMonster.speed*60 * math.cos(angle)
        pMonster.vy = pMonster.speed*60 * math.sin(angle)
        pMonster.state = MONSTER_STATES.WALK
    -- boss elite change de type    
    elseif pMonster.state == MONSTER_STATES.SWITCH then
        spriteManager.SwitchType(pMonster)
        pMonster.state = MONSTER_STATES.CALLINGMOB
        pMonster.switch = true
    -- boss elite appel du renfort    
    elseif pMonster.state == MONSTER_STATES.CALLINGMOB then
        for nMonster=1,5 do
            CreateMonster("fixe")
        end
        sonSpawn:play()
        pMonster.state = MONSTER_STATES.NONE
    elseif pMonster.state == MONSTER_STATES.SHIELD then
        spriteManager.GetShield(pMonster)

        timer_shield_actif = timer_shield_actif+dt

        oldvx = pMonster.vx
        oldvy = pMonster.vy
        pMonster.vx = 0
        pMonster.vy = 0

        if timer_shield_actif > timer_shield_activate then
            pMonster.state = MONSTER_STATES.NONE
            timer_shield_actif = 0 
            spriteManager.DelShield(pMonster,oldvy,oldvx)
        end
    end
end

function spriteManager.SwitchType(monster)
    monster.element = spriteManager.newType
    local item = spriteManager.imgElite
    monster.image = item[spriteManager.newType]['image']
    monster.images = item[spriteManager.newType]['images']
end

function spriteManager.GetShield(monster)
    monster.isInvincible = true
    local item = spriteManager.imgElite.mercure
    monster.image = item['image']
    monster.images = item['images']
end

function spriteManager.DelShield(monster,pvx,pvy)
    monster.isInvincible = false
    local item = spriteManager.imgElite
    monster.image = item[monster.element]['image']
    monster.images = item[monster.element]['images']
    monster.vx = pvx
    monster.vy = pvy
end

function spriteManager.Reset()
    spriteManager.listMonsters = {}
    spriteManager.listeAnims = {}
    spriteManager.listeTirs = {}
    spriteManager.listSprites = {}
end

function spriteManager.ResetDel()
    -- Purge des sprites et traitement
    for n=#spriteManager.listSprites,1,-1 do
        local sprite = spriteManager.listSprites[n]
        if sprite.supprime == true then
            table.remove(spriteManager.listSprites,n)
        end    
    end
end

return spriteManager