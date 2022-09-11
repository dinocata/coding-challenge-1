import Foundation

final class Call {
    let uuid: UUID
    let handle: String?
    
    var isOnHold: Bool = false
    var isMuted: Bool = false
    
    private(set) var startDate: Date?
    private(set) var endDate: Date?
    
    init(uuid: UUID, handle: String?) {
        self.uuid = uuid
        self.handle = handle
    }
    
    var isActive: Bool {
        startDate != nil && endDate == nil
    }
    
    var hasEnded: Bool {
        endDate != nil
    }
    
    func startCall() {
        startDate = Date()
    }
    
    func endCall() {
        endDate = Date()
    }
}
