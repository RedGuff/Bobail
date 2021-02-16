-- https://www.youtube.com/watch?v=P_mHlsrAhKc
-- https://timboisco.fr/wp-content/uploads/2018/07/Le-BOBAIL.pdf
function love.load()
  maxX = 5 -- ODD! 5 minimum!
  maxY = maxX -- Square!
  marge = 5
  initialisation( )
  clicsound = love.audio.newSource("sounds/Clic.wav", "static")
  clicsound1 = love.audio.newSource("sounds/Clic.wav", "static")
  clicsound2 = love.audio.newSource("sounds/Clic.wav", "static")

end

function initialisation()
  grid={}
  for col=1, maxX do
    grid[col] = {}
    for row=1, maxX do
      if (row == 1) then
        grid[col][row] = 1 -- UpPlayer.
      elseif ((col == row) and (row == math.ceil(maxX/2))) then
        grid[col][row] = 3 -- Bobail.
      elseif (row == maxX) then
        grid[col][row] = 2 -- DownPlayer.
      else
        grid[col][row] = 0 -- Empty.
      end
    end
  end
  XKb1 = 3
  YKb1 = maxY
  hand = 0
end

function love.draw()
  sizeCase = math.min(love.graphics.getWidth( )/6,  love.graphics.getHeight( )/6) -- Real time!   :-D

  love.graphics.setColor(0.35, 0.22, 0.13)

  love.graphics.setColor(0.35, 0.22, 0.13)
  love.graphics.rectangle( "fill", marge + sizeCase/2, marge + sizeCase/2, maxX * sizeCase, maxX * sizeCase, 15, 15, 100 )    --  board.
  love.graphics.setColor(1, 1, 0)
  love.graphics.circle("fill", marge + XKb1 * sizeCase, marge + YKb1* sizeCase, sizeCase/2, 100) -- hand.

  for col=1, maxX do
    for row=1, maxX do
      -- grid[col][row]
      if (grid[col][row] == 1) then
        love.graphics.setColor(1, 0, 0)
      elseif (grid[col][row] == 2) then
        love.graphics.setColor(0, 0, 1)
      elseif (grid[col][row] == 0) then
        love.graphics.setColor(0, 0, 0)
      elseif (grid[col][row] == 3) then
        love.graphics.setColor(1, 1, 1)
      else
        love.graphics.setColor(0, 1, 1) -- Error.
      end
      love.graphics.circle("fill", marge + col * sizeCase, marge + row * sizeCase, (sizeCase/2)-5, 100)
      love.graphics.setColor(0, 0, 0)
    end
  end
end

function love.keypressed(key)
--clicsound:play()
  if (key == "up") then
    YKb1 = YKb1 - 1 -- Inverted.
  end
  if (key == "down") then
    YKb1 = YKb1 + 1 -- Inverted.
  end
  if (key == "right") then
    XKb1 = XKb1 + 1 -- Not inverted.
  end
  if (key == "left") then
    XKb1 = XKb1 - 1 -- Not inverted.
  end
  if (YKb1 == 0) then
    YKb1 = maxY
  end
  if (XKb1 == 0) then
    XKb1 = maxX
  end
  if (YKb1 > maxY) then
    YKb1 = 1
  end
  if (XKb1 > maxX) then
    XKb1 = 1
  end
end

function love.update(dt)
end

function test()
  return true
end

function love.keyreleased(key)
  if (key == "escape") then
    love.event.quit()
  end
  if ((hand == 0) and (key == "return") and (test() ) and (not(grid[XKb1][YKb1] == 0))) then
    clicsound1:play()

    hand = grid[XKb1][YKb1]
    grid[XKb1][YKb1] = 0
    --  not end -- elseif needed, because situation corrupted.
  elseif ((not(hand == 0)) and (key == "return") and (test() ) and (grid[XKb1][YKb1] == 0)) then
    clicsound2:play()
    grid[XKb1][YKb1] = hand
    hand = 0
  end
end
