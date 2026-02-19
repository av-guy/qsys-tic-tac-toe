# Q‑SYS Tic‑Tac‑Toe Plugin

A simple Tic‑Tac‑Toe game implemented as a Q‑SYS Designer plugin. Play against the computer (1 player) or with a friend (2 players) within the Q-SYS Designer Software.

## 📦 Installation

1. **Download / Build**
   - Clone the repository:
     ```bash
     git clone https://github.com/av-guy/qsys-tic-tac-toe
     ```
   - Open the folder in **Visual Studio Code**.
   - Run the provided **Build Task** (`Terminal → Run Build Task` or `Ctrl+Shift+B`).
   - The task produces a `tic-tac-toe.qplug` file.

2. **Install on a Q‑SYS system**
   - Locate the generated `.qplug` file.
   - Double‑click the file (or drag it onto the Q‑SYS Designer window).
   - The plugin is added to the design and ready to use.

_Alternatively, you can use the provided Q-SYS project file to load the plugin. Within the sample project, the controls from the plugin are copied and
pasted directly into the available Interface_

## 🎮 How to Play

1. **Select Mode**
   - Click **“1 Player”** → you are **X**, the computer plays **O**.
   - Click **“2 Players”** → two humans alternate turns, starting with **X**.

2. **Start the Game**
   - Press **“Start Game”**.
   - The label at the top of the interface shows the current status (e.g., “X’s turn”, “O’s turn”, “X wins!”, “Draw”, etc.).

3. **Make Moves**
   - Tap any empty cell on the 3 × 3 grid.
   - In 1‑player mode the computer will immediately respond with its move.

4. **Game End**
   - When a win or a draw is detected, the status label updates accordingly.
   - To play again: press **“Reset”**, choose a new mode (if desired), then press **“Start Game”**.

## 🛠️ Development

- **Language**: Lua (Q‑SYS Control Script)
- **UI**: Defined via `CreateTicTacToeLayout` and `GetControls`.
- **AI**: Minimax with alpha‑beta pruning (maximizer = X, minimizer = O).
- **Build System**: Uses the standard Q‑SYS plugin task defined in `.vscode/tasks.json`.

## 📄 License

MIT License – see the `LICENSE` file in the repository.

## 📞 Support

Open an issue on the GitHub repo: <https://github.com/av-guy/qsys-tic-tac-toe>
