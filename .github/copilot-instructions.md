# Copilot Instructions for OSRS Bot Dashboard

## Project Overview

This is a Flutter application that serves as a dashboard for managing an Old-School RuneScape bot farm. The app provides a UI to monitor and control multiple bot accounts, view their activity, and manage their status.

## Technology Stack

- **Framework**: Flutter (SDK >=3.0.1 <4.0.0)
- **Language**: Dart
- **State Management**: Provider pattern
- **HTTP Client**: http package (^0.13.6)
- **JSON Parsing**: Manual JSON deserialization with factory constructors

## Project Structure

```
lib/
├── api/                    # API client and data models
│   ├── bot_api.dart       # Main API client with HTTP requests
│   ├── account.dart       # Account model
│   ├── account_activity.dart
│   └── bot_provider.dart  # Provider for account state management
├── model/                 # Application models
├── state/                 # State management
├── card/                  # Card widgets for UI components
├── dialog/                # Dialog widgets
├── main.dart             # App entry point
└── [other widget files]   # Various UI components
```

## Coding Conventions

### Dart Style Guidelines

1. **Follow Flutter/Dart conventions**: Use the official Dart style guide
2. **Linting**: This project uses `flutter_lints` package - ensure all code passes `flutter analyze`
3. **Naming**:
   - Use `PascalCase` for classes and enums (e.g., `AccountsModel`, `AccountStatus`)
   - Use `camelCase` for variables, functions, and parameters
   - Use `SCREAMING_SNAKE_CASE` for constants (e.g., `BASE_URL`)
   - Prefix private members with underscore (e.g., `_activeAccounts`)

4. **Imports**:
   - Organize imports: dart SDK imports first, then package imports, then relative imports
   - Use relative imports for project files

### State Management

- Use the **Provider** pattern for state management
- Models should extend `ChangeNotifier` and call `notifyListeners()` after state changes
- See `AccountsModel` and `AccountActivityModel` for reference implementations

### API Integration

- All API calls are centralized in `lib/api/bot_api.dart`
- Base URL: `http://localhost:8080`
- Use `http` package for HTTP requests
- Handle `SocketException` for network errors
- Use `debugPrint` or `log` for error logging
- Return `null` on errors for graceful handling

### Models and JSON

- Create factory constructors `fromJson` for deserializing API responses
- This project uses **manual JSON parsing** (not using json_serializable code generation)
- Example pattern:
  ```dart
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'].toString(),
      username: json['username'],
      // ... other fields
    );
  }
  ```

### Widgets

- Prefer `StatelessWidget` when possible, use `StatefulWidget` only when state is needed
- Use `const` constructors where possible for performance
- Follow Flutter widget composition patterns
- Use named parameters with `required` for mandatory fields

### Error Handling

- Use try-catch blocks for API calls
- Handle `SocketException` specifically for network errors
- Return `null` or use optional types to indicate failure
- Log errors using `dart:developer`'s `log()` function or `debugPrint`

## Development Commands

### Building and Testing

```bash
# Get dependencies
flutter pub get

# Analyze code for issues
flutter analyze

# Run tests
flutter test

# Run the app
flutter run
```

### Code Quality

- Run `flutter analyze` before committing to ensure no linting errors
- Analysis options are configured in `analysis_options.yaml`
- The project includes `flutter_lints` for recommended linting rules

## Testing

- Tests are located in the `test/` directory
- Use `flutter_test` package for widget and unit tests
- Follow the existing test patterns in `test/widget_test.dart`

## Key Features to Understand

1. **Account Management**: Tracks active and inactive bot accounts
2. **Activity Monitoring**: Displays recent bot activities including scripts run and arguments
3. **Bot Control**: Start/stop bots through the API
4. **Real-time Updates**: Uses Provider pattern to reactively update UI when data changes

## API Endpoints

- `GET /bots/active` - Get currently active accounts/bots
- `GET /accounts` - Get all accounts
- `GET /bots/activity` - Get recent bot activity
- `POST /bots` - Start a bot (body: `{id, script, args}`)

## Important Notes

- The app connects to a local backend at `http://localhost:8080`
- Account statuses: `ACTIVE`, `INACTIVE`, `BANNED`
- Provider pattern is used for state management - familiarize with `ChangeNotifier` and `notifyListeners()`
- The project uses Material Design via `uses-material-design: true`

## When Making Changes

1. Ensure changes follow the Flutter and Dart style guides
2. Run `flutter analyze` to check for issues
3. Update models if API contracts change
4. Use Provider pattern for state management needs
5. Keep widgets modular and reusable
6. Handle errors gracefully, especially network errors
7. Use const constructors for performance optimization
