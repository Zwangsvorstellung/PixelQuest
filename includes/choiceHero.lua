local choiceHero = {
    blob = {
        image = love.graphics.newImage("assets/player/blob400.png"),
        name = "Blob",
        fFace = {},
        x = 0,
        y = 0
    },
    lapin = {
        image = love.graphics.newImage("assets/player/lapin400.png"),
        name = "Lapin",
        fFace = {},
        x = 0,
        y = 0
    },
    width = 96,
    height = 128,
    selectedDefault = 'blob',
    selected = 'blob',
    frameAtqInit = 1
}

local selected_bar = {
    x = 0,
    y = 0
}

function choiceHero.Load()
    local heroX = 0
    for n=1,6 do
        choiceHero.blob.fFace[n] = love.graphics.newQuad(heroX, 256, 96, 128, choiceHero.blob.image:getWidth(), choiceHero.blob.image:getHeight())
        choiceHero.lapin.fFace[n] = love.graphics.newQuad(heroX, 256, 96, 128, choiceHero.lapin.image:getWidth(), choiceHero.lapin.image:getHeight())
        heroX = heroX+96
    end

    choiceHero.blob.x = screenWidth/2-(choiceHero.width*2)
    choiceHero.blob.y = screenHeight/2
    choiceHero.lapin.x = screenWidth/2+choiceHero.width
    choiceHero.lapin.y = screenHeight/2

    selected_bar.y = screenHeight/2+150
end

function choiceHero.Update(dt)
    if love.keyboard.isDown("right") then
        choiceHero.selected = 'lapin'
        selected_bar.x = choiceHero.blob.x
    end
    if love.keyboard.isDown("left") then
        choiceHero.selected = 'blob'
        selected_bar.x = choiceHero.lapin.x
    end

    frameArrondieAtq = math.floor(choiceHero.frameAtqInit)

    choiceHero.frameAtqInit = choiceHero.frameAtqInit + 4 * dt
    if choiceHero.frameAtqInit >= #choiceHero.blob.fFace + 1 then
        choiceHero.frameAtqInit = 1
    end

    if choiceHero.selected == 'blob' then
        selected_bar.x = choiceHero.blob.x
    end

    if choiceHero.selected == 'lapin' then
        selected_bar.x = choiceHero.lapin.x
    end
end

function choiceHero.Draw()

    love.graphics.draw(imgChoice,0,0)

    if choiceHero.selected == 'blob' then
        love.graphics.draw(choiceHero.blob.image,choiceHero.blob.fFace[frameArrondieAtq],choiceHero.blob.x,choiceHero.blob.y)
        love.graphics.draw(choiceHero.lapin.image,choiceHero.lapin.fFace[2],choiceHero.lapin.x,choiceHero.lapin.y)
    else
        love.graphics.draw(choiceHero.lapin.image,choiceHero.lapin.fFace[frameArrondieAtq],choiceHero.lapin.x,choiceHero.lapin.y)
        love.graphics.draw(choiceHero.blob.image,choiceHero.blob.fFace[2],choiceHero.blob.x,choiceHero.blob.y)
    end
    love.graphics.rectangle("fill", selected_bar.x,selected_bar.y, 96, 6)
end

function choiceHero.Keypressed(key)
    if key == 'escape' then
        SCENE = 'accueil'
    end
    if key == 'return' then
        sonCursorValide:play()
        SCENE = 'game'
    end
    sonCursor:play()
end

return choiceHero