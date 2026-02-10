//
//  TimeContextManager.swift
//  ContextAware
//
//  Created by Noman belim on 10/02/26.
//

import SwiftUI
import Foundation

import Foundation

final class TimeContextManager {

    static func current() -> TimeContext {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 5..<12:
            return TimeContext(
                period: .morning,
                greeting: "Good Morning!",
                badge: formattedTime()
            )

        case 12..<17:
            return TimeContext(
                period: .afternoon,
                greeting: "Good Afternoon!",
                badge: formattedTime()
            )

        case 17..<21:
            return TimeContext(
                period: .evening,
                greeting: "Good Evening!",
                badge: formattedTime()
            )

        default:
            return TimeContext(
                period: .night,
                greeting: "Good Night!",
                badge: formattedTime()
            )
        }
    }

    private static func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}


enum DayPeriod {
    case morning
    case afternoon
    case evening
    case night
}

struct TimeContext {
    let period: DayPeriod
    let greeting: String
    let badge: String
}
#Preview {
//    TimeContextManager()
}
