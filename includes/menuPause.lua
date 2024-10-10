local menuPause = {
  personnagesUnlock = love.graphics.newImage('assets/interface/succes/personnages.png')
}

function menuPause.Draw()
  love.graphics.draw(menuPause.personnagesUnlock,screenWidth/4-menuPause.personnagesUnlock:getWidth()/2,screenHeight/4,0,4)
end

return menuPause