import Swinject

enum ViewControllerContainer {
    
    static let shared: Container = {
        let container = Container(parent: InstanceContainer.shared)
        
        container.register(HomeVC.self) {
            HomeVC(viewModel: $0.resolve(),
                   router: $0.resolve())
        }
        
        return container
    }()
}
