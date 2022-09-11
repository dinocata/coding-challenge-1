import AVFoundation
import CallKit

protocol ProviderDelegate: CXProviderDelegate {
    func reportIncomingCall(uuid: UUID, handle: String, hasVideo: Bool, completion: ((Error?) -> Void)?)
}

final class ProviderDelegateImpl: NSObject {
    
    private static let providerConfiguration: CXProviderConfiguration = {
        let providerConfiguration: CXProviderConfiguration = {
            if #available(iOS 14.0, *) {
                return .init()
            } else {
                return .init(localizedName: "CodingChallenge")
            }
        }()
        
        providerConfiguration.supportsVideo = true
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        
        return providerConfiguration
    }()
    
    private let callManager: CallManager
    private let provider: CXProvider
    
    init(callManager: CallManager) {
        self.callManager = callManager
        self.provider = CXProvider(configuration: Self.providerConfiguration)
        
        super.init()
        
        provider.setDelegate(self, queue: nil)
    }
}

extension ProviderDelegateImpl: ProviderDelegate {
    
    func reportIncomingCall(uuid: UUID, handle: String, hasVideo: Bool, completion: ((Error?) -> Void)?) {
        // Construct a CXCallUpdate describing the incoming call, including the caller.
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        update.hasVideo = hasVideo
        
        // Report the incoming call to the system
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            /*
             Only add an incoming call to an app's list of calls if it's allowed, i.e., there is no error.
             Calls may be denied for various legitimate reasons. See CXErrorCodeIncomingCallError.
             */
            if error == nil {
                let call = Call(uuid: uuid, handle: handle)
                self.callManager.addCall(call)
            }
            
            completion?(error)
        }
    }
    
    func providerDidReset(_ provider: CXProvider) {
        callManager.removeAllCalls()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard let call = callManager.getActiveCall(by: action.callUUID) else {
            action.fail()
            return
        }
        
        call.startCall()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        guard let call = callManager.getActiveCall(by: action.callUUID) else {
            action.fail()
            return
        }
        
        call.endCall()
        action.fulfill()
        
        callManager.removeCall(call)
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        guard let call = callManager.getActiveCall(by: action.callUUID) else {
            action.fail()
            return
        }
        
        call.isOnHold = action.isOnHold
        
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        guard let call = callManager.getActiveCall(by: action.callUUID) else {
            action.fail()
            return
        }

        call.isMuted = action.isMuted

        action.fulfill()
    }
}
