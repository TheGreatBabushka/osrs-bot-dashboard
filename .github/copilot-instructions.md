# Copilot Instructions for OSRS Bot Dashboard

## Project Overview

This is a Flutter application that serves as a dashboard for managing an Old-School RuneScape bot farm. The app provides a UI to monitor and control multiple bot accounts, view their activity, and manage their status.

## Technology Stack

- **Framework**: Flutter (SDK >=3.0.1 <4.0.0)
- **Language**: Dart
- **UI**: Material Design 3 (useMaterial3: true)
- **State Management**: Provider pattern with MultiProvider
- **HTTP Client**: http package (^0.13.6)
- **JSON Parsing**: Manual JSON deserialization with factory constructors
- **Local Storage**: shared_preferences package (^2.2.0) for persistent configuration

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
- The app uses **MultiProvider** to manage multiple state models
- Models should extend `ChangeNotifier` and call `notifyListeners()` after state changes
- Key state models:
  - `SettingsModel`: Manages API configuration (loaded first, then passed to other models)
  - `AccountsModel`: Manages account data
  - `AccountActivityModel`: Manages activity data
- Settings are loaded asynchronously on app start; show loading indicator while `SettingsModel.isLoading` is true

### API Integration

- All API calls are centralized in `lib/api/api.dart` (BotAPI class)
- **Base URL is configurable** via SettingsModel (defaults to `http://localhost:8080`)
- Always pass `SettingsModel` to models that need API access (e.g., `AccountsModel(settingsModel)`)
- Use `http` package for HTTP requests
- Handle `SocketException` for network errors
- Use `debugPrint` or `log` for error logging
- Return `null` on errors for graceful handling
- URL validation: API URLs must start with `http://` or `https://`

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

### Settings and Configuration

- Use `SettingsModel` (extends `ChangeNotifier`) to manage app configuration
- Settings are persisted using `shared_preferences` package
- API URL configuration:
  - Key: `'api_ip'`
  - Default: `'http://localhost:8080'`
  - Validation: Must start with `http://` or `https://`
- Load settings asynchronously in `SettingsModel` constructor
- Use `isLoading` property to show loading state during initialization
- Settings are accessible via `Provider.of<SettingsModel>(context)`
- The `SettingsDialog` widget provides UI for configuration changes

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
5. **Persistent Configuration**: API server URL is configurable and persists across app restarts using shared_preferences

## App Initialization Flow

1. App starts and creates `SettingsModel` provider
2. `SettingsModel` loads saved settings from `SharedPreferences` asynchronously
3. While loading, app shows a loading indicator (`CircularProgressIndicator`)
4. Once settings are loaded, `MultiProvider` creates `AccountsModel` and `AccountActivityModel`
5. Both models receive `SettingsModel` to access the configured API URL
6. Main UI is rendered with all providers available

## API Endpoints

- `GET /bots/active` - Get currently active accounts/bots
- `GET /accounts` - Get all accounts
- `GET /bots/activity` - Get recent bot activity
- `POST /bots` - Start a bot (body: `{id, script, args}`)
- `POST /accounts` - Create a new account (body: `{username, email, status}`)

## Important Notes

- **API Configuration**: The app supports configurable API server URLs through the settings dialog (⚙️ icon in app bar)
- **Persistent Settings**: API URL is saved using `shared_preferences` and persists across app restarts
- Default API URL: `http://localhost:8080`
- Account statuses: `ACTIVE`, `INACTIVE`, `BANNED`
- Provider pattern is used for state management - familiarize with `ChangeNotifier` and `notifyListeners()`
- The project uses Material Design 3 via `useMaterial3: true`
- Settings must be loaded before other models can be initialized (due to API URL dependency)

## When Making Changes

1. Ensure changes follow the Flutter and Dart style guides
2. Run `flutter analyze` to check for issues
3. Update models if API contracts change
4. Use Provider pattern for state management needs
5. Keep widgets modular and reusable
6. Handle errors gracefully, especially network errors
7. Use const constructors for performance optimization
8. When adding new dependencies, check for security vulnerabilities
9. Validate user input, especially for URL configurations
10. Use `context.mounted` checks before using context in async functions (prevents using BuildContext after widget disposal)
