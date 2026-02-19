---@diagnostic disable: undefined-global

local HUMAN_PLAYER = "X"
local SIZE = 3
local MODE = nil
local EMPTY = "_"
local GAME_STATUS = "initialized"
local PLAYER = "O"
local OPPONENT = "X"

local OPENING_BOOK = {
  ["X________"] = { 2, 2 },
  ["XX__O____"] = { 1, 3 },
  ["X__XO____"] = { 3, 1 },
  ["X___OX___"] = { 1, 2 },
  ["X___O__X_"] = { 2, 1 },
  ["_X_______"] = { 1, 1 },
  ["OXX______"] = { 2, 1 },
  ["OX___X___"] = { 3, 1 },
  ["OX____X__"] = { 2, 2 },
  ["OX_____X_"] = { 2, 2 },
  ["OX______X"] = { 2, 2 },
  ["__X______"] = { 2, 2 },
  ["X_X_O____"] = { 1, 2 },
  ["_XX_O____"] = { 1, 1 },
  ["__XXO____"] = { 1, 1 },
  ["__X_OX___"] = { 3, 3 },
  ["__X_O__X_"] = { 2, 1 },
  ["___X_____"] = { 1, 1 },
  ["OX_X_____"] = { 2, 2 },
  ["O_XX_____"] = { 2, 2 },
  ["O__X_X___"] = { 2, 2 },
  ["O__X__X__"] = { 1, 2 },
  ["O__X___X_"] = { 1, 3 },
  ["O__X____X"] = { 1, 3 },
  ["____X____"] = { 1, 1 },
  ["OX__X____"] = { 3, 2 },
  ["O_X_X____"] = { 3, 1 },
  ["O__XX____"] = { 2, 3 },
  ["O___XX___"] = { 2, 1 },
  ["O___X_X__"] = { 1, 3 },
  ["O___X__X_"] = { 1, 2 },
  ["O___X___X"] = { 1, 3 },
  ["_____X___"] = { 1, 3 },
  ["X_O__X___"] = { 2, 1 },
  ["_XO__X___"] = { 2, 1 },
  ["__OX_X___"] = { 2, 2 },
  ["__O_XX___"] = { 2, 1 },
  ["__O__XX__"] = { 1, 1 },
  ["__O__X_X_"] = { 1, 1 },
  ["__O__X__X"] = { 1, 1 },
  ["______X__"] = { 2, 2 },
  ["X___O_X__"] = { 2, 1 },
  ["_X__O_X__"] = { 1, 1 },
  ["__X_O_X__"] = { 1, 2 },
  ["___XO_X__"] = { 1, 1 },
  ["____OXX__"] = { 1, 2 },
  ["____O_XX_"] = { 3, 3 },
  ["_______X_"] = { 1, 2 },
  ["XO_____X_"] = { 3, 1 },
  ["_OX____X_"] = { 3, 1 },
  ["_O_X___X_"] = { 3, 1 },
  ["_O__X__X_"] = { 1, 1 },
  ["_O___X_X_"] = { 3, 1 },
  ["_O____XX_"] = { 3, 3 },
  ["_O_____XX"] = { 3, 1 },
  ["________X"] = { 2, 2 },
  ["X___O___X"] = { 1, 2 },
  ["_X__O___X"] = { 1, 1 },
  ["__X_O___X"] = { 2, 3 },
  ["___XO___X"] = { 1, 1 },
  ["____OX__X"] = { 1, 3 },
  ["____O_X_X"] = { 3, 2 },
  ["____O__XX"] = { 3, 1 },
}

local BOARD = {
  { EMPTY, EMPTY, EMPTY },
  { EMPTY, EMPTY, EMPTY },
  { EMPTY, EMPTY, EMPTY }
}

local function indexToRowCol(idx, size)
  local zeroBased = idx - 1
  local row = math.floor(zeroBased / size) + 1
  local col = (zeroBased % size) + 1
  return row, col
end

local function rowColToIndex(row, col, size)
  local zeroBased = (row - 1) * size + (col - 1)
  return zeroBased + 1
end

local function resetBoard()
  return {
    { EMPTY, EMPTY, EMPTY },
    { EMPTY, EMPTY, EMPTY },
    { EMPTY, EMPTY, EMPTY }
  }
end

local function isMovesLeft(board)
  for i = 1, 3 do
    for j = 1, 3 do
      if board[i][j] == EMPTY then
        return true
      end
    end
  end
  return false
end

