local gameState = {}

gameState.ID = nil
gameState.typeHeroElement = nil
gameState.score = 0
gameState.life = nil
gameState.mapIsEmpty = false

listeTypeElement = {'eau','feu','plante'}

SCENE = {
    ACCUEIL = 'accueil',
    CHOICE = 'choice_menu_character',
    GAME = 'game',
    GAMEOVER = 'gameover',
    PAUSE = 'pause',
    BUY = 'buy',
}

SUCCESS = {
    kill = false,
    killMax = false,
    heal = false,
    luck = false,
    killElite = false,
    buyingSkin = false,
    buyingAllSkin = false
}

function gameState.ShakeCamera(dt)
    if camera.shake == true then
        camera.shakeTimer = camera.shakeTimer - 6*dt
        if camera.shakeTimer <= 0 then
            camera.shake = false
        end
    end
end

function gameState.Reset()
    for k, v in pairs(SUCCESS) do
      SUCCESS[k] = false
    end
end

function gameState.setScore()
    gameState.score = gameState.score + 25
    gameState.scoreWasSet = true
end


return gameState