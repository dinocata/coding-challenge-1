import Swinject

enum SingletonContainer {
    
    static let shared: Container = {
        let container = Container(defaultObjectScope: .container)
        
        container.register(Router.self) { _ in
            RouterImpl()
        }
        
        return container
    }()
}
