-- https://www.youtube.com/watch?v=P_mHlsrAhKc
-- https://timboisco.fr/wp-content/uploads/2018/07/Le-BOBAIL.pdf
-- TODO:
-- Bobail playable, player playable, ordre. DONE?
-- Test de coincé raté, ptet fait au mauvais moment.  BUG
-- Must play good: no cheat.
-- Documentation.
-- Sound.
-- IA.
-- Intro.
-- F2 restart.
-- F1 help.


function love.load()
  maxX = 5 -- ODD(?)! 5 minimum!  BAD GRAPH if not 5. BUG!
  maxY = maxX -- Square!
  marge = 5
  initialisation( )
  clicsound = love.audio.newSource("sounds/Clic.wav", "static")
  clicsound1 = love.audio.newSource("sounds/Clic.wav", "static")
  clicsound2 = love.audio.newSource("sounds/Clic.wav", "static")
  player = 1
  bobailToPlay = false
  intro = true
  introImage= love.graphics.newImage("images/intro.png")
  player1Wins = false
  player2Wins = false
  --player1Wins = true
  --player2Wins = true
  endgame = false
  coeffEnd = 42
  -- 0 is human:
  profMinMax={}
  profMinMax[1] = 0
  profMinMax[2] = 0
  -- Type of IA:
  levelAI={}
  levelAI[1] = 1
  levelAI[2] = 1
  --
end

function initialisation()
  grid={}
  for col=1, maxX do
    grid[col] = {}
    for row=1, maxX do
      if (row == 1) then
        grid[col][row] = 2 -- UpPlayer.
      elseif ((col == row) and (row == math.ceil(maxX/2))) then
        grid[col][row] = 3 -- Bobail.
        XBobail = col
        YBobail = row

      elseif (row == maxX) then
        grid[col][row] = 1 -- DownPlayer.
      else
        grid[col][row] = 0 -- Empty.
      end
    end
  end
  XKb1 = 3
  YKb1 = maxY
  hand = 0
  erasePossible()

end

function Color(p)
  if (p == 0) then -- Empty
    love.graphics.setColor(0, 0, 0)
  elseif (p == 1) then -- Player = 1
    love.graphics.setColor(1, 0, 0)
  elseif (p == 2) then -- Player = 2
    love.graphics.setColor(0, 0, 1)
  elseif (p == 3) then  -- Bobail
    love.graphics.setColor(1, 1, 1)
  end

end




function love.draw()
  if (intro == true) then


    love.graphics.draw(introImage, 0, 0, 0,  love.graphics.getWidth()/introImage:getWidth(),  love.graphics.getHeight()/introImage:getHeight())

  else


    sizeCase = math.min(love.graphics.getWidth( )/6,  love.graphics.getHeight( )/6) -- Real time!   :-D

    love.graphics.setColor(0.35, 0.22, 0.13)

    love.graphics.rectangle( "fill", marge + sizeCase/2, marge + sizeCase/2, maxX * sizeCase, maxX * sizeCase, 15, 15, 100 )    --  board.
--  love.graphics.setColor(1, 1, 0)

    Color(2)
--    love.graphics.print('Player 2 is up', love.graphics.getWidth()-150, 50)
    love.graphics.line( marge + sizeCase, marge + (sizeCase/2)+  5, maxX * sizeCase + marge, 5 + marge + (sizeCase/2))
    Color(1)
    love.graphics.line(  marge + sizeCase, marge + (maxX+0.5) * sizeCase - 5,   marge + (maxX-0) * sizeCase, marge + (maxX+0.5) * sizeCase - 5)
    --  love.graphics.print('Player 1 is down.', love.graphics.getWidth()-150, 600)


-- The color of the hand must be the color of the player :
    Color(player)

    love.graphics.circle("fill", marge + XKb1 * sizeCase, marge + YKb1* sizeCase, sizeCase/2, 100) -- hand.

    for col=1, maxX do
      for row=1, maxX do

        Color(grid[col][row])
        love.graphics.circle("fill", marge + col * sizeCase, marge + row * sizeCase, (sizeCase/2)-8, 100)

        if (gridPossible[col][row] == true) then
          Color(player)
          love.graphics.circle("fill", marge + col * sizeCase, marge + row * sizeCase, 5, 100)

        elseif (((player1Wins) and (grid[col][row]  == 1)  ) or (player2Wins) and (grid[col][row]  == 2)   ) then

          smiley(row, col, true)
          endgame = true
        elseif (((player2Wins) and (grid[col][row]  == 1)  ) or (player1Wins) and (grid[col][row]  == 2)   ) then
          smiley( row, col, false)
          endgame = true

        end
      end
--coordonnées    ?

-- historique ? -- rec ?
    end
  end

end

function erasePossible()
  gridPossible={}
  for col=1, maxX do
    gridPossible[col] = {}
    for row=1, maxX do
      gridPossible[col][row]= false
    end
  end



end

