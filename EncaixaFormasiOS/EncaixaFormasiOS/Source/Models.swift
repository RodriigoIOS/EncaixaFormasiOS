import UIKit

// MARK: - Enums

enum ShapeType {
    case circle
    case square
    case none // For empty spaces in the piece grid
}

enum PieceColor {
    case red
    case blue
    case yellow
    case green
    
    var uiColor: UIColor {
        switch self {
        case .red: return UIColor.systemRed
        case .blue: return UIColor.systemBlue
        case .yellow: return UIColor.systemYellow
        case .green: return UIColor.systemGreen
        }
    }
}

// MARK: - Models

struct GridPosition: Hashable {
    let row: Int
    let col: Int
}

struct BoardCell {
    let shape: ShapeType
    let color: PieceColor? // The color required for this cell
    var isOccupied: Bool = false
}

struct Piece {
    let id: UUID
    let color: PieceColor
    let matrix: [[ShapeType]] // 2D array representing the piece shape. .none means empty space/hole
    var currentPosition: GridPosition? // nil if not on board
}

struct Level {
    let id: Int
    let boardRows: Int
    let boardCols: Int
    let boardConfiguration: [GridPosition: BoardCell]
    let pieces: [Piece]
}
