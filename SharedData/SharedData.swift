//
//  SharedData.swift
//  Form Identifier
//
//  Allows the iPhone and Apple Watch to access the same data.
//
//

import Combine
import WatchConnectivity

final class SharedData: ObservableObject {

    var session: WCSession
    let delegate: WCSessionDelegate
    let resultsSubject = PassthroughSubject<[String], Never>()
    let distributionSubject = PassthroughSubject<[[Double]], Never>()
    let countSubject = PassthroughSubject<Int, Never>()
    let motionTypesSubject = PassthroughSubject<[String], Never>()
    let selectedModelSubject = PassthroughSubject<String, Never>()

    @Published private(set) var results: [String] = []
    @Published private(set) var distribution: [[Double]] = []
    @Published private(set) var count: Int = 0
    @Published private(set) var motionTypes: [String] = []
    @Published private(set) var selectedModel: String = ""

    init(session: WCSession = .default) {
        self.delegate = SessionDelegator(resultsSubject: resultsSubject,
                                         distributionSubject: distributionSubject,
                                         countSubject: countSubject,
                                         motionTypesSubject: motionTypesSubject,
                                         selectedModelSubject: selectedModelSubject)
        self.session = session
        self.session.delegate = self.delegate
        self.session.activate()
        
        resultsSubject
            .receive(on: DispatchQueue.main)
            .assign(to: &$results)
        distributionSubject
            .receive(on: DispatchQueue.main)
            .assign(to: &$distribution)
        countSubject
            .receive(on: DispatchQueue.main)
            .assign(to: &$count)
        motionTypesSubject
            .receive(on: DispatchQueue.main)
            .assign(to: &$motionTypes)
        selectedModelSubject
            .receive(on: DispatchQueue.main)
            .assign(to: &$selectedModel)
    }

    // Update data from the Apple Watch.
    func update(newValue: [String], newValue2: [[Double]], newValue3: Int, newValue4: [String]) {
        session.sendMessage(["results": newValue], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
        session.sendMessage(["distribution": newValue2], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
        session.sendMessage(["count": newValue3], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
        session.sendMessage(["motionTypes": newValue4], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }

    // Update data from the iPhone.
    func changeModel(newValue: String) {
        session.sendMessage(["selectedModel": newValue], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
}
