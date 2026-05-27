# Smart Campus Health & Safety Notification App

A Flutter-based mobile app for quickly reporting, tracking, and viewing health, safety, and technical incidents on campus via a map.

## Project Purpose

This app lets campus users report incidents (e.g. security, health, technical issues, lost items, etc.) from a single place, and helps relevant departments manage the process more transparently.

## Key Features

- Sign in with email/password and Google via Firebase Authentication
- Create notifications (category, title, description, location, optional image)
- Live notification feed (Firestore stream)
- Search and filter notifications (category, status, followed items, department)
- Notification detail screen and incident location on the map
- Follow notifications and get feedback on status changes
- Role-based access (user / admin)
- Update notification status from the admin panel (Open, In Progress, Resolved)
- Publish emergency announcements (top banner alert)
- Profile screen (user info, followed notifications, settings)

## Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **State Management:** Riverpod
- **Backend:** Firebase (Auth, Firestore, Storage)
- **Maps:** Google Maps Flutter
- **Location:** Geolocator + Permission Handler

## Project Structure

```text
lib/
  feature/
    admin/
    home/
    login/
    map/
    notification/
    profile/
  product/
    constant/
    enum/
    mixin/
    model/
    widget/
  main.dart
```

## Screens

- Login Screen
- Sign Up Screen
- Home (Notification List)
- Create Notification Screen
- Notification Detail Screen
- Map Screen
- Profile Screen
- Admin Panel
- Emergency Alert Screen

## Screenshots

> Add your screenshots to this section.  
> Example folder: `docs/screenshots/`

### Login
![Login Screen](docs/screenshots/login.png)

### Home
![Home Screen](docs/screenshots/home.png)

### Create Notification
![Create Notification Screen](docs/screenshots/create-notification.png)

### Notification Detail
![Notification Detail Screen](docs/screenshots/notification-detail.png)

### Map
![Map Screen](docs/screenshots/map.png)

### Profile
![Profile Screen](docs/screenshots/profile.png)

### Admin Panel
![Admin Screen](docs/screenshots/admin.png)

### Emergency Alert
![Emergency Alert Screen](docs/screenshots/emergency-alert.png)

## Setup

### 1) Requirements

- Flutter SDK (recommended: stable)
- Dart SDK (bundled with Flutter)
- Android Studio or VS Code
- Firebase project
- Google Maps API key

### 2) Clone the project

```bash
git clone <repo-url>
cd Smart-Campus-Health-and-Safety-Notification-App
```

### 3) Install dependencies

```bash
flutter pub get
```

### 4) Firebase setup

This project uses Firebase. With your own Firebase project, follow these steps:

1. Add Android/iOS apps in the Firebase Console.
2. Run `flutterfire configure`.
3. Place the generated `firebase_options.dart` file under `lib/`.
4. Enable Firestore and Authentication services.

### 5) Google Maps setup

- For Android, add your API key in `android/app/src/main/AndroidManifest.xml`.
- For iOS, add your API key in `ios/Runner/AppDelegate.swift` or the relevant configuration.

### 6) Run the app

```bash
flutter run
```

## Example Usage Flow

1. The user signs in or registers.
2. On the home screen, they view existing notifications and search/filter them.
3. They create a notification for a new incident and select a location.
4. They follow the notification to track status updates.
5. Users with the admin role manage status from the admin panel.

## Development Notes

- The app uses a dark-theme-focused UI.
- Data is listened to in real time via Firestore.
- Role information is managed via the `role` field in the `users` collection.

## Contributing

Open a pull request or create an issue for development suggestions and contributions.
