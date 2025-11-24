import Foundation

class GameEngine {
    
    // MARK: - Properties
    
    private(set) var currentLevel: Level
    private(set) var boardState: [[BoardCell]]
    
    // MARK: - Initialization
    
    init(level: Level) {
        self.currentLevel = level
        self.boardState = Array(repeating: Array(repeating: BoardCell(shape: .none, color: nil), count: level.boardCols), count: level.boardRows)
        setupBoard()
    }
    
    private func setupBoard() {
        for (pos, cell) in currentLevel.boardConfiguration {
            if pos.row < currentLevel.boardRows && pos.col < currentLevel.boardCols {
                boardState[pos.row][pos.col] = cell
            }
        }
    }
    
    // MARK: - Game Logic
    
    func canPlace(piece: Piece, at position: GridPosition) -> Bool {
        let rows = piece.matrix.count
        let cols = piece.matrix[0].count
        
        for r in 0..<rows {
            for c in 0..<cols {
                let pieceShape = piece.matrix[r][c]
                
                // If the part of the piece is empty, we don't care what's on the board (unless we want to enforce "solid" pieces, but the game has holes)
                // Actually, looking at the game, the piece is solid PLASTIC, but has HOLES.
                // So a "solid" part of the piece (not .none) must land on a valid spot.
                // AND the hole in the piece must match the shape on the board?
                // Let's refine:
                // The images show pieces like Tetris blocks. They have holes.
                // The board has icons.
                // Rule: The piece's solid parts must fit in the grid.
                // Rule: The piece's holes must align with the board's icons?
                // Wait, looking closer at Image 2: "figuras vazadas fiquem sobrepostas aos círculos e quadrados da cartela".
                // "Vazado" means hollow/hole.
                // So: The piece has a shape. The "hole" in the piece must land on top of the matching shape on the board.
                
                if pieceShape != .none {
                    let boardRow = position.row + r
                    let boardCol = position.col + c
                    
                    // 1. Check Boundaries
                    if boardRow < 0 || boardRow >= currentLevel.boardRows || boardCol < 0 || boardCol >= currentLevel.boardCols {
                        return false
                    }
                    
                    let boardCell = boardState[boardRow][boardCol]
                    
                    // 2. Check Collision (is another piece already there?)
                    if boardCell.isOccupied {
                        return false
                    }
                    
                    // 3. Check Rule: Shape Match
                    // The piece hole (pieceShape) must match the board cell shape
                    if pieceShape != boardCell.shape {
                        return false
                    }
                    
                    // 4. Check Rule: Color Match
                    // The piece color must match the board cell color
                    if let cellColor = boardCell.color, cellColor != piece.color {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func place(piece: Piece, at position: GridPosition) -> Bool {
        guard canPlace(piece: piece, at: position) else { return false }
        
        let rows = piece.matrix.count
        let cols = piece.matrix[0].count
        
        for r in 0..<rows {
            for c in 0..<cols {
                if piece.matrix[r][c] != .none {
                    let boardRow = position.row + r
                    let boardCol = position.col + c
                    boardState[boardRow][boardCol].isOccupied = true
                }
            }
        }
        return true
    }
    
    func remove(piece: Piece, from position: GridPosition) {
        let rows = piece.matrix.count
        let cols = piece.matrix[0].count
        
        for r in 0..<rows {
            for c in 0..<cols {
                if piece.matrix[r][c] != .none {
                    let boardRow = position.row + r
                    let boardCol = position.col + c
                    if boardRow >= 0 && boardRow < currentLevel.boardRows && boardCol >= 0 && boardCol < currentLevel.boardCols {
                        boardState[boardRow][boardCol].isOccupied = false
                    }
                }
            }
        }
    }
    
    func checkWinCondition() -> Bool {
        // Win if all target cells are occupied
        for r in 0..<currentLevel.boardRows {
            for c in 0..<currentLevel.boardCols {
                let cell = boardState[r][c]
                // If it's a target cell (has a shape) and is NOT occupied, then not won yet.
                if cell.shape != .none && !cell.isOccupied {
                    return false
                }
            }
        }
        return true
    }
}
