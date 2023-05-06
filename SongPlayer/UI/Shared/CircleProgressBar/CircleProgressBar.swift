import Foundation
import UIKit

// https://cemkazim.medium.com/how-to-create-animated-circular-progress-bar-in-swift-f86c4d22f74b
class CircleProgressBar: UIView {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    private func sharedInit() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2

        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)

        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeColor = backgroundBarColor.cgColor
        backgroundLayer.lineWidth = backgroundBarLineWidth
        backgroundLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(backgroundLayer)

        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = progressBarColor.cgColor
        progressLayer.lineWidth = progressBarLineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = progress
        layer.addSublayer(progressLayer)
    }

    //----------------------------------------
    // MARK: - Lifecycle
    //----------------------------------------

    override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2

        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)

        backgroundLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var progress: CGFloat = 0 {
        didSet {
            progressLayer.strokeEnd = progress
        }
    }

    var progressBarColor: UIColor = UIColor(hexString: "#D0021B") {
        didSet {
            progressLayer.strokeColor = progressBarColor.cgColor
        }
    }

    var backgroundBarColor: UIColor = .white {
        didSet {
            backgroundLayer.strokeColor = backgroundBarColor.cgColor
        }
    }

    var progressBarLineWidth: CGFloat = 2 {
        didSet {
            progressLayer.lineWidth = progressBarLineWidth
            setNeedsDisplay()
        }
    }

    var backgroundBarLineWidth: CGFloat = 2 {
        didSet {
            backgroundLayer.lineWidth = backgroundBarLineWidth
            setNeedsDisplay()
        }
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let progressLayer = CAShapeLayer()

    private let backgroundLayer = CAShapeLayer()
}



