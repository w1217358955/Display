import Foundation
import QuartzCore

public struct UIEdgeInsets: Equatable {
    public var top: CGFloat
    public var left: CGFloat
    public var bottom: CGFloat
    public var right: CGFloat
    
    public init() {
        self.top = 0.0
        self.left = 0.0
        self.bottom = 0.0
        self.right = 0.0
    }
    
    public init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
}

public final class UIColor: NSObject {
    let cgColor: CGColor
    
    init(rgb: Int32) {
        preconditionFailure()
    }
    
    init(cgColor: CGColor) {
        self.cgColor = cgColor
    }
}

open class CASeeThroughTracingLayer: CALayer {
    
}

open class CASeeThroughTracingView: UIView {
    
}

func makeSpringAnimation(_ keyPath: String) -> CABasicAnimation {
    return CABasicAnimation(keyPath: keyPath)
}

func makeSpringBounceAnimation(_ keyPath: String, _ initialVelocity: CGFloat, _ damping: CGFloat) -> CABasicAnimation {
    return CABasicAnimation(keyPath: keyPath)
}

func springAnimationValueAt(_ animation: CABasicAnimation, _ t: CGFloat) -> CGFloat {
    return t
}
