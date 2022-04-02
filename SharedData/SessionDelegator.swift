//
//  SessionDelegator.swift
//  Form Identifier
//
//  Allows the iPhone and Apple Watch to access the same data.
//
//

import Combine
import WatchConnectivity

class SessionDelegator: NSObject, WCSessionDelegate {

    let resultsSubject: PassthroughSubject<[String], Never>
    let distributionSubject: PassthroughSubject<[[Double]], Never>
    let countSubject: PassthroughSubject<Int, Never>
    let motionTypesSubject: PassthroughSubject<[String], Never>
    let selectedModelSubject: PassthroughSubject<String, Never>
        
    init(resultsSubject: PassthroughSubject<[String], Never>,
         distributionSubject: PassthroughSubject<[[Double]], Never>,
         countSubject: PassthroughSubject<Int, Never>,
         motionTypesSubject: PassthroughSubject<[String], Never>,
         selectedModelSubject: PassthroughSubject<String, Never>) {

        self.resultsSubject = resultsSubject
        self.distributionSubject = distributionSubject
        self.countSubject = countSubject
        self.motionTypesSubject = motionTypesSubject
        self.selectedModelSubject = selectedModelSubject
        
        super.init()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            if let results = message["results"] as? [String] {
                self.resultsSubject.send(results)
            } else if let distribution = message["distribution"] as? [[Double]] {
                self.distributionSubject.send(distribution)
            } else if let count = message["count"] as? Int {
                self.countSubject.send(count)
            } else if let data = message["motionTypes"] as? [String] {
                self.motionTypesSubject.send(data)
            } else if let data = message["selectedModel"] as? String {
                self.selectedModelSubject.send(data)
            } else {
                print("Error")
                print(message)
            }
        }
    }
    
    // Needed for protocol conformance.
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) { }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // New session.
        session.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) { }
    #endif
}
