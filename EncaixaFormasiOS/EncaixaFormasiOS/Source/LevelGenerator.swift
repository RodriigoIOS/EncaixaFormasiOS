import Foundation

struct LevelGenerator {
    
    static func generateLevel1() -> Level {
        // Level 1: 4x4 Grid
        // Goal: Fill the grid with 4 pieces.
        
        let rows = 4
        let cols = 4
        var config: [GridPosition: BoardCell] = [:]
        
        // --- Piece 1: 2x2 Red Square (Top-Left) ---
        // Occupies: (0,0), (0,1), (1,0), (1,1)
        // Shape: Circle
        for r in 0...1 {
            for c in 0...1 {
                config[GridPosition(row: r, col: c)] = BoardCell(shape: .circle, color: .red, isOccupied: false)
            }
        }
        let piece1Matrix: [[ShapeType]] = [
            [.circle, .circle],
            [.circle, .circle]
        ]
        let piece1 = Piece(id: UUID(), color: .red, matrix: piece1Matrix, currentPosition: nil)
        
        // --- Piece 2: 2x2 Blue Square (Top-Right) ---
        // Occupies: (0,2), (0,3), (1,2), (1,3)
        // Shape: Square
        for r in 0...1 {
            for c in 2...3 {
                config[GridPosition(row: r, col: c)] = BoardCell(shape: .square, color: .blue, isOccupied: false)
            }
        }
        let piece2Matrix: [[ShapeType]] = [
            [.square, .square],
            [.square, .square]
        ]
        let piece2 = Piece(id: UUID(), color: .blue, matrix: piece2Matrix, currentPosition: nil)
        
        // --- Piece 3: 4x1 Yellow Line (Row 2) ---
        // Occupies: (2,0), (2,1), (2,2), (2,3)
        // Shape: Circle
        for c in 0...3 {
            config[GridPosition(row: 2, col: c)] = BoardCell(shape: .circle, color: .yellow, isOccupied: false)
        }
        let piece3Matrix: [[ShapeType]] = [
            [.circle, .circle, .circle, .circle]
        ]
        let piece3 = Piece(id: UUID(), color: .yellow, matrix: piece3Matrix, currentPosition: nil)
        
        // --- Piece 4: 4x1 Green Line (Row 3) ---
        // Occupies: (3,0), (3,1), (3,2), (3,3)
        // Shape: Square
        for c in 0...3 {
            config[GridPosition(row: 3, col: c)] = BoardCell(shape: .square, color: .green, isOccupied: false)
        }
        let piece4Matrix: [[ShapeType]] = [
            [.square, .square, .square, .square]
        ]
        let piece4 = Piece(id: UUID(), color: .green, matrix: piece4Matrix, currentPosition: nil)
        
        return Level(
            id: 1,
            boardRows: rows,
            boardCols: cols,
            boardConfiguration: config,
            pieces: [piece1, piece2, piece3, piece4]
        )
    }
}
