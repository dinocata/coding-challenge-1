import UIKit

class BaseVC<ViewModel: ViewModelType>: UIViewController {

    private let viewModel: ViewModel
    let router: Router
    
    init(viewModel: ViewModel, router: Router) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindOutput(viewModel.transform(bindInput()))
    }
    
    func setupView() {
        // Override in subclass
    }
    
    func bindInput() -> ViewModel.Input {
        fatalError("bindInput() must be overriden in subclass")
    }
    
    func bindOutput(_ output: ViewModel.Output) {
        fatalError("bindOutput() must be overriden in subclass")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.router.currentViewController = self
    }
}