local function evaluate(b)
  for row = 1, 3 do
    if b[row][1] ~= EMPTY and b[row][1] == b[row][2] and b[row][2] == b[row][3] then
      if b[row][1] == PLAYER then
        return 10
      elseif b[row][1] == OPPONENT then
        return -10
      end
    end
  end

  for col = 1, 3 do
    if b[1][col] ~= EMPTY and b[1][col] == b[2][col] and b[2][col] == b[3][col] then
      if b[1][col] == PLAYER then
        return 10
      elseif b[1][col] == OPPONENT then
        return -10
      end
    end
  end

  if b[1][1] ~= EMPTY and b[1][1] == b[2][2] and b[2][2] == b[3][3] then
    if b[1][1] == PLAYER then
      return 10
    elseif b[1][1] == OPPONENT then
      return -10
    end
  end

  if b[1][3] ~= EMPTY and b[1][3] == b[2][2] and b[2][2] == b[3][1] then
    if b[1][3] == PLAYER then
      return 10
    elseif b[1][3] == OPPONENT then
      return -10
    end
  end

  return 0
end

local function minimax(board, depth, isMax, alpha, beta)
  local score = evaluate(board)

  if score == 10 then return score - depth end
  if score == -10 then return score + depth end
  if not isMovesLeft(board) then return 0 end

  if isMax then
    local best = -1000
    for i = 1, 3 do
      for j = 1, 3 do
        if board[i][j] == EMPTY then
          board[i][j] = PLAYER
          best = math.max(best, minimax(board, depth + 1, false, alpha, beta))
          board[i][j] = EMPTY
          alpha = math.max(alpha, best)
          if beta <= alpha then return best end
        end
      end
    end
    return best
  else
    local best = 1000
    for i = 1, 3 do
      for j = 1, 3 do
        if board[i][j] == EMPTY then
          board[i][j] = OPPONENT
          best = math.min(best, minimax(board, depth + 1, true, alpha, beta))
          board[i][j] = EMPTY
          beta = math.min(beta, best)
          if beta <= alpha then return best end
        end
      end
    end
    return best
  end
end

local function getBoardKey(b)
  local k = ""
  for i = 1, 3 do for j = 1, 3 do k = k .. b[i][j] end end
  return k
end

local function findBestMove(board)
  local bestVal = -1000
  local bestMove = { row = -1, col = -1 }

  for i = 1, 3 do
    for j = 1, 3 do
      if board[i][j] == EMPTY then
        board[i][j] = PLAYER
        local moveVal = minimax(board, 0, false, -1000, 1000)
        board[i][j] = EMPTY

        if moveVal > bestVal then
          bestMove.row = i
          bestMove.col = j
          bestVal = moveVal
        end
      end
    end
  end

  return bestMove
end

local function getSmartMove(board)
  local key = getBoardKey(board)

  if OPENING_BOOK[key] then
    local bookMove = OPENING_BOOK[key]

    print(string.format("Tic-Tac-Toe: OPENING_BOOK Lookup Found for key [%s]", key))
    print(string.format("Tic-Tac-Toe: OPENING_BOOK row = %d col = %d", bookMove[1], bookMove[2]))

    return { row = bookMove[1], col = bookMove[2] }
  end

  print(string.format("Tic-Tac-Toe: OPENING_BOOK Lookup Not Found for key [%s]", key))
  print("Tic-Tac-Toe: Finding Best Move With Minimax")

  return findBestMove(board)
end

local function drawBoardState(boardPieces)
  for i, row in ipairs(BOARD) do
    for j, cell in ipairs(row) do
      local idx = rowColToIndex(i, j, SIZE)
      local presentationVal = cell

      if presentationVal == "_" then
        presentationVal = ""
      end

      boardPieces[idx].Legend = presentationVal
    end
  end
end

local function changeBoardPieceStates(boardPieces, isDisabled)
  for _, b in ipairs(boardPieces) do
    b.IsDisabled = isDisabled
  end
end

local function makeComputerMove()
  local bestMove = getSmartMove(BOARD)
  local bestRow = nil
  local bestCol = nil

  if bestMove then
    bestRow = bestMove.row
    bestCol = bestMove.col
    print("Computer decided that best move is " .. bestRow .. " " .. bestCol)
  end

  if BOARD[bestRow] and bestRow and bestCol then
    if BOARD[bestRow][bestCol] == EMPTY then
      BOARD[bestRow][bestCol] = "O"
    end
  end
end

local function updateGameStatus(boardPieces, mainLabel)
  if GAME_STATUS == "draw" then
    mainLabel.String = "It's a draw!"
  elseif GAME_STATUS == "X" or GAME_STATUS == "O" then
    mainLabel.String = GAME_STATUS .. " Wins!"
  end

  if GAME_STATUS == "ongoing" then
    changeBoardPieceStates(boardPieces, false)
  end
end

