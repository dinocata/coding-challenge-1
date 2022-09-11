import Foundation
import CallKit

final class HomeVC: BaseVC<HomeVM> {
    
    override func setupView() {
        view.backgroundColor = Colors.background.color
    }
    
    override func bindInput() -> HomeVM.Input {
        .init()
    }
    
    override func bindOutput(_ output: HomeVM.Output) {
        // TODO
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            AppDelegate.shared.displayIncomingCall(uuid: UUID(), handle: "Test")
        }
    }
}
