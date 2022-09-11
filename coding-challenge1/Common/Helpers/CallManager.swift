import CallKit

protocol CallManager {
    var activeCalls: [Call] { get }
    
    func startCall(handle: String, video: Bool)
    func endCall(_ call: Call)
    func setOnHold(call: Call, to onHold: Bool)
    
    func getActiveCall(by uuid: UUID) -> Call?
    func addCall(_ call: Call)
    func removeCall(_ call: Call)
    func removeAllCalls()
}

final class CallManagerImpl: CallManager {

    /// Stored properties
    private(set) var activeCalls: [Call] = []
    
    /// Dependencies
    private let callController: CXCallController = .init()
    
    func startCall(handle: String, video: Bool) {
        let handle = CXHandle(type: .phoneNumber, value: handle)
        let startCallAction = CXStartCallAction(call: UUID(), handle: handle)

        startCallAction.isVideo = video

        let transaction = CXTransaction()
        transaction.addAction(startCallAction)

        requestTransaction(transaction)
    }
    
    func endCall(_ call: Call) {
        let endCallAction = CXEndCallAction(call: call.uuid)
        let transaction = CXTransaction()
        transaction.addAction(endCallAction)

        requestTransaction(transaction)
    }
    
    func setOnHold(call: Call, to onHold: Bool) {
        let setHeldCallAction = CXSetHeldCallAction(call: call.uuid, onHold: onHold)
        let transaction = CXTransaction()
        transaction.addAction(setHeldCallAction)

        requestTransaction(transaction)
    }
    
    private func requestTransaction(_ transaction: CXTransaction) {
        callController.request(transaction) { error in
            if let error = error {
                print("Error requesting transaction:", error.localizedDescription)
            } else {
                print("Requested transaction successfully")
            }
        }
    }
    
    func getActiveCall(by uuid: UUID) -> Call? {
        activeCalls.first { $0.uuid == uuid }
    }
    
    func addCall(_ call: Call) {
        activeCalls.append(call)
    }
    
    func removeCall(_ call: Call) {
        guard let index = activeCalls.firstIndex(where: { $0.uuid == call.uuid }) else { return }
        activeCalls.remove(at: index)
    }
    
    func removeAllCalls() {
        activeCalls.forEach { call in
            call.endCall()
        }
        
        activeCalls.removeAll()
    }
}
