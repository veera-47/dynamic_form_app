# Dynamic Form App

A Flutter application for logging work activities with dynamic forms, supporting both mobile (Android) and web platforms.

## Features
- Dynamic form generation from JSON files
- Support for text fields, radio buttons, location fetching, and selfie capture
- Persistent storage of form data using `shared_preferences`
- Two-column layout for saved data display
- Web-compatible selfie capture using gallery selection
- Retains name and contact number after form submission

## Prerequisites
- **Flutter SDK**: Version 3.0.0 or higher
- **Dart**: Version 2.17.0 or higher
- **Android Studio** or **VS Code** with Flutter plugin
- **Node.js** (for hosting the web app locally)
- **Git**: For cloning the repository

## Setup Instructions

### 1. Clone the Repository
Clone the repository to your local machine:
```bash
git clone https://github.com/veera-47/dynamic_form_app/tree/master
cd dynamic-form-app

### 2. Install Dependencies
Run the following command to install all required packages: 
flutter pub get

### 3. Add JSON Form Files
Place the following JSON files in the assets directory:
hnicustomersmet.json
nonhnicustomermet.json
activitiesconducted.json
Ensure these assets are declared in pubspec.yaml:
flutter:
  assets:
    - assets/hnicustomersmet.json
    - assets/nonhnicustomermet.json
    - assets/activitiesconducted.json

### 4.Run the App on Mobile (Android)
Using an Emulator or Device
Connect an Android device or start an emulator.
Run the app in debug mode:
flutter run
Using the Pre-built APK
The pre-built APK is located at build/app/outputs/flutter-apk/app-release.apk.
Transfer the APK to your Android device.
Enable "Install from Unknown Sources" in your device settings (usually under Security).
Install the APK by opening the file on your device, or use ADB:
adb install build/app/outputs/flutter-apk/app-release.apk

### 5. Run the Web App
Build the Web App
Ensure web support is enabled:
flutter config --enable-web
The pre-built web app is located in the build/web directory. If you need to rebuild it:
flutter build web --release
Host the Web App Locally
Install http-server to host the web app locally (requires Node.js):
npm install -g http-server
Navigate to the build/web directory and start the server:
cd build/web
http-server -p 8000
Open a browser and go to http://localhost:8000 to access the web app.
Access the Deployed Web App (Optional)
If deployed to GitHub Pages, the web app is available at:
https://github.com/veera-47/dynamic_form_app/tree/master

### 6. Rebuild the APK (Optional)
If you need to rebuild the APK:
Ensure you have a keystore file (my-release-key.jks) in the android/app directory.
Update android/app/build.gradle with your signing configuration (see the file for details).
Build the release APK:
flutter build apk --release
The new APK will be generated at build/app/outputs/flutter-apk/app-release.apk.
Dependencies
The app uses the following packages (listed in pubspec.yaml):

flutter
image_picker: ^1.0.0
geolocator: ^10.0.0
shared_preferences: ^2.0.0
json_annotation: ^4.8.0

Project Structure
lib/: Contains the main application code
screens/: FormScreen and SavedDataScreen
models/: Form data models
services/: Form loading and saving logic
assets/: JSON form files
android/: Android-specific configurations
web/: Web-specific configurations (auto-generated)
build/: Contains the pre-built APK (build/app/outputs/flutter-apk/) and web app (build/web/)

Known Limitations
On web, the selfie feature uses the gallery instead of the camera due to browser limitations.
Location fetching on web depends on browser permissions

Contributing
Contributions are welcome! Please fork the repository, make your changes, and submit a pull request.

License
This project is licensed under the MIT License.