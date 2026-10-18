# medical_appointment_app

Flutter medical appointment prototype developed for Laboratory 3.

## Laboratory 3 features

- Cubit state management with Loading, Success, Empty and Error states
- asynchronous loading from `assets/data/lab_v2.json`
- JSON data models and repository layer
- doctor search, favorites filter and A-Z / Z-A sorting
- add/remove favorites
- navigation to appointment details
- reusable UI components and modular folders

## Project structure

```text
lib/
  core/          shared colors
  data/          models and JSON repository
  logic/         Cubit and application states
  presentation/  screens and reusable widgets
```

Run the project with:

```bash
flutter pub get
flutter run
```

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
