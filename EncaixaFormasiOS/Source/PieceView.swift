import UIKit

protocol PieceViewDelegate: AnyObject {
    func pieceViewDidBeginDragging(_ pieceView: PieceView)
    func pieceView(_ pieceView: PieceView, didDragTo point: CGPoint)
    func pieceViewDidEndDragging(_ pieceView: PieceView)
}

class PieceView: UIView {
    
    // MARK: - Properties
    
    let piece: Piece
    weak var delegate: PieceViewDelegate?
    private var originalPosition: CGPoint = .zero
    private let cellSize: CGFloat
    
    // MARK: - Initialization
    
    init(piece: Piece, cellSize: CGFloat) {
        self.piece = piece
        self.cellSize = cellSize
        super.init(frame: .zero)
        
        setupView()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        let rows = piece.matrix.count
        let cols = piece.matrix[0].count
        
        self.frame.size = CGSize(width: CGFloat(cols) * cellSize, height: CGFloat(rows) * cellSize)
        
        for r in 0..<rows {
            for c in 0..<cols {
                let shapeType = piece.matrix[r][c]
                if shapeType != .none {
                    let blockView = UIView(frame: CGRect(x: CGFloat(c) * cellSize, y: CGFloat(r) * cellSize, width: cellSize, height: cellSize))
                    blockView.backgroundColor = piece.color.uiColor
                    blockView.layer.borderWidth = 1
                    blockView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
                    
                    // Add the "hole" representation
                    let holeLayer = CAShapeLayer()
                    let holePath: UIBezierPath
                    let holeRect = CGRect(x: cellSize * 0.25, y: cellSize * 0.25, width: cellSize * 0.5, height: cellSize * 0.5)
                    
                    if shapeType == .circle {
                        holePath = UIBezierPath(ovalIn: holeRect)
                    } else {
                        holePath = UIBezierPath(rect: holeRect)
                    }
                    
                    // Create a mask to cut out the hole
                    let maskPath = UIBezierPath(rect: blockView.bounds)
                    maskPath.append(holePath)
                    maskPath.usesEvenOddFillRule = true
                    
                    let maskLayer = CAShapeLayer()
                    maskLayer.path = maskPath.cgPath
                    maskLayer.fillRule = .evenOdd
                    blockView.layer.mask = maskLayer
                    
                    addSubview(blockView)
                }
            }
        }
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    // MARK: - Actions
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let superview = superview else { return }
        
        switch gesture.state {
        case .began:
            originalPosition = self.center
            superview.bringSubviewToFront(self)
            delegate?.pieceViewDidBeginDragging(self)
            
        case .changed:
            let translation = gesture.translation(in: superview)
            self.center = CGPoint(x: originalPosition.x + translation.x, y: originalPosition.y + translation.y)
            delegate?.pieceView(self, didDragTo: self.center)
            
        case .ended, .cancelled:
            delegate?.pieceViewDidEndDragging(self)
            
        default:
            break
        }
    }
    
    func returnToOriginalPosition() {
        UIView.animate(withDuration: 0.3) {
            self.center = self.originalPosition
        }
    }
    
    func snapTo(position: CGPoint) {
        self.center = position
        self.originalPosition = position // Update original position to the new valid spot
    }
}
