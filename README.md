
# Mapospace Flutter SDK

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

**Mapospace Flutter SDK** is a lightweight geospatial analytics tool designed to capture event data, including location, from mobile applications. It enables real-time insights into user behavior, trends, and location-based analytics, providing seamless integration for developers.

---

## Features ✨

- Easy integration with Flutter apps
- Real-time event tracking
- Geospatial analytics with location-based insights
- Optimized for performance and minimal overhead
- Secure and privacy-compliant data handling

---

## Installation 💻

**❗ Ensure you have the [Flutter SDK][flutter_install_link] installed on your system before proceeding.**

Install via `flutter pub add`:

```sh
flutter pub add mapospace_flutter_sdk
```

Or manually add to your `pubspec.yaml`:

```yaml
dependencies:
  mapospace_flutter_sdk: latest_version
```

Then run:

```sh
flutter pub get
```

## Usage 🚀

To initialize and start tracking events, import and set up the SDK:

```dart
import 'package:mapospace_flutter_sdk/mapospace_flutter_sdk.dart';

void main() async {
  await MapoSpaceSdk.initialize(apiKey: 'YOUR_API_KEY');

  MapoSpaceSdk.trackEvent(
    eventName: 'product_view',
    parameters: {
      'product_id': '12345',
      'user_location': {'lat': 37.7749, 'lng': -122.4194},
    },
  );
}
```

For more details, refer to the official documentation.

## Location Permissions 📍

To accurately track location data, your application will require location permissions.  The specific implementation varies between Android and iOS.

### Android

1.  **Add Permissions to `AndroidManifest.xml`:**

    Open `android/app/src/main/AndroidManifest.xml` and add the following permissions within the `<manifest>` tag:

    ```xml
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.INTERNET" /> <!-- Required for network requests -->
    ```

    *   `ACCESS_FINE_LOCATION`:  Provides the most accurate location data.
    *   `ACCESS_COARSE_LOCATION`: Provides less accurate, but less battery-intensive, location data.  Consider using this if precise location is not essential.
    *   `INTERNET`: Required for sending data to the Mapospace servers.

2.  **Request Permissions at Runtime (if needed):**

    Beginning with Android 6.0 (API level 23), location permissions are considered "dangerous" and must be requested at runtime.  We recommend using a package like `permission_handler` to simplify this process.

    ```dart
    import 'package:permission_handler/permission_handler.dart';

    Future<void> requestLocationPermission() async {
      final status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        print('Location permission granted');
      } else if (status == PermissionStatus.denied) {
        print('Location permission denied');
      } else if (status == PermissionStatus.permanentlyDenied) {
        print('Location permission permanently denied');
        // Open app settings to allow the user to enable the permission manually.
        openAppSettings();
      }
    }
    ```

    Call `requestLocationPermission()` early in your app's lifecycle, likely during your main function or on the first screen requiring location data.  Handle the different permission states gracefully.

### iOS

1.  **Add Usage Description Keys to `Info.plist`:**

    Open `ios/Runner/Info.plist` and add the following keys with appropriate descriptions *explaining why your app needs location access*:

    ```xml
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs your location to provide location-based analytics.</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>This app needs your location, even in the background, to provide continuous location-based analytics.</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>This app needs your location, even in the background, to provide continuous location-based analytics.</string>
    ```

    *   `NSLocationWhenInUseUsageDescription`:  Used when you only need location access while the app is in use.
    *   `NSLocationAlwaysUsageDescription`:  Used when you need location access even when the app is in the background.  **Apple requires a strong justification for using this permission.**
    *   `NSLocationAlwaysAndWhenInUseUsageDescription`:  Combines the functionality of both.  Use this if you need both scenarios.

    **Important:** Apple requires that you provide clear and concise explanations for *why* your app needs location access.  Failure to do so may result in your app being rejected from the App Store.  Customize the strings above to reflect your app's specific use case.

2.  **Request Permissions at Runtime (optional, but recommended for a better user experience):**

    While iOS technically doesn't *require* you to request permissions manually if you've included the `Info.plist` keys, doing so provides a better user experience.  Using `permission_handler` (as shown in the Android section) simplifies this process on iOS as well.  The code is generally the same.

**Note:** If you are using background location updates, ensure your app meets Apple's guidelines for background location usage. Excessive or unjustified background location use can lead to App Store rejection.

## Continuous Integration 🤖

Mapospace Flutter SDK includes a GitHub Actions workflow powered by Very Good Workflows. This ensures that code formatting, linting, and testing are executed automatically with every pull request and push.

*   **Linting:** Enforces code style using Very Good Analysis.
*   **Testing:** Runs unit tests with coverage reports.
*   **Code Coverage:** Uses Very Good Workflows to enforce minimum coverage thresholds.

## Running Tests 🧪

Install the `very_good_cli`:

```sh
dart pub global activate very_good_cli
```

Run all tests:

```sh
very_good test --coverage
```

Generate and view the coverage report:

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

## Contributing 🤝

We welcome contributions! Feel free to open issues and submit pull requests. Please follow the contribution guidelines.

## License 📜

This project is licensed under the MIT License.
```