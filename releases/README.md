# PLC Control App - Releases

## Latest Release

### Version 1.0.0 (Current)

**Download:** Place your built APK here after running:
```bash
flutter build apk --release
```

The APK will be located at:
```
build/app/outputs/flutter-apk/app-release.apk
```

Copy it to this releases folder:
```bash
cp build/app/outputs/flutter-apk/app-release.apk releases/plc-control-v1.0.0.apk
```

## Installation

```bash
adb uninstall com.plccontrol.app
adb install releases/plc-control-v1.0.0.apk
```

## Release History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-01-XX | Initial release - Basic PLC Control app with generic I/O monitoring |

## Features

- PLC I/O monitoring (I0.0-I0.7, I1.0, Q0.0-Q0.7)
- PLC connection settings (IP, Rack, Slot)
- Moka7 PLC communication
- Simple 2-page interface
