import XCTest
@testable import EncaixaFormasiOS

final class EncaixaFormasiOSTests: XCTestCase {

    func testMontessoriLogic_RelaxedColorMatching() {
        // 1. Setup Board with a Red Square slot at (0,0)
        let boardConfig: [GridPosition: BoardCell] = [
            GridPosition(row: 0, col: 0): BoardCell(shape: .square, color: .red, isOccupied: false)
        ]
        
        // Create a 1x1 Level
        // Note: We need to mock or create a simple level. 
        // Since Level struct is simple, we can init it directly.
        // But we need a Piece too.
        
        // 2. Create a Blue Square Piece
        let pieceMatrix: [[ShapeType]] = [[.square]]
        let bluePiece = Piece(id: UUID(), color: .blue, matrix: pieceMatrix, currentPosition: nil)
        
        let level = Level(
            id: 999,
            boardRows: 1,
            boardCols: 1,
            boardConfiguration: boardConfig,
            pieces: [bluePiece]
        )
        
        // 3. Init GameEngine
        let engine = GameEngine(level: level)
        
        // 4. Verify Default Behavior (Montessori Mode: Strict Color = false)
        // Should allow Blue Piece in Red Slot because Shapes match (Square == Square)
        XCTAssertFalse(engine.strictColorMatching, "Default should be non-strict")
        let canPlaceRelaxed = engine.canPlace(piece: bluePiece, at: GridPosition(row: 0, col: 0))
        XCTAssertTrue(canPlaceRelaxed, "Should allow placement when colors mismatch but shapes match in Montessori mode")
        
        // 5. Verify Strict Mode
        engine.strictColorMatching = true
        let canPlaceStrict = engine.canPlace(piece: bluePiece, at: GridPosition(row: 0, col: 0))
        XCTAssertFalse(canPlaceStrict, "Should NOT allow placement when colors mismatch in strict mode")
        
        // 6. Verify Shape Mismatch is ALWAYS rejected
        // Create a Circle Piece
        let circleMatrix: [[ShapeType]] = [[.circle]]
        let circlePiece = Piece(id: UUID(), color: .red, matrix: circleMatrix, currentPosition: nil) // Color matches, Shape doesn't
        
        engine.strictColorMatching = false
        let canPlaceShapeMismatch = engine.canPlace(piece: circlePiece, at: GridPosition(row: 0, col: 0))
        XCTAssertFalse(canPlaceShapeMismatch, "Should never allow shape mismatch")
    }
}
