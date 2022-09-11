import Swinject

extension Resolver {
    
    func resolve<Service>() -> Service {
        guard let instance = self.resolve(Service.self) else {
            fatalError("Could not resolve instance of type: \(Service.self)")
        }
        return instance
    }
}
