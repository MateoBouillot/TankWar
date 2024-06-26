local enemyimg = {}
    enemyimg.tank = love.graphics.newImage("/img/enemies/sniper/sniperBody.png")
    enemyimg.barrel = love.graphics.newImage("/img/enemies/sniper/sniperCanon.png")

local offset = {}
    offset.tankX = enemyimg.tank:getWidth() * 0.5
    offset.tankY = enemyimg.tank:getHeight() * 0.5
    offset.barrelX = 0
    offset.barrelY = enemyimg.barrel:getHeight() * 0.5

enemyList = {}

local enemies = {}

    enemies.init = function()
        enemyList = {}
    end
    enemies.spawnTime = 2
    enemies.spawnTimer = enemies.spawnTime
    enemies.randomRotTime = 0.01
    enemies.randomRotTimer = enemies.randomRotTime
    enemies.speed = 150

    enemies.Spawning = function(dt)
        enemies.spawnTimer = enemies.spawnTimer - dt
        if enemies.spawnTimer <= 0 then
            enemies.spawn()
            enemies.spawnTimer = enemies.spawnTime
        end
    end
    math.randomseed(os.time())
    enemies.spawn = function()
       
        local enemy = {}
        enemies.spawnSide = math.random(1, 4)
        if enemies.spawnSide == 1 then
            enemy.x = 0 - 30
            enemy.y = love.graphics.getHeight() * 0.5
            enemy.rot = 0
        elseif enemies.spawnSide == 2 then
            enemy.x = love.graphics.getWidth() + 30
            enemy.y = love.graphics.getHeight() * 0.5
            enemy.rot = math.pi
        elseif enemies.spawnSide == 3 then
            enemy.x = love.graphics.getWidth() * 0.5
            enemy.y = 0 - 30
            enemy.rot = math.pi * 0.5
        elseif enemies.spawnSide == 4 then
            enemy.x = love.graphics.getWidth() * 0.5
            enemy.y = love.graphics.getHeight() + 30
            enemy.rot = 3 * math.pi * 0.5
        end

        enemy.hitBox = {}
        enemy.hitBox.x = enemy.x - offset.tankX
        enemy.hitBox.y = enemy.y - offset.tankY
        enemy.hitBox.W = enemyimg.tank:getWidth()
        enemy.hitBox.H = enemyimg.tank:getHeight()

        table.insert(enemyList, enemy)
    end

    enemies.update = function(dt)
        
        for i = #enemyList, 1, -1 do
            enemyList[i].x = enemyList[i].x + enemies.speed * math.cos(enemyList[i].rot) * dt
            enemyList[i].y = enemyList[i].y + enemies.speed * math.sin(enemyList[i].rot) * dt

            enemyList[i].hitBox.x = enemyList[i].x - offset.tankX
            enemyList[i].hitBox.y = enemyList[i].y - offset.tankY

            enemies.randomRotTimer = enemies.randomRotTimer - dt
            if enemies.randomRotTimer <= 0 then
                enemyList[i].rot = enemyList[i].rot + math.random(-10, 10) * 0.01
                enemies.randomRotTimer = enemies.randomRotTime
            end

            if enemyList[i].x + offset.tankX > love.graphics.getWidth() + 100 or enemyList[i].x - offset.tankX < -100 or enemyList[i].y + offset.tankY > love.graphics.getHeight() + 100 or enemyList[i].y - offset.tankY < -100 then
                table.remove(enemyList, i)
            end
        end
    end

    enemies.draw = function()
        for i = 1, #enemyList do
            local e = enemyList[i]
            love.graphics.draw(enemyimg.tank, e.x, e.y, e.rot, 0.9, 0.9, offset.tankX, offset.tankY)
            love.graphics.draw(enemyimg.barrel, e.x, e.y, e.rot, 0.9, 0.9, offset.barrelX, offset.barrelY)
        end
    end
return enemies