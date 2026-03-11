# [App Name] - Project Documentation

## Overview
[Brief description of what this Flutter app does and its primary purpose]

## Tech Stack
- **Flutter** [version, e.g., 3.22+] with **Dart** [version, e.g., 3.4+]
- **Material 3** design system
- **Riverpod** for state management and dependency injection
- **Dio** for HTTP networking
- **go_router** for declarative navigation
- **Freezed** for immutable data classes and unions
- **json_serializable** for JSON serialization
- **flutter_secure_storage** for secure token storage

## Project Structure
```
lib/
├── main.dart                  # App entry point
├── app.dart                   # MaterialApp, router, providers setup
├── core/
│   ├── config/
│   │   └── app_config.dart    # Environment configuration
│   ├── network/
│   │   ├── dio_client.dart    # Dio instance and interceptors
│   │   └── api_exception.dart
│   ├── router/
│   │   └── app_router.dart    # go_router configuration
│   ├── theme/
│   │   ├── app_theme.dart     # Material 3 theme
│   │   └── app_colors.dart    # Color tokens
│   └── utils/
│       ├── formatters.dart
│       └── validators.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── auth_repository.dart
│   │   │   └── models/
│   │   ├── domain/
│   │   │   └── auth_state.dart
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       └── auth_provider.dart
│   └── [feature]/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── shared/
    ├── widgets/               # Reusable UI components
    │   ├── app_button.dart
    │   ├── app_text_field.dart
    │   └── loading_indicator.dart
    └── extensions/            # Dart extension methods
        └── context_extensions.dart

test/
├── unit/
├── widget/
└── integration/
```

## App Entry Point

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
```

```dart
// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: '[App Name]',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
```

## Navigation (go_router)

```dart
// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isLoggedIn && !isAuthRoute) return '/auth/login';
      if (isLoggedIn && isAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/items/:id',
        builder: (context, state) =>
            ItemDetailScreen(id: state.pathParameters['id']!),
      ),
    ],
  );
}

// Navigate programmatically
// context.go('/items/123');
// context.push('/settings');
// context.pop();
```

## State Management (Riverpod)

### Provider Pattern
```dart
// features/items/presentation/items_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/items_repository.dart';

part 'items_provider.g.dart';

@riverpod
class Items extends _$Items {
  @override
  Future<List<Item>> build() async {
    return ref.watch(itemsRepositoryProvider).getAll();
  }

  Future<void> create(CreateItemInput input) async {
    await ref.read(itemsRepositoryProvider).create(input);
    ref.invalidateSelf();
  }
}
```

### Consuming State in Widgets
```dart
class ItemsScreen extends ConsumerWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsProvider);

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => ItemTile(item: items[index]),
      ),
    );
  }
}
```

## Data Layer

### Repository Pattern
```dart
// features/items/data/items_repository.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_client.dart';

part 'items_repository.g.dart';

@riverpod
ItemsRepository itemsRepository(ItemsRepositoryRef ref) {
  return ItemsRepository(ref.watch(dioClientProvider));
}

class ItemsRepository {
  const ItemsRepository(this._client);
  final Dio _client;

  Future<List<Item>> getAll() async {
    final response = await _client.get<List<dynamic>>('/items');
    return response.data!.map((j) => Item.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<Item> create(CreateItemInput input) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/items',
      data: input.toJson(),
    );
    return Item.fromJson(response.data!);
  }
}
```

### Freezed Data Classes
```dart
// features/items/data/models/item.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
class Item with _$Item {
  const factory Item({
    required String id,
    required String title,
    String? description,
    required DateTime createdAt,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
```

## HTTP Client (Dio)

```dart
// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

@riverpod
Dio dioClient(DioClientRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await SecureStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          ref.read(authStateProvider.notifier).logout();
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}
```

## Shared Widgets

```dart
// lib/shared/widgets/app_button.dart
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
        : Text(label);

    return switch (variant) {
      AppButtonVariant.primary => FilledButton(onPressed: isLoading ? null : onPressed, child: child),
      AppButtonVariant.secondary => OutlinedButton(onPressed: isLoading ? null : onPressed, child: child),
    };
  }
}

enum AppButtonVariant { primary, secondary }
```

## Environment Variables

```dart
// lib/core/config/app_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';

  static String get appEnv =>
      dotenv.env['APP_ENV'] ?? 'development';

  static bool get isProduction => appEnv == 'production';
}
```

Create `.env`:
```bash
API_BASE_URL=https://api.example.com
APP_ENV=development
```

## Key Files
| Purpose | File |
|---------|------|
| App entry | `lib/main.dart` |
| Router | `lib/core/router/app_router.dart` |
| HTTP client | `lib/core/network/dio_client.dart` |
| Theme | `lib/core/theme/app_theme.dart` |
| Shared widgets | `lib/shared/widgets/` |

## Commands
```bash
flutter run                   # Run on connected device/emulator
flutter run -d chrome         # Run as web app
flutter run --release         # Run in release mode

flutter build apk             # Build Android APK
flutter build appbundle       # Build Android App Bundle
flutter build ios             # Build iOS (requires Mac)

flutter test                  # Run all tests
flutter test test/unit/       # Run unit tests only
flutter test --coverage       # Run with coverage report

dart analyze                  # Static analysis
dart format .                 # Format all Dart files

flutter pub get               # Install dependencies
flutter pub upgrade           # Upgrade dependencies
flutter pub run build_runner build     # Generate code (Freezed, Riverpod)
flutter pub run build_runner watch     # Watch and regenerate on change
```

## Code Style

### Dart Conventions
- Use `const` constructors wherever possible
- Prefer named parameters for clarity
- Use `final` for all local variables unless mutation is needed
- Follow Effective Dart guidelines

### Widget Structure
- Prefer `ConsumerWidget` over `StatefulWidget` when state is in Riverpod
- Extract widgets into separate classes when they exceed ~50 lines
- Use `Key` parameters on list items and rebuilding widgets

### Code Generation
Run after modifying `@freezed`, `@riverpod`, or `@JsonSerializable` classes:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Notes
[Any additional project-specific notes, platform-specific setup, or important information]

## Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/docs/introduction/getting_started)
- [go_router Documentation](https://pub.dev/packages/go_router)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Dio Documentation](https://pub.dev/packages/dio)
