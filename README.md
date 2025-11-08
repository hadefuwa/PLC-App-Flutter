# PLC Control App

A simple, clean Flutter app for connecting to and controlling PLCs. This app provides basic monitoring and control capabilities for industrial automation systems.

## Features

### 🔌 PLC I/O Monitor
- Real-time input/output monitoring
- Generic I/O addressing (I0.0, I0.1, ... Q0.0, Q0.1, etc.)
- Force ON/OFF controls for testing
- Visual status indicators (green/grey LED indicators)
- Live PLC communication

### ⚙️ PLC Settings
- PLC IP address configuration
- IP presets (192.168.0.1, 192.168.1.1, 192.168.7.2) or custom IP
- Rack/Slot configuration
- Connect/Disconnect control
- Connection status display

### 🏭 PLC Communication
- **Supported PLCs**: Siemens S7-1200, S7-1500, S7-300, S7-400
- **Data Types**: BOOL, INT, DINT, REAL, byte arrays
- **Technology**: Moka7 (pure Java) via MethodChannel
- **Platform**: Android only

## Installation

### Quick Install

1. **Download APK:**
   ```bash
   curl -L -o plc-control.apk https://github.com/your-repo/plc-control-app/releases/latest/download/app-release.apk
   ```

2. **Uninstall old version (if exists):**
   ```bash
   adb uninstall com.plccontrol.app
   ```

3. **Install:**
   ```bash
   adb install plc-control.apk
   ```

### PLC Configuration

After installation:
1. Open app → **Settings**
2. Select IP preset or enter custom IP address
3. Set **Rack/Slot**:
   - S7-1200/1500: Rack `0`, Slot `1`
   - S7-300/400: Rack `0`, Slot `2`
4. Tap **Connect**

## Technical Details

### Architecture
- **Framework**: Flutter (Dart)
- **PLC Communication**: Moka7-live v0.0.11 (Java)
- **Platform Bridge**: MethodChannel (Flutter ↔ Android)
- **Design**: Material Design 3 with dark theme
- **State Management**: Stream-based reactive architecture

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  shared_preferences: ^2.2.2

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
```

## App Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   ├── simulator_state.dart           # State management
│   ├── io_link_data.dart              # IO-Link data models
│   └── data_stream_log.dart           # PLC communication logs
├── services/
│   ├── simulator_service.dart         # Simulation engine
│   └── plc_communication_service.dart # Moka7 PLC service
├── screens/
│   ├── plc_main.dart                  # Main navigation (2 tabs)
│   ├── plc_io_screen.dart             # I/O monitoring
│   └── plc_settings_screen.dart       # PLC configuration
└── widgets/
    ├── hexagon_background.dart        # UI components
    ├── logo_widget.dart
    └── splash_screen.dart

android/app/src/main/kotlin/com/plccontrol/app/
├── MainActivity.kt                    # MethodChannel handler
└── PLCManager.kt                      # Moka7 wrapper
```

## I/O Table

### Inputs (I)
- **I0.0 - I0.7**: Digital inputs on byte 0
- **I1.0**: Digital input on byte 1
- Total: 9 generic input addresses

### Outputs (Q)
- **Q0.0 - Q0.7**: Digital outputs on byte 0
- Total: 8 generic output addresses

All I/O can be forced ON/OFF for testing purposes using the force buttons in the app.

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android | ✅ Full Support | All features including PLC communication |
| iOS | ❌ Not Supported | Moka7 is Java-only |
| Web | ❌ Not Supported | Flutter web doesn't support platform channels |

## System Requirements

- **Android**: 5.0 (API 21) or higher
- **Storage**: ~20 MB
- **Network**: WiFi/Ethernet for PLC communication
- **PLC**: Siemens S7-1200/1500/300/400

## Troubleshooting

### PLC Connection Issues
1. Verify IP address is correct
2. Ensure PLC and phone are on the same network
3. Enable PUT/GET in TIA Portal (for S7-1200/1500)
4. Verify Rack/Slot numbers match your PLC model
5. Check firewall settings on PLC

### Common Error Messages
- **"Not connected to PLC"**: Click Connect button in Settings
- **"Connection timeout"**: Check IP address and network connectivity
- **"Invalid IP address format"**: Enter IP in format xxx.xxx.xxx.xxx

## Contributing

We welcome contributions! Areas for improvement:
- iOS PLC support (requires Swift/Objective-C Snap7 wrapper)
- Additional PLC models (Modbus, Allen-Bradley, etc.)
- Enhanced data visualization
- Multi-language support

## Support

For issues, questions, or contributions:
- **GitHub Issues**: Create an issue on the repository

## License

© 2025 PLC Control App. All rights reserved.

## Acknowledgments

- Built with Flutter for cross-platform development
- PLC communication powered by Moka7 (Dave Nardella)

---

**Version**: 1.0.0+1
**Last Updated**: 2025-01-XX
**Status**: Production Ready
**PLC Support**: ✅ Android (Moka7)
