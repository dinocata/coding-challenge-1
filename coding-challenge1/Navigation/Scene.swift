import UIKit

enum Scene {
    case home
}

extension Scene {
    
    var viewController: UIViewController {
        let container = ViewControllerContainer.shared
        
        switch self {
        case .home: return container.resolve(HomeVC.self)!
        }
    }
    
    var defaultTransition: SceneTransition {
        switch self {
        case .home: return .root()
        }
    }
}