function smiley(row, col, win)
  Color(0)
  love.graphics.circle( "fill", (-sizeCase/6) + marge + (col * sizeCase), (-3 * sizeCase/30) + marge + (row * sizeCase), sizeCase/20 )
  love.graphics.circle( "fill", (sizeCase/6) + marge + (col * sizeCase), (-3 * sizeCase/30) + marge + (row * sizeCase), sizeCase/20 )
  if (win == true) then
    love.graphics.arc( "fill", marge + (col * sizeCase),  ( sizeCase/8)  + marge + (row * sizeCase), sizeCase/10 , 0, math.pi, 100 )

  else
    love.graphics.arc( "fill", marge + (col * sizeCase),  ( sizeCase/5)  + marge + (row * sizeCase), sizeCase/10 ,  -math.pi, 0, 100 )

  end
end


function toroid()
  if (XKb1 > maxX) then
    XKb1 = 1
  elseif (XKb1 == 0) then
    XKb1 = maxX
  end
  if (YKb1 > maxY) then
    YKb1 = 1
  elseif (YKb1 == 0) then
    YKb1 = maxY
  end
end



function love.keypressed(key)
  if (endgame == false) then


--clicsound:play()
    if (key == "up") then
      YKb1 = YKb1 - 1 -- Inverted.
    elseif (key == "down") then
      YKb1 = YKb1 + 1 -- Inverted.
    elseif (key == "right") then
      XKb1 = XKb1 + 1 -- Not inverted.
    elseif (key == "left") then
      XKb1 = XKb1 - 1 -- Not inverted.
    end
    toroid()
  end
end

function love.gamepadpressed(joystick, button)  -- TODO!
  if (endgame == false) then
--clicsound:play()
    if (button == "up") then
      YKb1 = YKb1 - 1 -- Inverted.
    elseif (button == "down") then
      YKb1 = YKb1 + 1 -- Inverted.
    elseif (button == "right") then
      XKb1 = XKb1 + 1 -- Not inverted.
    elseif (button == "left") then
      XKb1 = XKb1 - 1 -- Not inverted.
    end
    toroid()
  end
end


function love.update(dt) --  Smooth movements...?
end

function test()
  return true
end

function victory()

end

function eval(changeReal)-- changeReal is false for AI.
  evaluation = maxY/2 -- define stupid.
  if ((YKb1 == 1) and(grid[XKb1][YKb1] == 3)) then
    evaluation = 1
    if (changeReal == true) then

      player2Wins = true
    end
  elseif ((YKb1 == maxX) and(grid[XKb1][YKb1] == 3)) then
    evaluation= maxY
    if (changeReal == true) then

      player1Wins = true
    end
  end
  if (bobailToPlay) then
    message = "loser"

    for I=-1, 1 do
      for J=-1, 1 do
        if (possibleToPlay(XKb1 + I, YKb1  + J) == true) then
          message = ""
        end
      end
    end
    if ( message == "loser") then
      if (player == 2) then
        if (changeReal == true) then

          player1Wins = true
        end
        evaluation= maxY
      else

        if (changeReal == true) then

          player2Wins = true
        end
        evaluation = 1




      end
    end
    if (levelAI[player] == 0) then
      evaluation = evaluation * coeffEnd -- Victory or not, only.
      --  Si pas victoire, si level du joueur assez bon, on affine :
    else
      evaluation = (evaluation - (YKb1/2)) * coeffEnd -- Victory and distance only, much better!
    end
    if (levelAI[player] >= 2) then
-- evaluation = evaluation  + (possibleToPlay(x,y)) + possibleToPlay(x,y) + possibleToPlay(x,y) - (possibleToPlay(x,y) - possibleToPlay(x,y) - possibleToPlay(x,y)) -- Victory, distance and rough freedom, a little better. Needed for alpha-beta, not for minmax.

    end
    if (levelAI[player] == 3) then
      -- evaluation = evaluation  +  possibleToPlay(x,y) - (possibleToPlay(x,y) - possibleToPlay(x,y) -- Victory, distance and elaborated freedom, a little better. Needed for alpha-beta, not for minmax.
    end









    return evaluation
  end
end
function possibleToPlay(x,y) -- Not out of board, free place.
  if ((x<1) or (x > maxX) or (y<1) or (y > maxY)) then
    return false
  elseif (grid[x][y] == 0) then
    return true
  else
    return false
  end
end

function love.keyreleased(key)
  if ((key == "escape") and (intro == true))then
    intro  = false

  elseif ((key == "escape") and (intro == false))then
    love.event.quit()
  end


  if ((hand == 0) and (key == "return") and (test() ) and ( ((grid[XKb1][YKb1] == player) and (bobailToPlay == false)) or ((grid[XKb1][YKb1] == 3) and (bobailToPlay == true))) ) then
    clicsound1:play()

    hand = grid[XKb1][YKb1]
    grid[XKb1][YKb1] = 0
    --  not "end" and "if" -- elseif needed, because the situation is corrupted: we need to take and NOT to lay immediately.
  elseif ((not(hand == 0)) and (key == "return") and (test() ) and (grid[XKb1][YKb1] == 0)) then
    clicsound2:play()
    grid[XKb1][YKb1] = hand
    hand = 0


--  funct endgame inside funct evaluation.
--    print(eval())
    eval(true)




    if (bobailToPlay == false) then
      player = 3 - player
      bobailToPlay = true
      XKb1 =XBobail
      YKb1 =YBobail
      --  Bobail jouable sur 8 cases maxi.
--for
    else

      bobailToPlay = false
      XBobail = XKb1
      YBobail = YKb1
    end
  end
end
