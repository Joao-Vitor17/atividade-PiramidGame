# piramidgame

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Firebase setup

Enable Email/Password and Google providers in Firebase Authentication. Add the
Firestore and Storage security rules from `firestore.rules` and
`firebase_storage.rules` to the project. Enable Firebase Storage in the Firebase
console before uploading profile photos:

```sh
firebase deploy --only firestore:rules,storage
```

For Google Sign-In on Android, register the app's SHA-1 certificate in Firebase,
enable Google as an Authentication provider, and download the refreshed
`google-services.json`. The current Android configuration has no OAuth clients.
If the generated Android setup requires an explicit web client ID, run with:

```sh
flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=YOUR_WEB_CLIENT_ID
```

For web, add the deployed host to Firebase Authentication's authorized domains.
Person profiles and assessments are stored in Firestore; only the theme
preference is stored locally with SharedPreferences. Profile photos are saved in
Firebase Storage, and their download URLs are stored with each person in
Firestore.
