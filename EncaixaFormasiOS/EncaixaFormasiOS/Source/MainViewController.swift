import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private var gameEngine: GameEngine!
    private var boardView: BoardView!
    private let cellSize: CGFloat = 40.0
    private var pieceViews: [PieceView] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        setupGame()
    }
    
    // MARK: - Setup
    
    private func setupGame() {
        // 1. Create Level Data (Level 1)
        let level = LevelGenerator.generateLevel1()
        gameEngine = GameEngine(level: level)
        
        // 2. Setup Board View
        boardView = BoardView(rows: level.boardRows, cols: level.boardCols, cellSize: cellSize)
        boardView.center = view.center
        view.addSubview(boardView)
        
        // Configure Board Cells
        for (pos, cell) in level.boardConfiguration {
            boardView.configureCell(at: pos.row, col: pos.col, with: cell)
        }
        
        // 3. Setup Pieces
        setupPieces(from: level)
    }
    
    private func setupPieces(from level: Level) {
        var startY = view.safeAreaInsets.top + 50
        let startX: CGFloat = 20
        
        for piece in level.pieces {
            let pieceView = PieceView(piece: piece, cellSize: cellSize)
            pieceView.frame.origin = CGPoint(x: startX, y: startY)
            pieceView.delegate = self
            view.addSubview(pieceView)
            pieceViews.append(pieceView)
            
            startY += pieceView.frame.height + 20
        }
    }
    

}

// MARK: - PieceViewDelegate

extension MainViewController: PieceViewDelegate {
    func pieceViewDidBeginDragging(_ pieceView: PieceView) {
        // Optional: Add visual feedback like scaling up
    }
    
    func pieceView(_ pieceView: PieceView, didDragTo point: CGPoint) {
        // Optional: Highlight valid drop zones
    }
    
    func pieceViewDidEndDragging(_ pieceView: PieceView) {
        // 1. Calculate drop position relative to board
        let pieceCenterInBoard = view.convert(pieceView.center, to: boardView)
        
        // 2. Find grid position
        // We need to adjust for the piece's internal offset (top-left vs center)
        // A simpler approach for grid snapping:
        // Get the top-left corner of the piece
        let pieceOriginInBoard = view.convert(pieceView.frame.origin, to: boardView)
        
        // Calculate the closest grid cell for the top-left of the piece
        // Note: This assumes the user drags the piece roughly to align the top-left. 
        // For better UX, we might want to snap based on the center or the "handle" being dragged.
        // Let's try snapping the top-left corner to the nearest cell.
        
        let col = Int(round(pieceOriginInBoard.x / cellSize))
        let row = Int(round(pieceOriginInBoard.y / cellSize))
        let targetPos = GridPosition(row: row, col: col)
        
        // 3. Validate Move
        if gameEngine.canPlace(piece: pieceView.piece, at: targetPos) {
            // 4. Place Piece
            _ = gameEngine.place(piece: pieceView.piece, at: targetPos)
            
            // 5. Snap View
            let snapPoint = boardView.convert(CGPoint(x: CGFloat(col) * cellSize, y: CGFloat(row) * cellSize), to: view)
            // Adjust because pieceView.frame.origin is what we want to set, but we set center in snapTo usually?
            // Let's just set the frame origin.
            UIView.animate(withDuration: 0.2) {
                pieceView.frame.origin = snapPoint
            }
            
            // 6. Check Win
            if gameEngine.checkWinCondition() {
                print("YOU WIN!")
                let alert = UIAlertController(title: "Parabéns!", message: "Você completou o nível!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        } else {
            // Invalid Move: Return
            pieceView.returnToOriginalPosition()
        }
    }
}
