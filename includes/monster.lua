local monster = {
    image = {},
    frames = {},
    frameCurrent = 1,
}

local MONSTER_STATES = {
    NONE = '',
    WALK = 'walk',
    TRIGGER = 'trigger',
    ATTACK = 'attack',
    CHANDEDIR = 'change',
    SWITCH = 'switchType',
    SHOOT = 'shoot',
    CALLINGMOB = 'CALLINGMOB',
    SHIELD = 'SHIELD',
    SHOOTRANDOM = 'SHOOTRANDOM',
}

local imageMonster = {
    feu = 'assets/player/flammefeu',
    eau = 'assets/player/flammeeau',
    plante = 'assets/player/flammeplante',
    eliteFeu = 'assets/player/bossfeu',
    eliteEau = 'assets/player/bosseau',
    elitePlante = 'assets/player/bossplante',
}

function CreateMonster(typeMonster)

    local typeMonsterElement = getRandomType()
    local path = 'assets/player/flamme'..typeMonsterElement
    local monsterCreate = spriteManager.CreateSpriteMonster('monster',path,6,48,48,64)
    monsterCreate.x = love.math.random(128, screenWidth-(64*6))
    monsterCreate.y = love.math.random(128, screenHeight-(64*3))
    monsterCreate.speed = love.math.random(5,80) / 100
    monsterCreate.range = love.math.random(10,150)
    monsterCreate.target = nil
    monsterCreate.energie = love.math.random(5,25)
    monsterCreate.maxFrame = 3
    monsterCreate.element = typeMonsterElement
    monsterCreate.isBoss = false
    monsterCreate.chronotir = 0
    monsterCreate.isInvincible = false
    if typeMonster == 'fixe' then
        monsterCreate.isMobFixe = true
    end

    table.insert(spriteManager.listMonsters, monsterCreate)
    table.insert(spriteManager.listSprites, monsterCreate)
end

-- 53
-- 76
function CreateMonsterBoss()

    local typeMonsterElement = getRandomType()
    local image
    if typeMonsterElement == 'plante' then   image = imageMonster.elitePlante end
    if typeMonsterElement == 'feu'    then   image = imageMonster.eliteFeu    end
    if typeMonsterElement == 'eau'    then   image = imageMonster.eliteEau    end

    local monsterCreate = spriteManager.CreateSpriteMonster('boss',image,6,106,106,152,typeMonsterElement)

    monsterCreate.x = love.math.random(64, screenWidth-(64*6))
    monsterCreate.y = love.math.random(64, screenHeight-(64*2))
    monsterCreate.speed = love.math.random(5,80) / 100
    monsterCreate.range = love.math.random(10,200)
    monsterCreate.target = nil
    monsterCreate.energie = 40
    monsterCreate.maxFrame = 6
    monsterCreate.element = typeMonsterElement
    monsterCreate.isBoss = true
    monsterCreate.switch = false
    monsterCreate.chronotir = 0
    monsterCreate.isInvincible = false

    table.insert(spriteManager.listMonsters, monsterCreate)
    table.insert(spriteManager.listSprites, monsterCreate)
end

function monster.Load()
    local nMonster
    for nMonster=1,17 do
        CreateMonster()
    end
    local monsterBoss = love.math.random(28,30)
    if monsterBoss > 25 then
        CreateMonsterBoss()
    end
    
    gameState.mapIsEmpty = false
    scoreSet = false
end

function monster.Update(dt,ChoiceHero)
    
    local i
    for i, sprite in ipairs (spriteManager.listMonsters) do
        sprite.currentFrame = sprite.currentFrame + 6*dt
        if sprite.currentFrame >= sprite.maxFrame + 1 then
            sprite.currentFrame = 1
        end
    
        -- velocity
        if sprite.isMobFixe == false then
            sprite.x = sprite.x + sprite.vx*dt
            sprite.y = sprite.y + sprite.vy*dt
        end

        spriteManager.UpdateMonster(MONSTER_STATES,sprite,ChoiceHero,dt)
    end
end

function monster.Draw()
    
    local i
    for i, sprite in ipairs (spriteManager.listMonsters) do
        local frame = sprite.images[math.floor(sprite.currentFrame)]

        if sprite.isBoss then
            love.graphics.draw(sprite.image,frame,sprite.x, sprite.y,0,sprite.direction,1,106-53,106)
            love.graphics.print(tostring(sprite.energie), sprite.x-10, sprite.y-106)
        else
            love.graphics.draw(sprite.image,frame,sprite.x, sprite.y,0,sprite.direction,1,24,24+16)
            love.graphics.print(tostring(sprite.energie), sprite.x-14, sprite.y-52)
        end
        
        -- débug
        if debug_mode then
            love.graphics.circle('fill', sprite.x, sprite.y, 2)
            love.graphics.circle('line', sprite.x, sprite.y, sprite.width/2)
        end
    end
end

function monster.Reset()
    spriteManager.listMonsters = {}
end

return monster