# 📱 ContextAware UI

<div align="center">

![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

**A self-adapting iOS application that automatically adjusts its UI based on real-time device and system context**

[Features](#-features) • [Architecture](#-architecture) • [Installation](#-installation) • [Usage](#-usage) • [Documentation](#-documentation)

</div>

---

## 📖 Overview

ContextAware is a production-ready SwiftUI application demonstrating advanced iOS development techniques. The app intelligently adapts its user interface in real-time based on multiple device contexts without requiring any user intervention.

### Monitored Contexts

- **🕒 Time of Day** - Dynamic greetings and theme changes
- **🔋 Battery Level** - Performance optimization and power management
- **📡 Network Connectivity** - Connection-aware content delivery
- **🚶 Device Motion** - Activity-based UI adjustments
- **♿️ Accessibility** - Reduced motion and enhanced usability

---

## ✨ Features

### 🎯 Core Capabilities

- **Real-time Context Detection** - Monitors multiple system states simultaneously
- **Automatic UI Adaptation** - No manual refresh required
- **Battery Optimization** - Reduces animations and effects when battery is low
- **Network Awareness** - Adjusts content quality based on connection type
- **Motion Detection** - Recognizes stationary, walking, and driving states
- **Accessibility Support** - Respects system-wide reduce motion settings
- **Dark Mode Support** - Automatic night theme activation

### 🏗️ Technical Highlights

- Built with **SwiftUI** and **Combine**
- **MVVM Architecture** with ObservableObject pattern
- Reactive state management using `@Published` properties
- Modern iOS frameworks: CoreMotion, Network, UIKit integration
- Clean, testable, and maintainable code structure

---

## 🏛️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      System APIs                             │
│  (UIDevice, Calendar, NWPathMonitor, CMMotionActivityManager)│
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│               Context Managers (ObservableObject)            │
│  • TimeContextManager                                        │
│  • BatteryContextManager                                     │
│  • NetworkContextManager                                     │
│  • MotionContextManager                                      │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼ @Published State (Combine)
┌─────────────────────────────────────────────────────────────┐
│                    SwiftUI Views                             │
│              (Automatic Re-rendering)                        │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

```swift
System Change → Context Manager → @Published Update → SwiftUI Re-render
```

**Benefits:**
- No manual state synchronization
- Declarative UI updates
- Single source of truth
- Type-safe state management

---

## 📂 Project Structure

```
ContextAware/
│
├── App/
│   └── ContextAwareApp.swift          # App entry point
│
├── Views/
│   ├── ContentView.swift              # Main dashboard
│   └── Components/
│       └── ContextCard.swift          # Reusable card component
│
├── Managers/
│   ├── TimeContextManager.swift       # Time detection
│   ├── BatteryContextManager.swift    # Battery monitoring
│   ├── NetworkContextManager.swift    # Network tracking
│   └── MotionContextManager.swift     # Motion detection
│
└── Models/
    ├── TimeContext.swift              # Time-related models
    ├── BatteryContext.swift           # Battery models
    ├── NetworkContext.swift           # Network models
    └── MotionContext.swift            # Motion models
```

---

## 💻 Installation

### Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.9+

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ContextAware.git
   cd ContextAware
   ```

2. **Open in Xcode**
   ```bash
   open ContextAware.xcodeproj
   ```

3. **Configure Capabilities**
   - Go to **Signing & Capabilities**
   - Add your Development Team
   - Enable **Motion & Fitness** capability (for motion detection)

4. **Update Info.plist**
   Add motion usage description:
   ```xml
   <key>NSMotionUsageDescription</key>
   <string>We use motion data to optimize the UI based on your activity</string>
   ```

5. **Build and Run**
   - Select a simulator or physical device
   - Press `Cmd + R` to build and run

---

## 🎯 Usage

### Quick Start

The app automatically starts monitoring contexts on launch. No configuration needed.

### Testing Different States

#### Simulate Battery Changes
```swift
// In Xcode Simulator
Debug → Internal Settings → Battery Level → Set to 20%
```

#### Simulate Network Changes
```swift
// Toggle Wi-Fi in Control Center
// Or use Network Link Conditioner
```

#### Simulate Motion (Requires Physical Device)
```swift
// Walk with the device to see motion detection
// Motion detection not available in simulator
```

#### Change Time of Day (for testing)
```swift
// Temporarily modify TimeContextManager for testing
let hour = 22 // Simulates night time
```

---

## 📚 Documentation

### 🕒 Time Context

**Purpose:** Automatically change greetings and UI theme based on time of day

**Implementation:**
```swift
enum DayPeriod {
    case morning   // 5 AM - 12 PM
    case afternoon // 12 PM - 5 PM
    case evening   // 5 PM - 9 PM
    case night     // 9 PM - 5 AM
}

struct TimeContext {
    let period: DayPeriod
    let greeting: String
    let badge: String
}
```

**Why This Approach?**
- ✅ Stateless and predictable
- ✅ Easy to test
- ✅ Compiler-safe with enums
- ✅ No timers or background tasks needed

**Key Code:**
```swift
final class TimeContextManager {
    static func current() -> TimeContext {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return TimeContext(period: .morning,
                             greeting: "Good Morning!",
                             badge: formattedTime())
        case 12..<17:
            return TimeContext(period: .afternoon,
                             greeting: "Good Afternoon!",
                             badge: formattedTime())
        case 17..<21:
            return TimeContext(period: .evening,
                             greeting: "Good Evening!",
                             badge: formattedTime())
        default:
            return TimeContext(period: .night,
                             greeting: "Good Night!",
                             badge: formattedTime())
        }
    }
}
```

---

### 🔋 Battery Context

**Purpose:** Optimize performance and reduce power consumption when battery is low

**Implementation:**
```swift
final class BatteryContextManager: ObservableObject {
    @Published var level: Int = 100
    @Published var isLowPower: Bool = false
    
    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        update()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(update),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func update() {
        let value = UIDevice.current.batteryLevel
        level = value < 0 ? 100 : Int(value * 100)
        isLowPower = level <= 20
    }
}
```

**Why UIDevice API?**
- ✅ Apple-recommended approach
- ✅ No permissions required
- ✅ Lightweight and efficient
- ✅ Real-time updates via NotificationCenter

**UI Optimization:**
```swift
private var shouldReduceAnimations: Bool {
    batteryManager.isLowPower || systemReduceMotion
}

// Apply conditional animations
.animation(shouldReduceAnimations ? nil : .easeInOut(duration: 0.3))
```

---

### 📡 Network Context

**Purpose:** Adjust content delivery based on connection quality

**Implementation:**
```swift
import Network

enum ConnectionType {
    case wifi
    case cellular
    case offline
}

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
```

**Why NWPathMonitor?**
- ✅ Modern replacement for deprecated Reachability
- ✅ More accurate connection state detection
- ✅ Efficient and battery-friendly
- ✅ No special permissions required

**Use Cases:**
- Adjust image quality (HD on Wi-Fi, compressed on cellular)
- Enable/disable auto-refresh
- Show offline indicators

---

### 🚶 Motion Context

**Purpose:** Detect user activity for context-aware UI adjustments

**Implementation:**
```swift
import CoreMotion

enum MotionActivity {
    case stationary
    case walking
    case driving
}

final class MotionContextManager: ObservableObject {
    @Published var activity: MotionActivity = .stationary
    private let manager = CMMotionActivityManager()
    
    init() {
        guard CMMotionActivityManager.isActivityAvailable() else { return }
        
        manager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let activity else { return }
            
            if activity.automotive {
                self?.activity = .driving
            } else if activity.walking || activity.running {
                self?.activity = .walking
            } else {
                self?.activity = .stationary
            }
        }
    }
    
    deinit {
        manager.stopActivityUpdates()
    }
}
```

**Why CoreMotion?**
- ✅ System-level activity classification
- ✅ Battery-efficient (uses M-series coprocessor)
- ✅ High accuracy motion detection
- ✅ Built-in activity types

**⚠️ Important:** Requires Motion & Fitness permission and Info.plist entry

**Use Cases:**
- Larger tap targets when walking
- Safety warnings when driving
- Pause updates during high motion

---

### 🎨 Reusable Components

#### ContextCard

A reusable card component that adapts to different contexts:

```swift
struct ContextCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let badge: String
    let color: Color
    let reduceMotion: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .animation(
                    reduceMotion ? nil : .easeInOut(duration: 0.3),
                    value: color
                )
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Rectangle()
                        .fill(color)
                        .frame(width: 4)
                    
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 26))
                    
                    Spacer()
                }
                
                Text(title)
                    .font(.headline)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            
            Text(badge)
                .font(.caption.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(12)
        }
        .frame(height: 110)
    }
}
```

**Features:**
- Respects reduce motion accessibility setting
- Smooth color transitions
- Customizable icon, text, and badge
- Consistent spacing and styling

---

## 🌙 Automatic Night Mode

The app automatically switches to dark theme at night:

```swift
private var isNight: Bool {
    timeContext.period == .night
}

.background(
    isNight ? Color.black.opacity(0.95) 
            : Color(.systemGroupedBackground)
)
```

**Benefits:**
- Reduces eye strain in low light
- Saves battery on OLED displays
- Follows Apple Human Interface Guidelines

---

## 🧪 Testing

### Unit Tests

```swift
import XCTest
@testable import ContextAware

class TimeContextTests: XCTestCase {
    func testMorningPeriod() {
        // Test time-based logic
        let context = TimeContextManager.current()
        XCTAssertEqual(context.greeting, "Good Morning!")
    }
}
```

### UI Tests

```swift
import XCTest

class ContextAwareUITests: XCTestCase {
    func testContextCardsDisplay() {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.staticTexts["Good Morning!"].exists)
    }
}
```

---
 
