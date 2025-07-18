# Fit Track Pro

Fit Track Pro is a comprehensive Flutter-based fitness tracking application designed to monitor and display real-time workout statistics such as heart rate, steps, and calories burned. It features an interactive UI with animated components and integrates state management using Bloc and Cubit patterns.

## Features

- Real-time heart rate monitoring with animated visual feedback.
- Step and calorie tracking during workouts.
- Workout session management with start, pause, resume, skip, and end functionalities.
- Dashboard with detailed workout statistics and charts.
- Notification service integration.
- Modular architecture separating domain, data, and presentation layers.

## Project Structure

```
lib/
├── core/                  # Core utilities, services, constants, and dependency injection
├── features/
│   ├── dashboard/         # Dashboard UI, state management, and widgets
│   └── workout/           # Workout domain, data, and presentation layers
├── main.dart              # Application entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (version compatible with the project)
- Dart SDK

### Installation

1. Clone the repository:

```bash
git clone https://github.com/bynalab/fit_track_pro.git
cd fit_track_pro
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Testing

The project includes unit and widget tests for core components:

- Bloc and Cubit state management tests.
- Widget tests for UI components.
- Repository and service tests.

Run tests with:

```bash
flutter test
```

## Known Limitation
The app currently supports only portrait mode.
iOS notification might not work as expected on simulator

## Contributing

Contributions are welcome! Please fork the repository and submit pull requests for improvements or bug fixes.

## License

Specify your project license here.

---

This README provides a clean and structured overview of the Fit Track Pro project, helping developers and users understand the purpose, structure, and usage of the app.
        