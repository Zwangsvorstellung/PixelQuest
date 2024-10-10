local shop = {
    Obsidienne = love.graphics.newImage("assets/apparences/obsidienne.png"),
    Zao = love.graphics.newImage("assets/apparences/zao.png"),
    Antonio = love.graphics.newImage("assets/apparences/antonio.png"),
    Anaxagore = love.graphics.newImage("assets/apparences/anaxagore.png"),
    Desir = love.graphics.newImage("assets/apparences/desir.png"),
    Triomphe = love.graphics.newImage("assets/apparences/triomphe.png"),
    Lamie = love.graphics.newImage("assets/apparences/lamie.png"),
    Liebkosung = love.graphics.newImage("assets/apparences/liebkosung.png"),
    Zaho = love.graphics.newImage("assets/apparences/zaho.png"),
    Verfuhrerin = love.graphics.newImage("assets/apparences/verfuhrerin.png"),
    Xiang = love.graphics.newImage("assets/apparences/xiang.png"),
    Vilaine = love.graphics.newImage("assets/apparences/vilaine.png"),
    Solicia = love.graphics.newImage("assets/apparences/solicia.png"),
    Hiver = love.graphics.newImage("assets/apparences/hiver.png"),
    selectionX = 1,
    selectionY = 1,
    nameChoice = '',
    price = '',
    cantBuy = false,
    alreadyBuy = false
}

shop.shopIsBuying = {
    Obsidienne = false,
    Zao = false,
    Antonio = false,
    Anaxagore = false,
    Desir = false,
    Triomphe = false,
    Lamie = false,
    Liebkosung = false,
    Zaho = false,
    Verfuhrerin = false,
    Xiang = false,
    Vilaine = false,
    Solicia = false,
    Hiver = false,
}

local personnage = {
    row = {'Obsidienne','Zao','Antonio','Anaxagore','Desir','Triomphe','Lamie'},
    col = {'Liebkosung','Zaho','Verfuhrerin','Xiang','Vilaine','Solicia','Hiver'},
    priceRow = {25,260,340,400,620,1200,2000},
    priceCol = {150,320,120,560,500,850,100},
}

local selected_bar = {
    x = 185,
    y = 340
}

function shop.Update(dt)
    
    -- row 1
    if shop.selectionY == 1 then
        for n=1,#personnage.row do
            shop.nameChoice = personnage.row[shop.selectionX]
            shop.price = personnage.priceRow[shop.selectionX]
        end
    end
    -- row 2
    if shop.selectionY == 2 then
        for n=1,#personnage.col do
            shop.nameChoice = personnage.col[shop.selectionX]
            shop.price = personnage.priceCol[shop.selectionX]
        end
    end
end

function shop.Draw()
    love.graphics.draw(menuPause.personnagesUnlock,screenWidth/4-menuPause.personnagesUnlock:getWidth()/2,screenHeight/4,0,4)
    love.graphics.rectangle("fill", selected_bar.x,selected_bar.y, 70, 6)
    love.graphics.print(shop.nameChoice,selected_bar.x,selected_bar.y+10)
    love.graphics.print(shop.price,selected_bar.x,selected_bar.y+40)
    love.graphics.print(gameState.score..' points',(screenWidth/2-50)-20,80)

    -- les skins du shop
    for k, v in pairs(shop.shopIsBuying) do
        if v == true then
            love.graphics.draw(shop[k],screenWidth/4-menuPause.personnagesUnlock:getWidth()/2,screenHeight/4,0,4)
        end
    end

    if shop.cantBuy then
        -- msg pas de crédit
        love.graphics.rectangle("fill",screenWidth/2-45 ,130,70,6)
        love.graphics.print('Pas assez de point pour cet achat !',screenWidth/2-200 ,150)
    elseif shop.alreadyBuy then
        -- msg achat déjà fait
        love.graphics.rectangle("fill",screenWidth/2-45 ,130,70,6)
        love.graphics.print('Déjà acquise !',screenWidth/2-100 ,150)
    end
end

-- action d'achat
function shop.buyingSkin(pDataBuying)

    if debug_mode then
        gameState.score = 50000
    end

    if gameState.score >= pDataBuying.price and shop.shopIsBuying[pDataBuying['nameChoice']] == false then
        gameState.score = gameState.score - shop.price
        shop.shopIsBuying[pDataBuying['nameChoice']] = true
        shop.cantBuy = false
        return true
    else
        if shop.shopIsBuying[pDataBuying['nameChoice']] == false then
            shop.cantBuy = true
            shop.alreadyBuy = false
        else
            shop.alreadyBuy = true
            shop.cantBuy = false
        end
    end
end

function shop.Keypressed(key)

    if key == 'right' and selected_bar.x ~= 755 then
        selected_bar.x = selected_bar.x + 95
        shop.selectionX = shop.selectionX + 1
    end
    if key == 'left' and selected_bar.x ~= 185 then
        selected_bar.x = selected_bar.x - 95
        shop.selectionX = shop.selectionX - 1
    end
    if key == 'up' and selected_bar.y ~= 340 then
        selected_bar.y = selected_bar.y - 260
        shop.selectionY = shop.selectionY - 1
    end
    if key == 'down' and selected_bar.y ~= 600 then
        selected_bar.y = selected_bar.y + 260
        shop.selectionY = shop.selectionY + 1
    end

    if key == 'return' then
        local buying = {}
        buying.selectionX = shop.selectionX
        buying.selectionY = shop.selectionY
        if shop.selectionY == 1 then
            buying.nameChoice = personnage.row[shop.selectionX]
            buying.price = personnage.priceRow[shop.selectionX]
        end
        if shop.selectionY == 2 then
            buying.nameChoice = personnage.col[shop.selectionX]
            buying.price = personnage.priceCol[shop.selectionX]
        end

        local achatDo = shop.buyingSkin(buying)
        if achatDo then
            succesDelock:play()
        end
    end

    if key == 'escape' then
        SCENE = 'game'
        shop.cantBuy = true
    end
end

function shop.Reset()
    for k, v in pairs(shop.shopIsBuying) do
        shop.shopIsBuying[k] = false
    end
end
  
return shop