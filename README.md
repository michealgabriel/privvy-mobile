
# Privvy Flutter App README

## Table of Contents
- [Privvy Flutter App README](#privvy-flutter-app-readme)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Prerequisites](#prerequisites)
  - [Setting up Firebase](#setting-up-firebase)
    - [Creating a Firebase Account](#creating-a-firebase-account)
    - [Provisioning Database and Storage Bucket](#provisioning-database-and-storage-bucket)
    - [Downloading Configuration Files](#downloading-configuration-files)
  - [Flutter Firebase CLI Setup](#flutter-firebase-cli-setup)
  - [Project Structure](#project-structure)
  - [Getting Started](#getting-started)
  - [Features](#features)
  - [Contributing](#contributing)
    - [Setting Up Development Environment](#setting-up-development-environment)
    - [Code Style](#code-style)
    - [Running Tests](#running-tests)
    - [Versioning](#versioning)
    - [License](#license)

## Introduction

Privvy is an innovative mobile application that allows users to upload images of their favorite items and instantly generate up to 17 stunning color variations. This Flutter-based app leverages Firebase services to provide a seamless user experience.

## Prerequisites

- Flutter SDK installed on your system
- Android Studio or Visual Studio Code
- Git installed on your system

## Setting up Firebase

### Creating a Firebase Account

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Sign in with your Google account
3. Create a new project or select an existing one

### Provisioning Database and Storage Bucket

1. In the Firebase Console, navigate to "Database" > "Realtime Database"
2. Click "Create database" and follow the setup wizard
3. Repeat the process for Cloud Storage

### Downloading Configuration Files

1. In the Firebase Console, go to your app's dashboard
2. Navigate to "Project Settings" > "Your app"
3. Scroll down to find "SDK setup"
4. Download `google-services.json` for Android and `GoogleService-Info.plist` for iOS

Place these files in the following directories:

- `android/app/` (for `google-services.json`)
- `ios/Runner/` (for `GoogleService-Info.plist`)

## Flutter Firebase CLI Setup

For a more streamlined setup process, consider using the Flutter Firebase CLI:

1. Install Flutter Firebase CLI:
   ```
   flutter pub global activate flutterfire_cli
   ```

2. Authenticate with Firebase:
   ```
   flutterfire auth login
   ```

3. Initialize your project:
   ```
   flutterfire init
   ```

This will set up your project with the necessary Firebase configurations. Additional video guide, i recommend watching this [video](https://www.youtube.com/watch?v=G-mbqiE87Lw) on how to use Flutter Firebase CLI.

## Project Structure

```
privvy/
├── android/
├── ios/
├── lib/
│   ├── controllers/
│   ├── models/
│   ├── providers/
│   ├── utils/
│   └── views/
└
```

## Getting Started

1. Clone this repository
2. Install dependencies:
   ```
   flutter pub get
   ```
3. Run the app:
   ```
   flutter run
   ```

## Features

- Vivid Color Variations: Generate up to 17 stunning color options for your items
- Collections Made Easy: Organize and manage your creations efficiently
- Relax & Create: Enjoy short music tracks while working on your projects
- User-Friendly Interface: Sleek design and easy navigation for everyone

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Setting Up Development Environment

1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Ensure you have the latest version of Flutter installed

### Code Style

We use [Dart Format](https://github.com/dart-lang/dart_style) for code formatting. You can run `dartfmt` on your files to ensure consistency.

### Running Tests

To run tests, navigate to the `test` directory and execute:

```
flutter test
```

### Versioning

We use [SemVer](http://semver.org/) for versioning. For more information on commit messages and guidelines, please read [CONTRIBUTING.md](CONTRIBUTING.md).

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---