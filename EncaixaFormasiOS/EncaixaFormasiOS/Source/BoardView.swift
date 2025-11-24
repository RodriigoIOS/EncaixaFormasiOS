import UIKit

class BoardView: UIView {
    
    // MARK: - Properties
    
    let rows: Int
    let cols: Int
    let cellSize: CGFloat
    private var cells: [[UIView]] = []
    
    // MARK: - Initialization
    
    init(rows: Int, cols: Int, cellSize: CGFloat) {
        self.rows = rows
        self.cols = cols
        self.cellSize = cellSize
        super.init(frame: .zero)
        
        setupGrid()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupGrid() {
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        
        for r in 0..<rows {
            var rowCells: [UIView] = []
            for c in 0..<cols {
                let cellView = UIView(frame: CGRect(x: CGFloat(c) * cellSize, y: CGFloat(r) * cellSize, width: cellSize, height: cellSize))
                cellView.layer.borderWidth = 0.5
                cellView.layer.borderColor = UIColor.lightGray.cgColor
                addSubview(cellView)
                rowCells.append(cellView)
            }
            cells.append(rowCells)
        }
        
        self.frame.size = CGSize(width: CGFloat(cols) * cellSize, height: CGFloat(rows) * cellSize)
    }
    
    func configureCell(at row: Int, col: Int, with cellData: BoardCell) {
        guard row < rows, col < cols else { return }
        let cellView = cells[row][col]
        
        // Clear previous sublayers
        cellView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        if cellData.shape != .none {
            let shapeLayer = CAShapeLayer()
            let shapeRect = CGRect(x: cellSize * 0.25, y: cellSize * 0.25, width: cellSize * 0.5, height: cellSize * 0.5)
            let path: UIBezierPath
            
            if cellData.shape == .circle {
                path = UIBezierPath(ovalIn: shapeRect)
            } else {
                path = UIBezierPath(rect: shapeRect)
            }
            
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = cellData.color?.uiColor.cgColor ?? UIColor.gray.cgColor
            cellView.layer.addSublayer(shapeLayer)
        }
    }
    
    func gridPosition(for point: CGPoint) -> GridPosition? {
        let col = Int(point.x / cellSize)
        let row = Int(point.y / cellSize)
        
        if col >= 0 && col < cols && row >= 0 && row < rows {
            return GridPosition(row: row, col: col)
        }
        return nil
    }
    
    func centerPoint(for position: GridPosition) -> CGPoint {
        let x = CGFloat(position.col) * cellSize + cellSize / 2
        let y = CGFloat(position.row) * cellSize + cellSize / 2
        return CGPoint(x: x, y: y)
    }
}
