-- https://www.youtube.com/watch?v=P_mHlsrAhKc
function love.load()
  maxX = 5 -- ODD! 5 minimum!
  maxY = maxX -- Square!
  sizeCase = 100
  marge = 5

  initialisation( )
end

function initialisation()
  grid={}
  for col=1, maxX do
    grid[col] = {}
    for row=1, maxX do
      if (row == 1) then
        grid[col][row] = 1
      elseif ((col == row) and (row == math.ceil(maxX/2))) then
        grid[col][row] = 3
      elseif (row == maxX) then
        grid[col][row] = 2
      else
        grid[col][row] = 0
      end
    end
  end
  XKb1 = 3
  YKb1 = maxY

end


function love.draw()
-- 90, 58, 34
  love.graphics.setColor(0.35, 0.22, 0.13)
  love.graphics.rectangle( "fill", marge + sizeCase/2, marge + sizeCase/2, maxX * sizeCase, maxX * sizeCase, 15, 15, 100 )
  love.graphics.setColor(1, 1, 0)
        love.graphics.circle("fill", marge + XKb1 * sizeCase, marge + YKb1* sizeCase, 50, 100) -- Draw white circle with 100 segments.

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
      love.graphics.circle("fill", marge + col * sizeCase, marge + row * sizeCase, 50-5, 100)
      love.graphics.setColor(0, 0, 0)
    end
  end


end




function love.keypressed(key)
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


function love.keyreleased(key)

  if (key == "escape") then
    love.event.quit()
  end
end
