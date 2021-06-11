xCur=0
maxXCur=0
yCur=0
zCur=0
width=15
height=8
local function organize()
    for i = 1,16 do
        if turtle.getItemCount(i) > 0 and turtle.getItemCount(i) < 64 then
          turtle.select(i)
          for j = i+1,16 do
            if turtle.compareTo(j) then
              turtle.select(j)
              turtle.transferTo(i)
              turtle.select(i)
            end
          end
        end
      end
      
      for i = 1,16 do
        if turtle.getItemCount(i) > 0 then
          for j = 1,i do
            if turtle.getItemCount(j) == 0 then
              turtle.select(i)
              turtle.transferTo(j)
              break
            end
          end
        end
      end
end
local function mineAndMoveZAxisPositive( forOrBack)
    if forOrBack==true then turtle.turnRight() else turtle.turnLeft() end
    for n=1,width do
        turtle.dig()
        if turtle.forward() then
            zCur=zCur+1
        end
    end
    if forOrBack==false then turtle.turnRight() else turtle.turnLeft() end
end

local function mineAndMoveZAxisNegative(forOrBack)
    if forOrBack==false then turtle.turnRight() else turtle.turnLeft() end
    for n=1,width do
        turtle.dig()
        if turtle.forward() then
            zCur=zCur-1
        end
    end
    if forOrBack==true then turtle.turnRight() else turtle.turnLeft() end
end

local function moveUp()
    if turtle.up() then 
        yCur=yCur+1
    end
end
local function moveDown()
    canGoDown=turtle.down()
    if canGoDown then 
        yCur=yCur-1
    end
    return canGoDown
end



local function teleportMaterialsBack2Base()
    turtle.select(2)
    turtle.placeUp()
    for n=4,16 do
        turtle.select(n)			
        turtle.dropUp()
    end
    turtle.select(2)
    turtle.digUp()
end
local function refuelFromEnderChest()
    turtle.select(1)
    turtle.placeUp()
    while (turtle.suckUp()==true) do
        print( "big suck energy" )
    end
    for n=1,16 do
        turtle.select(n)
        turtle.refuel()
    end
    organize()
    for n=1,16 do
        turtle.select(n)	
        if turtle.getItemDetail()["name"]=="minecraft:bucket" then
            turtle.transferTo(10)
            turtle.select(1)
            turtle.digUp()
            break
        end
    end
    turtle.select(3)
    turtle.placeUp()
    turtle.select(10)
    turtle.dropUp()
    turtle.select(3)
    turtle.digUp()
    
end

local function mineForwardLayer()
    forOrBack=true
    for n=1,height do
        turtle.dig()
        if turtle.forward() then
            xCur=xCur+1
            if xCur>maxXCur then
                maxXCur=xCur
            end
        end
        mineAndMoveZAxisPositive(forOrBack)
        turtle.dig()
        if turtle.forward() then
            xCur=xCur+1
            if xCur>maxXCur then
                maxXCur=xCur
            end
        end
        mineAndMoveZAxisNegative(forOrBack)
    end
end
local function move2Surface()
    while (yCur~=0) do
        moveUp()
    end
end
local function move2maxX()
    while (xCur<maxXCur) do
        turtle.dig()
        moveForward()
    end
end

local function moveForward() 
    if turtle.forward() then
        xCur=xCur+1
    end
end
local function mineBackwardLayer()
    turtle.turnRight()
    turtle.turnRight()
    forOrBack=false
    for n=1,height do
        mineAndMoveZAxisPositive(forOrBack)
        turtle.dig()
        if turtle.forward() then
            xCur=xCur-1
        end
        mineAndMoveZAxisNegative(forOrBack)
        turtle.dig()
        if turtle.forward() then
            xCur=xCur-1
        end
    end
    turtle.turnRight()
    turtle.turnRight()
end



local function handler( )
    able2Dig=true
    while(able2Dig) do
        teleportMaterialsBack2Base()
        while (turtle.getFuelLevel() < 400 ) do -- wiggle room above 16*16
            refuelFromEnderChest()
        end
        
        mineForwardLayer()

        turtle.digDown()
        if moveDown() then no="op" else break end

        mineBackwardLayer()

        turtle.digDown()
        if moveDown() then no="op" else break end

    end

    move2Surface()
    move2maxX()
    
end



while (1==1) do
    handler()
end

-- this is just a buffer buffer
