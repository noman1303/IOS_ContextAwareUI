//
//  BatteryContextManager.swift
//  ContextAware
//
//  Created by Noman belim on 10/02/26.
//

import UIKit
import Combine

final class BatteryContextManager: ObservableObject {

    @Published var level: Int = 100
    @Published var isLowPower: Bool = false

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        updateBatteryInfo()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBatteryInfo),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )
    }

    @objc private func updateBatteryInfo() {
        let batteryLevel = UIDevice.current.batteryLevel
        level = batteryLevel < 0 ? 100 : Int(batteryLevel * 100)
        isLowPower = level <= 20
    }
}
 
