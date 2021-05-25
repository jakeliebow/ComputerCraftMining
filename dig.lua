xCur=0
maxXCur=0
yCur=0
zCur=0
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
local function moveLeft()
	turtle.turnLeft()
    if turtle.forward() then
        zCur=zCur-1
    end
    turtle.turnRight()
end
local function moveBackward()
    if turtle.back() then
        xCur=xCur-1
    end
end

local function moveRight()
    turtle.turnRight()
    if turtle.forward() then
        zCur=zCur+1
    end
    turtle.turnLeft()
end

local function moveForward() 
    if turtle.forward() then
        xCur=xCur+1
        if xCur>maxXCur then
            maxXCur=xCur
        end
    end
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

local function mineForward( )
    turtle.dig()
    turtle.suck()
end
local function mineDown( )
    return turtle.digDown()
end
local function mineRight( )
    turtle.turnRight()
    turtle.dig()
    turtle.suck()
    turtle.turnLeft()
end
local function mineLeft( )
    turtle.turnLeft()
    turtle.dig()
    turtle.suck()
    turtle.turnRight()
end
local function mineBackward( )
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.dig()
    turtle.suck()
    turtle.turnRight()
    turtle.turnRight()
end

local function unload( )
    print( "Unloading items..." )
    turtle.turnLeft()
    turtle.turnLeft()
	for n=1,16 do
        turtle.select(n)			
        turtle.drop()
    end
    turtle.turnLeft()
    turtle.turnLeft()
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
local function handler( )
    able2Dig=true
    while(able2Dig) do
        for n=1, height do
            for n=1,width do
                mineRight()
                moveRight()
            end
            mineForward()
            moveForward()
            for n=1,width do
                mineLeft()
                moveLeft()
            end
            mineForward()
            moveForward()
        end
        moveBackward() -- erase offsetted movement by above movement
        mineDown()
        if moveDown()==false then
            able2Dig=false
            break
        end
        for n=1, height do
            for n=1,width do
                mineRight()
                moveRight()
            end
            mineBackward()
            moveBackward()
            for n=1,width do
                mineLeft()
                moveLeft()
            end
            mineBackward()
            moveBackward()
        end
        moveForward()
        mineDown()
        if moveDown()==false then
            able2Dig=false
            break
        end
    end
    while (yCur~=0) do
        moveUp()
    end
    while (xCur~=maxXCur) do
        mineForward()
        moveForward()
    end
    
end

--while (1==1) do
width=1
height=1
--handler()
--end

teleportMaterialsBack2Base()
refuelFromEnderChest()