local function initializeComputerPlayer(boardPieces, mainLabel)
  BOARD = resetBoard()
  mainLabel.String = "X's Turn"

  PLAYER = "O"
  OPPONENT = "X"

  for i, b in ipairs(boardPieces) do
    b.IsDisabled = false
    changeBoardPieceStates(boardPieces, false)

    b.EventHandler = function(self)
      if self.Value == 1 then
        self.IsDisabled = true
        changeBoardPieceStates(boardPieces, true)
        local row, col = indexToRowCol(i, SIZE)

        if BOARD[row] then
          if BOARD[row][col] == EMPTY then
            BOARD[row][col] = HUMAN_PLAYER
          else
            changeBoardPieceStates(boardPieces, false)
            return
          end
        end

        if HUMAN_PLAYER == "X" then
          mainLabel.String = "O's Turn"
          makeComputerMove()
        end

        mainLabel.String = "X's Turn"
        HUMAN_PLAYER = "X"

        drawBoardState(boardPieces)

        local terminalState = evaluate(BOARD)
        if terminalState < 0 then
          GAME_STATUS = "X"
        elseif terminalState > 0 then
          GAME_STATUS = "O"
        elseif terminalState == 0 and isMovesLeft(BOARD) == false then
          GAME_STATUS = "draw"
        else
          GAME_STATUS = "ongoing"
        end

        updateGameStatus(boardPieces, mainLabel)
      end
    end
  end
end

local function startApp(onePlayer, twoPlayer, startGame, boardPieces)
  BOARD = resetBoard()
  HUMAN_PLAYER = "X"
  GAME_STATUS = "initialized"
  drawBoardState(boardPieces)
  onePlayer.Value = 0
  twoPlayer.Value = 0
  onePlayer.IsDisabled = false
  twoPlayer.IsDisabled = false
  startGame.IsDisabled = true
  changeBoardPieceStates(boardPieces, true)
end

local function initializeTwoPlayer(boardPieces, mainLabel)
  BOARD = resetBoard()
  mainLabel.String = "X's Turn"

  PLAYER = "X"
  OPPONENT = "O"

  for i, b in ipairs(boardPieces) do
    b.IsDisabled = false
    changeBoardPieceStates(boardPieces, false)

    b.EventHandler = function(self)
      if self.Value == 1 then
        self.IsDisabled = true
        changeBoardPieceStates(boardPieces, true)
        local row, col = indexToRowCol(i, SIZE)
        if BOARD[row] then
          if BOARD[row][col] == EMPTY then
            BOARD[row][col] = HUMAN_PLAYER
          else
            changeBoardPieceStates(boardPieces, false)
            return
          end
        end

        if HUMAN_PLAYER == "X" then
          mainLabel.String = "O's Turn"
          HUMAN_PLAYER = "O"
        else
          mainLabel.String = "X's Turn"
          HUMAN_PLAYER = "X"
        end

        drawBoardState(boardPieces)

        local terminalState = evaluate(BOARD)
        if terminalState < 0 then
          GAME_STATUS = "O"
        elseif terminalState > 0 then
          GAME_STATUS = "X"
        elseif terminalState == 0 and isMovesLeft(BOARD) == false then
          GAME_STATUS = "draw"
        else
          GAME_STATUS = "ongoing"
        end

        updateGameStatus(boardPieces, mainLabel)
      end
    end
  end
end

if Controls then
  local OnePlayer = Controls.OnePlayer
  local TwoPlayer = Controls.TwoPlayer
  local StartGame = Controls.StartGame
  local MainLabel = Controls["TicTacToe"]
  local BoardPieces = {}

  MainLabel.String = "Tic-Tac-Toe"

  for row = 0, 2 do
    for col = 0, 2 do
      local name = string.format("Cell%d%d", row, col)
      table.insert(BoardPieces, Controls[name])
    end
  end

  startApp(OnePlayer, TwoPlayer, StartGame, BoardPieces)

  OnePlayer.EventHandler = function(self)
    if TwoPlayer.Value == 1 then
      TwoPlayer.Value = 0
    end

    self.Value = 1
    MODE = "1 Player"
    StartGame.IsDisabled = false
  end

  TwoPlayer.EventHandler = function(self)
    if OnePlayer.Value == 1 then
      OnePlayer.Value = 0
    end

    self.Value = 1
    MODE = "2 Player"
    StartGame.IsDisabled = false
  end

  StartGame.EventHandler = function(self)
    if self.Value == 1 and GAME_STATUS == "initialized" then
      self.Legend = "Reset"
      GAME_STATUS = "ongoing"
      TwoPlayer.IsDisabled = true
      OnePlayer.IsDisabled = true

      if MODE == "1 Player" then
        initializeComputerPlayer(BoardPieces, MainLabel)
      else
        initializeTwoPlayer(BoardPieces, MainLabel)
      end
    elseif self.Value == 1 and GAME_STATUS ~= "initialized" then
      self.Legend = "Start"
      MainLabel.String = "Tic-Tac-Toe"
      startApp(OnePlayer, TwoPlayer, StartGame, BoardPieces)
    end
  end
end
