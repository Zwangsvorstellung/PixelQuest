local interface = {
  inventaire = {
    slot = {
      [1] = {
        x = 820,
        y = 400
      },
      [2] = {
        x = 880,
        y = 400
      },
      [3] = {
        x = 940,
        y = 400
      },
    }
  }
}

local badge

-- Item actuel
interface.maxchangeType = 3
interface.nbrChangeType = 0

interface.inventaire.badgefeu = love.graphics.newImage('assets/interface/badges/badge_feu.png')
interface.inventaire.badgeeau = love.graphics.newImage('assets/interface/badges/badge_eau.png')
interface.inventaire.badgeplante = love.graphics.newImage('assets/interface/badges/badge_plante.png')

interface.inventaire.feu = love.graphics.newImage('assets/interface/tirs/tirfeu.png')
interface.inventaire.eau = love.graphics.newImage('assets/interface/tirs/tireau.png')
interface.inventaire.plante = love.graphics.newImage('assets/interface/tirs/tirplante.png')
interface.inventaire.succes = love.graphics.newImage("assets/interface/succes/badge_default.png")

interface.inventaire.decoTige = love.graphics.newImage("assets/interface/effects/tige.png")
interface.inventaire.decoTigeWheel = love.graphics.newImage("assets/interface/effects/wheel2.png")
interface.inventaire.decoTigeWheel3 = love.graphics.newImage("assets/interface/effects/wheel3.png")

interface.inventaire.succesList = {
  successKill = love.graphics.newImage("assets/interface/succes/FeuFollet.png"),
  successKillMax = love.graphics.newImage("assets/interface/succes/Badge4-10.png"),
  successHealUse = love.graphics.newImage("assets/interface/succes/BlobShiny.png"),
  successLuck = love.graphics.newImage("assets/interface/succes/trefle.png"),
  successKillElite = love.graphics.newImage("assets/interface/succes/Badge1-7.png"),
  successBuyingSkin = love.graphics.newImage("assets/interface/succes/Badge4-7.png"),
  successBuyingAllSkin = love.graphics.newImage("assets/interface/succes/Badge4-8.png"),
}

local wheel = {x = 0, y = 0, w = 0, h = 0, sx = 0.5, sy = 0.5, r = 0}
wheel.w = interface.inventaire.decoTigeWheel:getWidth()
wheel.h = interface.inventaire.decoTigeWheel:getHeight() 

function interface.Update(dt)

  wheel.r = wheel.r + dt  

  for k, v in pairs(shop.shopIsBuying) do
    local count
    count = 0
    if v == true then
      count = count+1
    end
    if count > 6 then
      SUCCESS.buyingSkin = true
      succesDelock:play()
    end
    if count >= 12 then
      SUCCESS.buyingAllSkin = true
      succesDelock:play()
    end
  end

  if gameState.typeHeroElement == 'feu' then
    badge = interface.inventaire.badgefeu
  elseif gameState.typeHeroElement == 'eau' then
    badge = interface.inventaire.badgeeau
  elseif gameState.typeHeroElement == 'plante' then
    badge = interface.inventaire.badgeplante
  end 
end

function interface.Draw(Map)

  love.graphics.draw(badge,screenWidth-176,190,0,4,4)
  love.graphics.print('Vie : '..gameState.life,screenWidth-176,68)
  love.graphics.print('Score : '..gameState.score,screenWidth-176,128)
  love.graphics.rectangle("fill", screenWidth-220,370,190, 2)

  love.graphics.print('Objets',screenWidth-159,330)

  for i, sprite in ipairs(itemManager.liste_typeChange) do
      if sprite.shine == false then
        love.graphics.draw(sprite.image, sprite.x, sprite.y,0,4,4)
      end
  end
  love.graphics.print('Q',830,455)
  love.graphics.print('S',890,455)
  love.graphics.print('D',950,455)
  love.graphics.rectangle("fill", screenWidth-220,500,190,2)

  love.graphics.print('Carte '..Map.grilleName[Map.grid],screenWidth-210,530)
  love.graphics.print('Zone '..Map.grid_lvl,screenWidth-210,570)

  local marge = 64
  for n=1, 7 do
    love.graphics.draw(interface.inventaire.succes, marge, 680, 0,2,2)
    marge = marge + 64
  end

  if SUCCESS.kill then
    love.graphics.draw(interfaceManager.inventaire.succesList.successKill, 64, 680, 0,2,2)
  end
  if SUCCESS.killMax then
    love.graphics.draw(interfaceManager.inventaire.succesList.successKillMax, 64*2, 680, 0,2,2)
  end
  if SUCCESS.heal then
    love.graphics.draw(interfaceManager.inventaire.succesList.successHealUse, 64*3, 680, 0,2,2)
  end
  if SUCCESS.luck then
    love.graphics.draw(interfaceManager.inventaire.succesList.successLuck, 64*4, 680, 0,2,2)
  end
  if SUCCESS.killElite then
    love.graphics.draw(interfaceManager.inventaire.succesList.successKillElite, 64*5, 680, 0,2,2)
  end
  if SUCCESS.buyingSkin then
    love.graphics.draw(interfaceManager.inventaire.succesList.successBuyingSkin, 64*6, 680, 0,2,2)
  end
  if SUCCESS.buyingAllSkin then
    love.graphics.draw(interfaceManager.inventaire.succesList.successBuyingAllSkin, 64*7, 680, 0,2,2)
  end

  -- déco
  love.graphics.draw(interface.inventaire.decoTige,860, screenHeight-80)
  love.graphics.draw(interface.inventaire.decoTigeWheel,883, screenHeight-50, wheel.r, wheel.sx, wheel.sy, wheel.w / 2,  wheel.h / 2)
  love.graphics.draw(interface.inventaire.decoTigeWheel3,920, screenHeight-40, wheel.r, wheel.sx, wheel.sy, wheel.w / 2,  wheel.h / 2)

end

function interface.Keypressed(key)
  if key == 'q' or key == 's' or key == 'd' then
    interface.hero.useItem(key,itemManager.liste_typeChange, itemManager.liste_items, spriteManager.listSprites)
  end
end

return interface