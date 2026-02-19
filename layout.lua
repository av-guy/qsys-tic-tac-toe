function CreateTicTacToeLayout(props)
  local layout = {}
  local graphics = {}

  local cellSize = { 50, 50 }
  local cellGap = 5
  local boardX = 20
  local boardY = 20

  for row = 0, 2 do
    for col = 0, 2 do
      local name = string.format("Cell%d%d", row, col)
      local additionalYMargin = 20

      layout[name] = {
        PrettyName = "Cell" .. row .. col,
        FontSize = 24,
        Style = "Button",
        Position = { boardX + col * (cellSize[1] + cellGap),
          boardY + additionalYMargin + row * (cellSize[2] + cellGap) },
        Size = cellSize
      }
    end
  end

  local modeX = boardX + 3 * (cellSize[1] + cellGap) + 30
  local modeY = boardY
  local yMargin = 20
  local modeW = 100
  local modeH = 30
  local modeGap = 10

  layout["OnePlayer"] = {
    PrettyName = "1 Player",
    Legend = "1 Player",
    FontSize = 12,
    Style = "Button",
    Position = { modeX, modeY + yMargin },
    Size = { modeW, modeH }
  }

  layout["TwoPlayer"] = {
    PrettyName = "2 Players",
    Legend = "2 Players",
    FontSize = 12,
    Style = "Button",
    Position = { modeX, modeY + modeH + modeGap + yMargin },
    Size = { modeW, modeH }
  }

  layout["GameStatus"] = {
    PrettyName = "Game Status",
    Style = "Text",
    FontSize = 10,
    Position = { 250, 70 },
    Size = { 140, 20 }
  }

  layout["StartGame"] = {
    PrettyName = "Start Game",
    Legend = "Start",
    FontSize = 12,
    Style = "Button",
    Position = { modeX,
      modeY + 2 * (modeH + modeGap) + cellSize[1] + cellGap + 15 },
    Size = { modeW, modeH }
  }

  layout["TicTacToe"] = {
    PrettyName = "Tic-Tac-Toe",
    Position = { boardX + 3, boardY - 15 },
    Size = { (50 * 3 + 5 * 3) - 10, 20 },
    FontSize = 14,
    HTextAlign = "Center",
    StrokeColor = { 102, 102, 102, 0 },
    Color = { 102, 102, 102 },
  }

  table.insert(graphics, {
    Type = "Text",
    Text = "Mode",
    Position = { modeX, modeY - 15 },
    Size = { 80, 20 },
    FontSize = 14,
    HTextAlign = "Left"
  })

  return layout, graphics
end

function GetControlLayout(props)
  local layout, graphics = CreateTicTacToeLayout(props)
  return layout, graphics
end
