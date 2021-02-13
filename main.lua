-- https://www.youtube.com/watch?v=P_mHlsrAhKc
function love.load()
  maxX = 5 -- ODD! 5 minimum!
  maxY = maxX -- Square!
  sizeCase = 100
  marge = 5
  XKb1 = 4
  YKb1 = 2
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

end


function love.keyreleased(key)
  -- action = nil
  if key == "escape" then
    love.event.quit()
  end
end
