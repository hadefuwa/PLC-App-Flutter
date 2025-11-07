# Smart Factory Control App

A teaching and control companion for the Smart Factory training rig. This mobile app provides students and instructors with comprehensive control, monitoring, and learning tools for Industry 4.0 manufacturing education.

## 🎉 Latest Release: v1.0.9 - Moka7 Migration

**Major Update:** The `libsnap7.so` error has been permanently fixed!

We've migrated from `dart_snap7` (native libraries) to **Moka7** (pure Java), eliminating all native library dependencies and ensuring compatibility with all Android devices.

**Download:** [smart-factory-v1.0.9.apk](https://github.com/hadefuwa/smart-factory-app/raw/main/releases/smart-factory-v1.0.9.apk)

### What's New in v1.0.9
- ✅ **Moka7 Integration** - Pure Java S7 PLC communication (no native libraries!)
- ✅ **Fixed libsnap7.so Error** - Permanently resolved
- ✅ **Universal Android Support** - Works on all Android devices
- ✅ **Better Reliability** - Improved error handling and connection stability

**[View All Releases](releases/README.md)** | **[Installation Guide](docs/MOKA7_QUICK_START.md)** | **[Technical Docs](docs/MOKA7_IMPLEMENTATION.md)**

---

## Features

### 🏠 Home Screen
- Real-time system status monitoring
- Live metrics display (Produced, Rejects, FPY, Throughput, Uptime)
- Quick control buttons (Start, Stop, Reset Faults)
- Connection status indicator

### ▶️ Run Control
- Recipe management (Steel/Aluminium/Plastic Sorting)
- Conveyor speed control (0-100%)
- Batch target configuration
- Live material counters
- Manual jog controls for all actuators
- Safety interlocks enforcement

### 🔌 I/O Live
- Real-time input monitoring
- Output control with safety checks
- Interactive output activation
- Visual status indicators
- Live PLC communication (v1.0.9+)

### 🏭 PLC Communication (NEW in v1.0.9)
- **Supported PLCs**: S7-1200, S7-1500, S7-300, S7-400
- **Data Types**: BOOL, INT, DINT, REAL, byte arrays
- **Features**: Auto-retry, connection monitoring, data stream logging
- **Technology**: Moka7 (pure Java) via MethodChannel
- **Platform**: Android only

### 📚 Worksheets
- 17 comprehensive learning activities
- Progress tracking
- Step-by-step guided instructions
- Topics: Data logging, sensors, sorting, safety, analytics, and more

### 📊 Analytics
- Real-time KPI tiles (Throughput, FPY, Rejects)
- Performance charts visualization
- CSV data export functionality

### ⚙️ Settings
- **Mode Selection**: Simulation / Live PLC Mode
- **PLC Configuration**: IP address, Rack, Slot settings
- **Simulator Configuration**: Speed scaling, material mix
- **Fault Injection**: Testing and training scenarios

## Installation

### Quick Install

1. **Download APK:**
   ```bash
   curl -L -o smart-factory.apk https://github.com/hadefuwa/smart-factory-app/raw/main/releases/smart-factory-v1.0.9.apk
   ```

2. **Uninstall old version (important!):**
   ```bash
   adb uninstall com.matrixtsl.smart_factory
   ```

3. **Install:**
   ```bash
   adb install smart-factory.apk
   ```

### PLC Configuration

After installation:
1. Open app → **Settings** → **PLC Configuration**
2. Set **IP Address** (e.g., `192.168.0.99`)
3. Set **Rack/Slot**:
   - S7-1200/1500: Rack `0`, Slot `1`
   - S7-300/400: Rack `0`, Slot `2`
4. Enable **Live Mode**

**[Full Setup Guide →](docs/MOKA7_QUICK_START.md)**

## Technical Details

### Architecture
- **Framework**: Flutter (Dart)
- **PLC Communication**: Moka7-live v0.0.11 (Java)
- **Platform Bridge**: MethodChannel (Flutter ↔ Android)
- **Design**: Material Design 3 with dark theme
- **State Management**: Stream-based reactive architecture
- **Simulation**: 10Hz update rate

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  webview_flutter: ^4.4.2
  youtube_player_iframe: ^4.0.4
  url_launcher: ^6.2.5
  timezone: ^0.9.2
  flutter_svg: ^2.0.9
  video_player: ^2.8.2
  chewie: ^1.7.4
  path_provider: ^2.1.1
  shared_preferences: ^2.2.2
  # dart_snap7: Replaced with Moka7 via MethodChannel

android:
  dependencies:
    # Moka7-live: Pure Java S7 PLC communication
    implementation 'si.trina:moka7-live:0.0.11'
```

### Build Commands
```bash
# Install dependencies
flutter pub get

# Run in debug mode
flutter run

# Build Android APK
flutter build apk --release

# Build iOS app (limited - no PLC support)
flutter build ios --release
```

## App Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   ├── simulator_state.dart           # State management
│   ├── metrics_data.dart              # Metrics and logging
│   ├── worksheet.dart                 # Educational content
│   └── data_stream_log.dart           # PLC communication logs
├── services/
│   ├── simulator_service.dart         # Simulation engine
│   └── plc_communication_service.dart # Moka7 PLC service (NEW)
├── screens/
│   ├── smart_factory_main.dart        # Main navigation
│   ├── sf_home_screen.dart            # Dashboard
│   ├── sf_run_screen.dart             # Control
│   ├── sf_io_screen.dart              # I/O monitoring
│   ├── sf_worksheets_screen.dart      # Learning activities
│   ├── sf_analytics_screen.dart       # Data analysis
│   ├── sf_settings_screen.dart        # Configuration
│   └── sf_data_stream_log_screen.dart # PLC logs (NEW)
└── widgets/
    ├── hexagon_background.dart        # UI components
    └── logo_widget.dart

android/app/src/main/kotlin/com/matrixtsl/smart_factory/
├── MainActivity.kt                    # MethodChannel handler (NEW)
└── PLCManager.kt                      # Moka7 wrapper (NEW)
```

## Documentation

### User Guides
- **[Quick Start Guide](docs/MOKA7_QUICK_START.md)** - Get started in 5 minutes
- **[Installation Instructions](releases/README.md)** - Detailed setup
- **[Release Notes](releases/README.md)** - Version history

### Technical Documentation
- **[Moka7 Implementation](docs/MOKA7_IMPLEMENTATION.md)** - Complete architecture
- **[Migration Summary](docs/MIGRATION_SUMMARY.md)** - dart_snap7 → Moka7 migration
- **[Troubleshooting](docs/MOKA7_IMPLEMENTATION.md#troubleshooting)** - Common issues

## Educational Value

The Smart Factory app provides hands-on experience with:
- **Industry 4.0 Concepts**: Real-time monitoring, data analytics, automation
- **PLC Communication**: Siemens S7 protocol, data blocks, addressing
- **Manufacturing Metrics**: FPY, throughput, OEE, uptime tracking
- **Control Systems**: Interlocks, fault handling, safety protocols
- **Quality Control**: Sensor-based sorting, reject tracking
- **Data Analysis**: CSV export, trend analysis, KPI calculation
- **Safety Protocols**: Emergency procedures, interlock compliance

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android | ✅ Full Support | All features including PLC communication |
| iOS | ⚠️ Limited | No PLC support (Moka7 is Java-only) |
| Web | ❌ Not Supported | Flutter web doesn't support platform channels |

## System Requirements

- **Android**: 5.0 (API 21) or higher
- **Storage**: ~65 MB
- **Network**: WiFi for PLC communication (optional)
- **PLC**: Siemens S7-1200/1500/300/400 (for live mode)

## Version History

| Version | Date | Highlights |
|---------|------|------------|
| **1.0.9** | 2025-11-07 | Moka7 migration, fixed libsnap7.so error |
| 1.0.8 | 2025-11-07 | PLC communication attempts |
| 1.0.6 | 2025-11-07 | Animated splash, hamburger menu |
| 1.0.5 | 2025-11-07 | Complete Smart Factory app |

**[View All Releases →](releases/README.md)**

## Contributing

We welcome contributions! Areas for improvement:
- iOS PLC support (requires Swift/Objective-C Snap7 wrapper)
- Additional PLC models (Modbus, Allen-Bradley)
- Enhanced data visualization
- Multi-language support
- Custom worksheet editor

## Troubleshooting

### libsnap7.so Error (Fixed in v1.0.9!)
If you're still seeing this error, upgrade to v1.0.9:
```bash
adb uninstall com.matrixtsl.smart_factory
adb install smart-factory-v1.0.9.apk
```

### PLC Connection Issues
1. Check IP address is correct
2. Verify PLC and phone on same network
3. Enable PUT/GET in TIA Portal
4. Verify Rack/Slot numbers match your PLC
5. Check Data Stream Log for detailed errors

**[Full Troubleshooting Guide →](docs/MOKA7_IMPLEMENTATION.md#troubleshooting)**

## Support

For issues, questions, or contributions:
- **GitHub Issues**: https://github.com/hadefuwa/smart-factory-app/issues
- **Email**: support@matrixtsl.com
- **Website**: https://www.matrixtsl.com/smartfactory/

## License

© 2025 Matrix TSL. All rights reserved.

## Acknowledgments

- Built with Flutter for cross-platform deployment
- PLC communication powered by Moka7 (Dave Nardella)
- Designed for Matrix TSL Smart Factory training systems

---

**Version**: 1.0.9+2
**Last Updated**: 2025-11-07
**Status**: Production Ready
**PLC Support**: ✅ Android (Moka7)
