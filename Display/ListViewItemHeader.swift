import Foundation
import AsyncDisplayKit

public enum ListViewItemHeaderStickDirection {
    case top
    case bottom
}

public protocol ListViewItemHeader: class {
    var id: Int64 { get }
    var stickDirection: ListViewItemHeaderStickDirection { get }
    var height: CGFloat { get }
    
    func node() -> ListViewItemHeaderNode
}

open class ListViewItemHeaderNode: ASDisplayNode {
    private final var spring: ListViewItemSpring?
    let wantsScrollDynamics: Bool
    let isRotated: Bool
    final private(set) var internalStickLocationDistanceFactor: CGFloat = 0.0
    final var internalStickLocationDistance: CGFloat = 0.0
    private var isFlashingOnScrolling = false
    
    func updateInternalStickLocationDistanceFactor(_ factor: CGFloat, animated: Bool) {
        self.internalStickLocationDistanceFactor = factor
    }
    
    final func updateFlashingOnScrollingInternal(_ isFlashingOnScrolling: Bool, animated: Bool) {
        if self.isFlashingOnScrolling != isFlashingOnScrolling {
            self.isFlashingOnScrolling = isFlashingOnScrolling
            self.updateFlashingOnScrolling(isFlashingOnScrolling, animated: animated)
        }
        /*if self.isFlashing {
            if self.alpha.isZero {
                self.alpha = 1.0
                if animated {
                    self.layer.animateAlpha(from: 0.0, to: 1.0, duration: 0.3)
                }
            }
        } else {
            if !self.alpha.isZero {
                self.alpha = 0.0
                if animated {
                    self.layer.animateAlpha(from: 1.0, to: 0.0, duration: 0.3)
                }
            }
        }*/
    }
    
    open func updateFlashingOnScrolling(_ isFlashingOnScrolling: Bool, animated: Bool) {
    }
    
    public init(dynamicBounce: Bool = false, isRotated: Bool = false) {
        self.wantsScrollDynamics = dynamicBounce
        self.isRotated = isRotated
        if dynamicBounce {
            self.spring = ListViewItemSpring(stiffness: -280.0, damping: -24.0, mass: 0.85)
        }
        
        super.init()
    }
    
    open func updateStickDistanceFactor(_ factor: CGFloat, transition: ContainedViewLayoutTransition) {
    }
    
    final func addScrollingOffset(_ scrollingOffset: CGFloat) {
        if self.spring != nil && internalStickLocationDistanceFactor.isZero {
            let bounds = self.bounds
            self.bounds = CGRect(origin: CGPoint(x: 0.0, y: bounds.origin.y + scrollingOffset), size: bounds.size)
        }
    }
    
    public func animate(_ timestamp: Double) -> Bool {
        var continueAnimations = false
        
        if let _ = self.spring {
            let bounds = self.bounds
            var offset = bounds.origin.y
            let currentOffset = offset
            
            let frictionConstant: CGFloat = testSpringFriction
            let springConstant: CGFloat = testSpringConstant
            let time: CGFloat = 1.0 / 60.0
            
            // friction force = velocity * friction constant
            let frictionForce = self.spring!.velocity * frictionConstant
            // spring force = (target point - current position) * spring constant
            let springForce = -currentOffset * springConstant
            // force = spring force - friction force
            let force = springForce - frictionForce
            
            // velocity = current velocity + force * time / mass
            self.spring!.velocity = self.spring!.velocity + force * time
            // position = current position + velocity * time
            offset = currentOffset + self.spring!.velocity * time
            
            offset = offset.isNaN ? 0.0 : offset
            
            let epsilon: CGFloat = 0.1
            if abs(offset) < epsilon && abs(self.spring!.velocity) < epsilon {
                offset = 0.0
                self.spring!.velocity = 0.0
            } else {
                continueAnimations = true
            }
            
            if abs(offset) > 250.0 {
                offset = offset < 0.0 ? -250.0 : 250.0
            }
            
            self.bounds = CGRect(origin: CGPoint(x: 0.0, y: offset), size: bounds.size)
        }
        
        return continueAnimations
    }
}