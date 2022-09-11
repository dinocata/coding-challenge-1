import Swinject

enum SingletonContainer {
    
    static let shared: Container = {
        let container = Container(defaultObjectScope: .container)
        
        container.register(Router.self) { _ in
            RouterImpl()
        }
        
        container.register(CallManager.self) { _ in
            CallManagerImpl()
        }
        
        container.register(ProviderDelegate.self) {
            ProviderDelegateImpl(callManager: $0.resolve())
        }
        
        return container
    }()
}
