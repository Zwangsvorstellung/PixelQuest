-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
math.randomseed(love.timer.getTime())

font = love.graphics.newFont("assets/fonts/Bebas.ttf", 40)
love.graphics.setFont(font)
love.graphics.setDefaultFilter('nearest')

debug_mode = false

-- Cam shake
camera = {}
camera.shake = false    -- Cam shake actif ou pas
camera.shakeTimer = 0   -- Durée restante du cam shake
camera.shakeoffset = 2  -- Amplitude du tremblement

require('utils')
gameState = require('includes/gameState')

----
spriteManager = require('includes/spriteManager')
itemManager = require('includes/itemManager')
interfaceManager = require('includes/interfaceManager')
menuPause = require('includes/menuPause')
shop = require('includes/shop')

require "includes/musics"
local ChoiceHero = require('includes/choiceHero')
local Map = require('includes/map')
local Hero = require('includes/hero')
local Monster = require('includes/monster')

interfaceManager.hero = Hero[1]
interfaceManager.spriteManager = spriteManager
spriteManager.monster = Monster
spriteManager.dataHero = Hero

-- gestion des ecrans
imgScene = love.graphics.newImage('assets/scene/accueil.png')
imgChoice = love.graphics.newImage('assets/scene/choice.png')
imgGameOver = love.graphics.newImage('assets/scene/gameover.png')
imgPause = love.graphics.newImage('assets/scene/pause.png')

function GameInit(dt)
    isPaused = false
    SCENE = 'accueil'
    gameState.score = 0
    gameState.Reset()
    shop.Reset()
    spriteManager.Reset()
    Hero[1].Reset()
    Monster.Reset()
    
    -- option choix personnage
    ChoiceHero.Load()
    Map.Load()
    Hero[1].Load()
    Monster.Load()
end

function love.load()
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    xMouse,yMouse = love.mouse.getPosition()

    GameInit()
end

function love.update(dt)
    -- pause
    if isPaused then
        return
    end

    if SCENE == 'choice_menu_character' then
        ChoiceHero.Update(dt)
    elseif SCENE == 'game' then

        sonDonjon2:play()
        sonDonjon2:setVolume(0.5)
        spriteManager.ResetDel()
        
        -- Gestion camera
        gameState.ShakeCamera(dt)

        Map.Update(dt)
        itemManager.Update(dt)
        Hero[1].Update(dt,Map,ChoiceHero.selected,Monster)
        Monster.Update(dt,ChoiceHero.selected,Hero)
        interfaceManager.Update(dt)
    elseif SCENE == 'buy' then
        shop.Update(dt)
    end
end

function love.draw()
    
    if SCENE == 'accueil' then
        love.graphics.draw(imgScene,0,0)
    elseif SCENE == 'choice_menu_character' then
        ChoiceHero.Draw()
    elseif SCENE == 'game' then
        if camera.shake == true then
            love.graphics.translate(love.math.random(-camera.shakeoffset,camera.shakeoffset), love.math.random(-camera.shakeoffset,camera.shakeoffset))
        end
        Map.Draw()
        Hero[1].Draw(Monster)
        Monster.Draw()
        interfaceManager.Draw(Map)
    elseif SCENE == 'gameover' then
        love.graphics.draw(imgGameOver,0,0)
    elseif SCENE == 'pause' then
        love.graphics.draw(imgPause,0,0)
        menuPause.Draw()
    elseif SCENE == 'buy' then
        love.graphics.draw(imgPause,0,0)
        shop.Draw()
    end
end

function love.keypressed(key)
    if SCENE == 'accueil' then
        if key == "space" then SCENE = 'choice_menu_character' end
        if key == 'escape' then love.event.quit() end
    end

    if SCENE == 'choice_menu_character' then
        ChoiceHero.Keypressed(key)
    end

    if SCENE == 'buy' then
        shop.Keypressed(key)
    end

    if SCENE == 'game' then
        Hero[1].Keypressed(key,Map, Hero[1])
        interfaceManager.Keypressed(key)
    end

    if SCENE == 'gameover' then
        if key == 'space' then 
            GameInit(dt)
       end
    end

    -- pause
    if key == 'rshift' then
        if isPaused then
            isPaused = false
            SCENE = 'game'
            else
            isPaused = true
            SCENE = 'pause'
        end
    end
end