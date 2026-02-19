function GetControls(props)
  local ctrls = {}
  for row = 0, 2 do
    for col = 0, 2 do
      local name = string.format("Cell%d%d", row, col)
      table.insert(ctrls, {
        Name = name,
        ControlType = "Button",
        ButtonType = "Momentary",
        PinStyle = "Input",
        UserPin = true
      })
    end
  end

  table.insert(ctrls, {
    Name = "TicTacToe",
    ControlType = "Indicator",
    IndicatorType = "Text",
    UserPin = false
  })

  table.insert(ctrls, {
    Name = "OnePlayer",
    ControlType = "Button",
    ButtonType = "Toggle",
    PinStyle = "Input",
    UserPin = true
  })

  table.insert(ctrls, {
    Name = "TwoPlayer",
    ControlType = "Button",
    ButtonType = "Toggle",
    PinStyle = "Input",
    UserPin = true
  })

  table.insert(ctrls, {
    Name = "StartGame",
    ControlType = "Button",
    ButtonType = "Momentary",
    PinStyle = "Input",
    UserPin = true
  })

  return ctrls
end
