local itemManager = {
    liste_items = {},
    liste_place = {},
    liste_typeChange = {}
}

itemManager.liste_place.q = false
itemManager.liste_place.s = false
itemManager.liste_place.d = false

function itemManager.CreerItem(pType,pX,pY,pVx, pVy)
  
    local item = CreeSpriteItem('shine',4,pX,pY)
    item.type = pType
    item.vx = 0
    item.vy = 0
    item.supprime = false
    item.pickup = false
    item.blocked = false
    item.shine = true
    item.key = nil

    -- magie
    if pType == 'changeType' then
        typeItemElement = getRandomType()
        item.newElementType = typeItemElement
        item.image = interfaceManager.inventaire[typeItemElement]
        table.insert(itemManager.liste_typeChange, item)
    end

    table.insert(itemManager.liste_items, item)
    return item
end

function itemManager.Update(dt)
    local n
    for n=#itemManager.liste_items,1,-1 do
        local item = itemManager.liste_items[n]
        if item.supprime == true then
            table.remove(itemManager.liste_items,n)
        end
        if item.pickup == true and item.blocked == false then
            item.frame = 1
            item.pickup = false
            item.shine = false
        end
    end
end

function CreeSpriteItem(pNomImage, pNbImages, pX, pY)
  
    local sprite = {}
    sprite.x = pX
    sprite.y = pY
    sprite.currentFrame = 1
    sprite.vx = 0
    sprite.vy = 0
    sprite.images = {}
    sprite.image = nil
    sprite.supprime = false

    local imgNum
    for imgNum = 1,pNbImages do
        sprite.images[imgNum] = love.graphics.newImage("assets/interface/objets/"..pNomImage..imgNum..".png")
    end
 
    sprite.width = sprite.images[1]:getWidth()
    sprite.height = sprite.images[1]:getHeight()
    
    table.insert(spriteManager.listSprites, sprite)

    return sprite    
end

function itemManager.Reset()
    itemManager.liste_items = {}
    itemManager.liste_typeChange = {}
end

return itemManager