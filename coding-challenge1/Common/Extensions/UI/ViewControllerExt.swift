import UIKit

extension UIViewController {
    
    var actualViewController: UIViewController {
        let currentViewController: UIViewController = {
            if let tabBarController = self as? UITabBarController {
                return tabBarController.selectedViewController ?? self
            }
            return self
        }()
        
        if let navigationController = currentViewController as? UINavigationController {
            return navigationController.viewControllers.last ?? self
        } else {
            return self
        }
    }
}

extension UINavigationController {
    func pushViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        pushViewController(viewController, animated: animated)
        handleCompletion(animated: animated, completion: completion)
    }
    
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool, completion: (() -> Void)?) {
        setViewControllers(viewControllers, animated: animated)
        handleCompletion(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool, completionHandler: (() -> Void)?) {
        guard popViewController(animated: animated) != nil else {
            completionHandler?()
            return
        }
        handleCompletion(animated: animated, completion: completionHandler)
    }
    
    func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        guard popToRootViewController(animated: animated) != nil else {
            completion?()
            return
        }
        handleCompletion(animated: animated, completion: completion)
    }
    
    func popToViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard popToViewController(viewController, animated: animated) != nil else {
            completion?()
            return
        }
        handleCompletion(animated: animated, completion: completion)
    }
    
    func popToViewController(ofClass vcClass: AnyClass, animated: Bool = true, completion: (() -> Void)?) -> UIViewController? {
        if let vc = viewControllers.last(where: { $0.isKind(of: vcClass) }) {
            popToViewController(viewController: vc, animated: animated, completion: completion)
            return vc
        } else {
            return nil
        }
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true, completion: (() -> Void)?) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(viewController: vc, animated: animated, completion: completion)
        }
    }
    
    func handleCompletion(animated: Bool, completion: (() -> Void)?) {
        if let completion = completion {
            if let coordinator = transitionCoordinator, animated {
                coordinator.animate(alongsideTransition: nil) { _ in
                    completion()
                }
            } else {
                completion()
            }
        }
    }
}
