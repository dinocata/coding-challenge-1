import UIKit

protocol Router: AnyObject {
    
    var currentViewController: UIViewController! { get set }
    var window: UIWindow? { get set }
    
    func navigate(to scene: Scene, completion: (() -> Void)?)
    func navigate(to viewController: UIViewController, transitionType: SceneTransition, completion: (() -> Void)?)
    func goBack(completion: (() -> Void)?)
    func dismiss(completion: (() -> Void)?)
    func popToRoot(completion: (() -> Void)?)
    
    func onboardingTransition(completion: (() -> Void)?)
}

final class RouterImpl: Router {
    
    var currentViewController: UIViewController!
    var window: UIWindow?
    
    func navigate(to scene: Scene, completion: (() -> Void)?) {
        navigate(to: scene.viewController, transitionType: scene.defaultTransition, completion: completion)
    }
    
    func navigate(to viewController: UIViewController, transitionType: SceneTransition, completion: (() -> Void)?) {
        switch transitionType {
        case .root(let animated):
            if animated && self.window?.rootViewController != nil {
                self.currentViewController = viewController.actualViewController
                self.window?.setRootViewController(viewController, completion: completion)
                return
            } else {
                self.currentViewController = viewController.actualViewController
                self.window?.rootViewController = viewController
                self.window?.makeKeyAndVisible()
                completion?()
                return
            }
            
        case .push(let animated):
            guard let navigationController = self.currentViewController.navigationController else {
                fatalError("Can't push from \(self.currentViewController!) to \(viewController) without a current navigation controller")
            }
            
            navigationController.pushViewController(viewController: viewController, animated: animated, completion: completion)
            
        case .present(let animated):
            self.currentViewController.present(viewController, animated: animated, completion: completion)
        }
        
        self.currentViewController = viewController.actualViewController
    }
    
    func goBack(completion: (() -> Void)?) {
        if let navigationController = self.currentViewController.navigationController,
           navigationController.viewControllers.count > 1 {
            
            let count = navigationController.viewControllers.count
            self.currentViewController = navigationController.viewControllers[count - 2]
            
            navigationController.popViewController(
                animated: true,
                completionHandler: completion
            )
        } else if let presenter = self.currentViewController.presentingViewController {
            self.currentViewController.dismiss(animated: true, completion: completion)
            self.currentViewController = presenter.actualViewController
        } else {
            fatalError("Cannot properly navigate back from \(self.currentViewController!). No presenting view controller.")
        }
    }
    
    func dismiss(completion: (() -> Void)?) {
        if let navigationController = self.currentViewController.navigationController,
           let presenter = navigationController.presentingViewController {
            
            navigationController.dismiss(animated: true, completion: completion)
            
            self.currentViewController = presenter.actualViewController
        } else if let presenter = self.currentViewController.presentingViewController {
            self.currentViewController.dismiss(animated: true, completion: completion)
            self.currentViewController = presenter.actualViewController
        } else {
            fatalError("Cannot properly dismiss navigation from \(self.currentViewController!). No presenting view controller.")
        }
    }
    
    func popToRoot(completion: (() -> Void)?) {
        if let navigationController = self.currentViewController.navigationController,
           navigationController.viewControllers.count > 1 {
            navigationController.popToRootViewController(animated: true, completion: completion)
            self.currentViewController = navigationController.viewControllers.first?.actualViewController
        } else {
            fatalError("No navigation controller.")
        }
    }
    
    func onboardingTransition(completion: (() -> Void)?) {
        navigate(to: .home, completion: completion)
    }
}
