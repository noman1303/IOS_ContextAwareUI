//
//  ContentView.swift
//  ContextAware
//
//  Created by Noman belim on 10/02/26.
//

import SwiftUI

import SwiftUI

struct ContentView: View {

    // MARK: - Context Sources
    @State private var timeContext = TimeContextManager.current()
    @StateObject private var batteryManager = BatteryContextManager()
    @StateObject private var networkManager = NetworkContextManager()
    @StateObject private var motionManager = MotionContextManager()

    @Environment(\.accessibilityReduceMotion)
    private var systemReduceMotion

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                HeaderView(
                    greeting: timeContext.greeting,
                    isNight: isNight
                )

                VStack(spacing: 50) {

                    ContextCard(
                        icon: "clock.fill",
                        title: "Time of Day",
                        subtitle: timeContext.greeting,
                        badge: timeContext.badge,
                        color: .blue,
                        reduceMotion: shouldReduceAnimations
                    )

                    ContextCard(
                        icon: "battery.100",
                        title: "Battery Level",
                        subtitle: batterySubtitle,
                        badge: "\(batteryManager.level)%",
                        color: batteryColor,
                        reduceMotion: shouldReduceAnimations
                    )

                    ContextCard(
                        icon: networkIcon,
                        title: "Network",
                        subtitle: networkSubtitle,
                        badge: networkBadge,
                        color: networkColor,
                        reduceMotion: shouldReduceAnimations
                    )

                    ContextCard(
                        icon: motionIcon,
                        title: "Motion",
                        subtitle: motionSubtitle,
                        badge: motionBadge,
                        color: motionColor,
                        reduceMotion: shouldReduceAnimations
                    )
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
        .background(
            isNight
            ? Color.black.opacity(0.95)
            : Color(.systemGroupedBackground)
        )
        .onReceive(
            Timer.publish(every: 60, on: .main, in: .common).autoconnect()
        ) { _ in
            timeContext = TimeContextManager.current()
        }
    }
}

// MARK: - Global Flags
extension ContentView {

    private var shouldReduceAnimations: Bool {
        batteryManager.isLowPower || systemReduceMotion
    }

    private var isNight: Bool {
        timeContext.period == DayPeriod.night
    }
}

// MARK: - Battery Helpers
extension ContentView {

    private var batteryColor: Color {
        switch batteryManager.level {
        case 70...100: return .green
        case 30..<70:  return .yellow
        default:       return .red
        }
    }

    private var batterySubtitle: String {
        batteryManager.isLowPower
        ? "Low battery — reducing activity"
        : "All activities enabled"
    }
}

// MARK: - Network Helpers
extension ContentView {

    private var networkIcon: String {
        switch networkManager.connectionType {
        case .wifi:
            return "wifi"
        case .cellular:
            return "antenna.radiowaves.left.and.right"
        case .offline:
            return "wifi.slash"
        }
    }

    private var networkBadge: String {
        switch networkManager.connectionType {
        case .wifi:
            return "Wi-Fi"
        case .cellular:
            return "Cellular"
        case .offline:
            return "Offline"
        }
    }

    private var networkSubtitle: String {
        networkManager.isConnected
        ? "Connected"
        : "No internet connection"
    }

    private var networkColor: Color {
        networkManager.isConnected ? .purple : .red
    }
}

// MARK: - Motion Helpers
extension ContentView {

    private var motionIcon: String {
        switch motionManager.activity {
        case .stationary:
            return "figure.stand"
        case .walking:
            return "figure.walk"
        case .driving:
            return "car.fill"
        }
    }

    private var motionBadge: String {
        switch motionManager.activity {
        case .stationary:
            return "Still"
        case .walking:
            return "Walking"
        case .driving:
            return "Driving"
        }
    }

    private var motionSubtitle: String {
        switch motionManager.activity {
        case .stationary:
            return "You are not moving"
        case .walking:
            return "You are walking"
        case .driving:
            return "You are in a vehicle"
        }
    }

    private var motionColor: Color {
        switch motionManager.activity {
        case .stationary:
            return .gray
        case .walking:
            return .orange
        case .driving:
            return .blue
        }
    }
}

// MARK: - Header View
struct HeaderView: View {

    let greeting: String
    let isNight: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(isNight ? Color.indigo : Color.blue)
                .frame(height: 160)

            HStack(spacing: 16) {
                Text(isNight ? "🌙" : "☀️")
                    .font(.system(size: 40))

                Text(greeting)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
