# Matrix TSL Product Showcase App

A beautiful Flutter app showcasing Matrix TSL industrial training products. Browse and explore interactive product websites directly within the app.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![Android](https://img.shields.io/badge/Android-21+-3DDC84?logo=android)
![License](https://img.shields.io/badge/license-MIT-blue)

## ✨ Features

### 🎯 Product Showcase
- Browse three Matrix TSL training products
- Beautiful card-based interface
- Direct access to interactive product websites
- Smooth navigation and loading states

### 📱 Products Included

1. **Maintenance of Closed Loop Systems (IM0004)**
   - Comprehensive training platform for industrial maintenance technicians
   - Master closed-loop control systems through interactive worksheets
   - Real-world scenarios and practical training

2. **PLC Fundamentals (IM6930)**
   - Hands-on training platform for industrial maintenance and automation
   - Features Siemens S7-1214 PLC and 7-inch Unified Basic HMI
   - Real-world components and industrial wiring standards

3. **Matrix LOGO! (IM3214)**
   - Modular industrial control training system
   - Introduces learners to core concepts in industrial automation
   - Features Siemens LOGO! PLC on custom Locktronics carrier plate

### 🎨 Beautiful UI
- Material Design 3 theming
- Smooth animations and transitions
- Responsive layout
- Professional blue color scheme
- Dark mode support

## 📱 Screenshots

*Add screenshots of your app here*

## 📥 Download APK

**Want to download the app directly to your phone?**

👉 **[Download MatrixTSL-v1.0.0.apk](https://github.com/hadefuwa/matrix-android-app/raw/main/releases/MatrixTSL-v1.0.0.apk)**

Or visit the [releases folder](https://github.com/hadefuwa/matrix-android-app/tree/main/releases) for installation instructions.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Android Studio (for Android development)
- Android device or emulator (API 21+)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/hadefuwa/habit-app.git
   cd habit-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # On Windows desktop (recommended for testing)
   flutter run -d windows
   
   # On Android device/emulator
   flutter run
   ```

### Quick Start Scripts

**Windows:**
- Double-click `scripts\run-app.bat` to launch the app
- Or use PowerShell: `.\scripts\run-app.ps1`

**Command Line:**
```bash
# Add Flutter to PATH for easier access
# Then simply run:
flutter run -d windows
```

## 📖 How to Use

1. **Browse Products**: View all available Matrix TSL products on the main screen
2. **Select a Product**: Tap on any product card to view its interactive website
3. **Navigate**: Use the webview to explore the product website
4. **Refresh**: Tap the refresh button in the app bar to reload the page
5. **Go Back**: Use the back button to return to the product list

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   └── product.dart            # Product model
└── screens/                     # UI screens
    ├── products_list_screen.dart    # Main product list screen
    └── product_webview_screen.dart  # WebView screen for products
```

## 🛠️ Technologies Used

- **Flutter** - Cross-platform UI framework
- **WebView Flutter** - Embedded web content display
- **Material Design 3** - Modern UI components

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  webview_flutter: ^4.4.2
```

## 🔧 Configuration

### Android Permissions

The app requires the following permission (already configured in `AndroidManifest.xml`):
- `INTERNET` - For loading web content


## 📱 Building for Android

### Quick Build

Use the provided build scripts:

**Windows (Command Prompt/PowerShell):**
```bash
.\scripts\build-apk.bat
```

Or manually:
```bash
flutter build apk --release
```

The APK will be created at: `build\app\outputs\flutter-apk\app-release.apk`

### Prerequisites for Android Build

**Java 17 Required:**

1. **Download Java 17:**
   - Visit: https://adoptium.net/temurin/releases/?version=17
   - Download Windows x64 installer (.msi)

2. **Install:**
   - Install to default location
   - ✅ Check "Add to PATH" during installation

3. **Set JAVA_HOME:**
   - Press `Win + X` → "System"
   - "Advanced system settings" → "Environment Variables"
   - Add new variable: `JAVA_HOME` = `C:\Program Files\Eclipse Adoptium\jdk-17.x.x-hotspot`
   - Restart terminal

4. **Verify:**
   ```bash
   java -version
   # Should show: openjdk version "17.x.x"
   ```

**Android SDK:**

The project is configured with:
- compileSdk: 36
- targetSdk: 36
- minSdk: 21 (Android 5.0+)
- Android Gradle Plugin: 8.6.0
- Kotlin: 2.1.0
- Gradle: 8.7

### Build Configuration

The build scripts automatically:
- Detect Java 17 installation
- Configure Android SDK paths
- Generate release APK (46MB)

## 📲 Installing on Your Phone

### Method 1: Transfer APK File (Recommended)

1. **Build the APK** (see above)

2. **Transfer to phone:**
   - Email the APK to yourself
   - Use Google Drive/Dropbox
   - Transfer via USB cable
   - Use Bluetooth

3. **Install on phone:**
   - Go to Settings → Security → Enable "Install unknown apps"
   - Open the APK file on your phone
   - Tap "Install"

### Method 2: Direct USB Install

1. **Enable USB Debugging on phone:**
   - Settings → About phone
   - Tap "Build number" 7 times
   - Go to Settings → Developer options
   - Enable "USB debugging"

2. **Connect phone to computer via USB**

3. **Install directly:**
   ```bash
   .\scripts\install-on-phone.bat
   ```

   Or manually:
   ```bash
   flutter run
   ```

### Method 3: Using Android Studio

1. Open project in Android Studio
2. Connect phone via USB (USB debugging enabled)
3. Click the green "Run" button (▶️)
4. Select your phone from device list

## 🐛 Troubleshooting

### Build Issues

**"Java 17 not found"**
- Install Java 17 from Adoptium (see Prerequisites)
- Ensure JAVA_HOME is set correctly
- Restart terminal after installation

**"Android SDK not found"**
- Install Android Studio
- The build will auto-download required SDK components

**"Device not showing up"**
- Enable USB debugging on phone
- Use a data cable (not charging-only)
- Try different USB port
- Install phone manufacturer's USB drivers

### Runtime Issues

**Web pages not loading**
- Check internet connection
- Verify the product URLs are accessible
- Try refreshing the page using the refresh button

**"Install blocked" on phone**
- Go to Settings → Security → Unknown sources
- Enable installation from unknown sources
- Or enable for specific app (File Manager, Email)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Built with Flutter
- Material Design 3 components
- Icons from Material Icons
- Product information from Matrix TSL

## 📞 Support

For issues, questions, or suggestions, please open an issue on GitHub.

---

**Made with ❤️ for showcasing Matrix TSL industrial training products!**
