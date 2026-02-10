//
//  NetworkContextManager.swift
//  ContextAware
//
//  Created by Noman belim on 10/02/26.
//

import SwiftUI
import Foundation
import Network

final class NetworkContextManager: ObservableObject {
    @Published var isConnected: Bool = true
    @Published var connectionType: ConnectionType = .wifi
    private let monitor = NWPathMonitor()
       private let queue = DispatchQueue(label: "NetworkMonitor")

     
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied

                if path.usesInterfaceType(.wifi) {
                    self?.connectionType = .wifi
                } else if path.usesInterfaceType(.cellular) {
                    self?.connectionType = .cellular
                } else {
                    self?.connectionType = .offline
                }
            }
        }
        monitor.start(queue: queue)
    }
}

enum ConnectionType {
    case wifi
    case cellular
    case offline
}
