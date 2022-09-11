import RxSwift

extension Reactive where Base == Router {
    
    func navigate(to scene: Scene) -> RxSwift.Completable {
        navigate(to: scene.viewController, transitionType: scene.defaultTransition)
    }
    
    func navigate(to viewController: UIViewController, transitionType: SceneTransition) -> Completable {
        .create { [weak base] observer in
            
            guard let base = base else { return Disposables.create() }
            
            base.navigate(to: viewController, transitionType: transitionType) {
                observer(.completed)
            }
            
            return Disposables.create()
        }
    }
    
    func goBack() -> RxSwift.Completable {
        .create { [weak base] observer in
            
            guard let base = base else { return Disposables.create() }
            
            base.goBack {
                observer(.completed)
            }
            
            return Disposables.create()
        }
    }
    
    func dismiss() -> RxSwift.Completable {
        .create { [weak base] observer in
            
            guard let base = base else { return Disposables.create() }
            
            base.dismiss {
                observer(.completed)
            }
            
            return Disposables.create()
        }
    }
    
    func popToRoot() -> RxSwift.Completable {
        .create { [weak base] observer in
            
            guard let base = base else { return Disposables.create() }
            
            base.popToRoot {
                observer(.completed)
            }
            
            return Disposables.create()
        }
    }
    
    func onboardingTransition() -> RxSwift.Completable {
        .create { [weak base] observer in
            
            guard let base = base else { return Disposables.create() }
            
            base.onboardingTransition {
                observer(.completed)
            }
            
            return Disposables.create()
        }
    }
}
