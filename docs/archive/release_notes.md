# Smart Factory v1.0.9 - Moka7 Migration

## Major Update: libsnap7.so Error Fixed Permanently!

This release completely solves the `Failed to load dynamic library libsnap7.so` error by migrating from dart_snap7 (native libraries) to **Moka7** (pure Java).

## What's New

- **Migrated to Moka7** - Pure Java S7 PLC communication library
- **Removed libsnap7.so** - No native libraries needed
- **Works on all Android devices** - No ABI compatibility issues
- Added Moka7-live (v0.0.11) - Official Java port of Snap7
- Created PLCManager.kt - Comprehensive PLC communication manager
- Implemented MethodChannel bridge for Flutter-Android communication

## Installation

1. Download `app-release.apk` from this release
2. **Uninstall old version first:** `adb uninstall com.matrixtsl.smart_factory`
3. Install: `adb install app-release.apk`

## PLC Configuration

After installation:
1. Open app → Settings → PLC Configuration
2. Set IP Address (e.g., `192.168.0.99`)
3. Set Rack/Slot (S7-1200/1500: Rack 0, Slot 1)
4. Enable Live Mode

## Features

- Connect to S7-1200, S7-1500, S7-300, S7-400
- Read/Write BOOL, INT, DINT, REAL
- Automatic connection retry
- Connection status monitoring
- Data stream logging

## Technical Details

- Version: 1.0.9+2
- APK Size: 62.0 MB
- Platform: Android only
- Min SDK: Android 5.0+

## Documentation

- [MOKA7_IMPLEMENTATION.md](https://github.com/hadefuwa/smart-factory-app/blob/main/MOKA7_IMPLEMENTATION.md)
- [MOKA7_QUICK_START.md](https://github.com/hadefuwa/smart-factory-app/blob/main/MOKA7_QUICK_START.md)
- [MIGRATION_SUMMARY.md](https://github.com/hadefuwa/smart-factory-app/blob/main/MIGRATION_SUMMARY.md)

## What This Fixes

- libsnap7.so not found error (permanently fixed)
- ABI compatibility issues
- Native library loading errors
- Platform-specific build problems
