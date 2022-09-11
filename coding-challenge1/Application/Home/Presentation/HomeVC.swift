final class HomeVC: BaseVC<HomeVM> {
    
    override func setupView() {
        view.backgroundColor = Colors.background.color
    }
    
    override func bindInput() -> HomeVM.Input {
        .init()
    }
    
    override func bindOutput(_ output: HomeVM.Output) {
        // TODO
    }
}
