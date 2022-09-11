import Swinject

enum InstanceContainer {
    
    static let shared: Container = {
        let container = Container(parent: SingletonContainer.shared)
        
        container.register(HomeVM.self) { _ in
            HomeVM()
        }
        
        return container
    }()
}
