//
//  MotionContextManager.swift
//  ContextAware
//
//  Created by Noman belim on 10/02/26.
//

import Foundation
import CoreMotion
import Combine

final class MotionContextManager: ObservableObject {

    @Published var activity: MotionActivity = .stationary

    private let activityManager = CMMotionActivityManager()

    init() {
        startMonitoring()
    }

    private func startMonitoring() {
        guard CMMotionActivityManager.isActivityAvailable() else { return }

        activityManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let activity = activity else { return }

            if activity.automotive {
                self?.activity = .driving
            } else if activity.walking || activity.running {
                self?.activity = .walking
            } else {
                self?.activity = .stationary
            }
        }
    }
}

enum MotionActivity {
    case stationary
    case walking
    case driving
}
