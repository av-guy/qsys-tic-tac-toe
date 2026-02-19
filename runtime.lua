---@diagnostic disable: undefined-global

local PLAYER = "X"
local SIZE = 3
local MODE = nil
local EMPTY = ""
local GAME_STATUS = "initialized"
local MAX_PLAYER = "X"
local MIN_PLAYER = "O"

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

local function checkWin(board, size)
  for i = 1, size do
    if board[i][1] ~= EMPTY and board[i][1] == board[i][2] and board[i][2] == board[i][3] then
      return board[i][1]
    end
    if board[1][i] ~= EMPTY and board[1][i] == board[2][i] and board[2][i] == board[3][i] then
      return board[1][i]
    end
  end

  if board[1][1] ~= EMPTY and board[1][1] == board[2][2] and board[2][2] == board[3][3] then
    return board[1][1]
  end

  if board[1][3] ~= EMPTY and board[1][3] == board[2][2] and board[2][2] == board[3][1] then
    return board[1][3]
  end

  for i = 1, size do
    for j = 1, size do
      if board[i][j] == EMPTY then
        return "ongoing"
      end
    end
  end

  return "draw"
end

local function drawBoardState(boardPieces)
  for i, row in ipairs(BOARD) do
    for j, cell in ipairs(row) do
      local idx = rowColToIndex(i, j, SIZE)
      boardPieces[idx].Legend = cell or ""
    end
  end
end

local function availableMoves(board, size)
  local moves = {}

  for r = 1, size do
    for c = 1, size do
      if board[r][c] == EMPTY then
        table.insert(moves, { r, c })
      end
    end
  end
  return moves
end

local function utility(terminalResult, depth)
  if terminalResult == MAX_PLAYER then
    return 10 - depth
  elseif terminalResult == MIN_PLAYER then
    return depth - 10
  else
    return 0
  end
end

local function minimax(board, depth, maximizing, alpha, beta, size)
  local terminal = checkWin(board, size)

  if terminal ~= nil or #availableMoves(board, size) == 0 then
    return utility(terminal, depth)
  end

  local best = maximizing and -1000 or 1000
  for _, move in ipairs(availableMoves(board, size)) do
    local r, c = move[1], move[2]
    board[r][c] = maximizing and MAX_PLAYER or MIN_PLAYER
    local val = minimax(board, depth + 1, not maximizing, alpha, beta, size)

    if maximizing then
      if val > best then best = val end
      if best > alpha then alpha = best end
    else
      if val < best then best = val end
      if best < beta then beta = best end
    end

    board[r][c] = EMPTY

    if beta <= alpha then
      return best
    end
  end

  return best
end

local function getBestMove(board, size)
  local bestScore = -1000
  local bestMove  = nil

  for _, move in ipairs(availableMoves(board, size)) do
    local r, c = move[1], move[2]
    board[r][c] = MAX_PLAYER

    local score = minimax(board, 0, false, -1000, 1000, size)
    board[r][c] = EMPTY
    if score > bestScore then
      bestScore = score
      bestMove  = { r, c }
    end
  end

  return bestMove
end

local function changeBoardPieceStates(boardPieces, isDisabled)
  for _, b in ipairs(boardPieces) do
    b.IsDisabled = isDisabled
  end
end

local function makeComputerMove()
  PLAYER = "O"

  local bestMove = getBestMove(BOARD, SIZE)
  local bestRow = nil
  local bestCol = nil

  if bestMove then
    bestRow = bestMove[1]
    bestCol = bestMove[2]
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
            BOARD[row][col] = PLAYER
          else
            changeBoardPieceStates(boardPieces, false)
            return
          end
        end

        if PLAYER == "X" then
          mainLabel.String = "O's Turn"
          makeComputerMove()
        end

        mainLabel.String = "X's Turn"
        PLAYER = "X"

        drawBoardState(boardPieces)

        GAME_STATUS = checkWin(BOARD, SIZE)
        updateGameStatus(boardPieces, mainLabel)
      end
    end
  end
end

local function startApp(onePlayer, twoPlayer, startGame, boardPieces)
  BOARD = resetBoard()
  PLAYER = "X"
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
            BOARD[row][col] = PLAYER
          else
            changeBoardPieceStates(boardPieces, false)
            return
          end
        end

        if PLAYER == "X" then
          mainLabel.String = "O's Turn"
          PLAYER = "O"
        else
          mainLabel.String = "X's Turn"
          PLAYER = "X"
        end

        drawBoardState(boardPieces)

        GAME_STATUS = checkWin(BOARD, SIZE)
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
