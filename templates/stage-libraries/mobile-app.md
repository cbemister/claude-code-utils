# Stage Library: Mobile App (React Native / Flutter)

> **Reference material for the project-planner agent.**
> Use this file when generating stage plans for native mobile applications built with
> React Native (Expo or bare workflow) or Flutter. Covers the full lifecycle from
> blank project to App Store / Google Play submission.

---

## Archetype Overview

Mobile apps in this category target iOS and Android from a shared codebase. They
communicate with a backend API (typically the app's own REST or GraphQL API), persist
data locally for offline use, and use the device's native capabilities (camera, push
notifications, biometrics, location). The deployment target is the App Store and
Google Play Store, with OTA updates via Expo Updates or CodePush for React Native.

Key characteristics:
- Single codebase for iOS and Android (React Native or Flutter)
- Navigation via React Navigation (stack, tabs, drawer) or GoRouter (Flutter)
- State management: Zustand / Redux Toolkit / Riverpod / BLoC
- API client layer (React Query + Axios, or Dio + Retrofit)
- Secure token storage (expo-secure-store or flutter_secure_storage)
- Push notifications via Expo Notifications or Firebase Cloud Messaging
- Local database for offline: SQLite (expo-sqlite, sqflite) or Realm

---

## Typical Stage Progression

### Stage 1 — Foundation

**Goal:** App builds and runs on simulator for both platforms; tooling and CI configured.

**Key Deliverables:**
- Project initialized (Expo with TypeScript, or Flutter with Dart)
- Both iOS and Android simulators running the app
- TypeScript strict mode (React Native) or strong typing enabled (Flutter)
- Linting and formatting configured
- Environment variable strategy (`.env` with `expo-constants` or `--dart-define`)
- Basic CI pipeline building both platforms on every push

**Typical Tasks:**
- Initialize project with Expo CLI or `flutter create`
- Configure TypeScript strict mode or Dart analysis options
- Add ESLint + Prettier (or `dart format` + `flutter analyze`)
- Configure environment variable loading
- Verify builds on iOS simulator and Android emulator
- Set up GitHub Actions building both platforms
- Write README with local setup steps

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Project scaffold and tooling |
| Review | `mobile-designer` | Verifies platform conventions are followed |

---

### Stage 2 — Navigation

**Goal:** All screens defined as placeholders; navigation between them works correctly.

**Key Deliverables:**
- Navigation library installed (React Navigation or GoRouter)
- All app screens created as empty placeholder components
- Navigation structure matches UX design: tab bar, stack, drawer
- Deep link URL scheme registered
- Navigation types defined (typed params for every route)
- Back navigation, header configuration, and tab bar icons working

**Typical Tasks:**
- Install and configure navigation library
- Define navigation type declarations (React Navigation TypeScript config)
- Create placeholder screen components for every screen
- Build tab bar navigator with icons
- Build stack navigators for each tab/flow
- Configure deep link URL scheme in app config
- Test navigation on both platforms

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Navigation setup and screen scaffolding |
| Support | `mobile-designer` | Navigation UX review (gestures, transitions) |

---

### Stage 3 — Core Screens

**Goal:** Every screen built to full visual fidelity with static/mock data.

**Key Deliverables:**
- All screens implemented with real UI (no placeholder text)
- Platform-specific styling where needed (iOS vs. Android patterns)
- Responsive layout handling different screen sizes and orientations
- Keyboard avoidance configured for form screens
- Safe area insets handled on all screens
- Design system established: colors, typography, spacing constants

**Typical Tasks:**
- Build design system constants file (colors, spacing, typography)
- Build reusable UI components (Button, Input, Card, Avatar, etc.)
- Implement each screen with static/mock data
- Handle keyboard avoidance on form screens
- Add safe area insets (top notch, bottom home indicator)
- Test on multiple device sizes
- Test on both iOS and Android

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `component-builder` | Screen implementations and shared components |
| Support | `mobile-designer` | Platform-specific styling and UX patterns |
| Review | `ui-ux-designer` | Visual design quality review |

---

### Stage 4 — Data Layer and API Client

**Goal:** App communicates with backend API; data flows from server to screens.

**Key Deliverables:**
- API client configured (Axios instance or Dio with base URL, interceptors, timeout)
- Authentication interceptor attaching bearer token to every request
- React Query or Riverpod configured for server state management
- All API endpoints wrapped in typed query/mutation hooks or service methods
- Loading, error, and empty states handled in every data-driven screen
- Local state management configured (Zustand store or BLoC)

**Typical Tasks:**
- Configure API client with base URL and timeout
- Add auth token interceptor (attach token, refresh on 401)
- Configure React Query (queryClient) or Riverpod providers
- Create query hooks for each API resource
- Create mutation hooks for create/update/delete operations
- Replace static mock data with real API calls on each screen
- Handle loading skeleton and error states per screen

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `api-developer` | API client setup, query hooks |
| Support | `feature-builder` | Wires API hooks into screen components |

---

### Stage 5 — Authentication

**Goal:** Users can sign up, sign in, and stay signed in across app restarts.

**Key Deliverables:**
- Sign-in and sign-up screens wired to API
- JWT stored securely (expo-secure-store or flutter_secure_storage)
- Token refresh logic handling expired tokens without sign-out
- Auth state persisted across app restarts (no re-login on cold start)
- Protected navigation: unauthenticated users redirected to auth flow
- Sign-out clears token and resets navigation to auth screen

**Typical Tasks:**
- Build sign-in screen with form validation
- Build sign-up screen with form validation
- Store JWT in secure storage after sign-in
- Create auth context or store tracking auth state
- Add root navigation split: auth stack vs. app stack
- Implement token refresh (silent re-auth on 401)
- Implement sign-out (clear secure storage, reset navigation)
- Test token persistence across cold app restart

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Auth screens and token management |
| Support | `api-developer` | Token refresh interceptor |

---

### Stage 6 — Native Features

**Goal:** Platform-specific capabilities (camera, push notifications, location, etc.) integrated.

**Key Deliverables:**
- Permissions requested at the right moment (not on app launch)
- Camera access working for photo capture or barcode scanning
- Push notification tokens registered with backend
- Background notification handling (tap to navigate)
- Any additional native features required: location, biometrics, contacts, etc.
- Permissions tested on both iOS (Info.plist strings) and Android (AndroidManifest)

**Typical Tasks:**
- Configure permission usage descriptions in app config
- Implement camera feature (expo-camera or camera_android_camerax)
- Register push notification token with backend on sign-in
- Handle foreground and background push notification routing
- Implement location access if required
- Implement biometric auth if required
- Test each native feature on a physical device

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Native feature integration |
| Support | `mobile-designer` | Platform UX patterns for permissions and native UI |

---

### Stage 7 — Offline Support

**Goal:** App degrades gracefully without network; critical data available offline.

**Key Deliverables:**
- Local database set up (expo-sqlite, sqflite, or Realm)
- Critical data cached to local database after fetch
- Screens render cached data when offline
- Mutations queued when offline and synced when reconnected
- Network status indicator shown to user when offline
- Cache invalidation strategy documented

**Typical Tasks:**
- Install and configure local database
- Define local schema mirroring critical API data
- Write cache-on-fetch logic for high-value queries
- Implement offline fallback for screens
- Implement optimistic mutation with queue for offline writes
- Add network status detection and UI indicator
- Test offline mode in airplane mode on physical device

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Local database setup and offline logic |
| Support | `api-developer` | Sync strategy and conflict resolution |

---

### Stage 8 — Polish

**Goal:** App is production-quality: smooth animations, correct accessibility, no visual bugs.

**Key Deliverables:**
- Screen transitions and list animations feel native
- All interactive elements have correct tap feedback
- Accessibility labels on all interactive elements
- Dynamic text size support (system font scaling respected)
- App handles keyboard overlap, rotation, and split-screen correctly
- No memory leaks (event listeners cleaned up)
- App icon and splash screen finalized

**Typical Tasks:**
- Add animated list skeletons
- Add haptic feedback on key actions
- Audit accessibility labels (VoiceOver / TalkBack)
- Test dynamic text size scaling
- Test landscape orientation (or lock to portrait if intended)
- Add custom app icon and splash screen assets
- Run Expo Doctor or flutter analyze for remaining issues

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `component-builder` | Animation and interaction polish |
| Support | `mobile-designer` | Platform UX polish review |
| Review | `ui-ux-designer` | Final visual and accessibility review |

---

### Stage 9 — Store Submission

**Goal:** App submitted to App Store and Google Play and passing review.

**Key Deliverables:**
- Production build created for both platforms (EAS Build or `flutter build`)
- App signing certificates and keystores configured
- App Store Connect and Google Play Console entries configured
- Screenshots, app description, and metadata submitted
- TestFlight / internal track testing completed
- Privacy policy URL in store listing
- App approved and live (or staged for release)

**Typical Tasks:**
- Configure EAS Build production profile or Flutter release build
- Set up iOS signing certificates in EAS or Xcode
- Set up Android keystore for release signing
- Create App Store Connect listing (screenshots, description, keywords)
- Create Google Play Console listing
- Submit to TestFlight internal testing
- Submit to Google Play internal track
- Address any App Store review issues
- Release to production

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Build configuration and store submission |
| Review | `codebase-explorer` | Verifies no debug flags or test credentials in production build |

---

## Common Parallelization Patterns

```
Stage 1 (Foundation) — must complete first
        ↓
Stage 2 (Navigation) — must complete before screens
        ↓
Stage 3 (Core Screens) ─────────────────────────────────┐
Stage 4 (Data Layer / API Client) ──────────────────────┤── can overlap
        ↓                                               │
        └───── both required ────────────────────────────┘
                        ↓
Stage 5 (Auth) — requires API client
        ↓
Stage 6 (Native Features) ──────────────────────────────┐
Stage 7 (Offline Support) ──────────────────────────────┤── can run in parallel
        ↓                                               │
        └──────── both required ─────────────────────────┘
                        ↓
Stage 8 (Polish) — requires all features complete
        ↓
Stage 9 (Store Submission)
```

Within Stage 3, individual screens can be built in parallel by separate agents.
Within Stage 6, different native features (camera, push, location) can be built in parallel.

---

## Technology-Specific Verification Commands

```bash
# React Native / Expo

# TypeScript check
npx tsc --noEmit

# Lint
npx eslint src/ --ext .ts,.tsx

# Run tests
npx jest --watchAll=false

# Expo Doctor (checks config and dependencies)
npx expo-doctor

# Build for iOS simulator (Expo)
npx expo run:ios

# Build for Android emulator (Expo)
npx expo run:android

# Production build (EAS)
eas build --platform all --profile production

# OTA update
eas update --branch production

# ---

# Flutter

# Analyze
flutter analyze

# Test
flutter test --coverage

# Build iOS (release)
flutter build ios --release

# Build Android APK (release)
flutter build apk --release

# Build Android App Bundle
flutter build appbundle

# Run on connected device
flutter run --release

# Check for outdated dependencies
flutter pub outdated
```

---

## Common Stage Dependencies

| Stage | Hard Requires | Can Parallelize With |
|-------|---------------|----------------------|
| Foundation | nothing | — |
| Navigation | Foundation | — |
| Core Screens | Navigation | Data Layer (build screens with mocks first) |
| Data Layer/API | Foundation | Core Screens |
| Auth | Data Layer | — |
| Native Features | Auth | Offline Support |
| Offline Support | Data Layer, Auth | Native Features |
| Polish | Native Features, Offline Support | — |
| Store Submission | Polish | — |

**Platform-specific decisions to document early:**
- iOS minimum deployment target (typically iOS 16+)
- Android minimum SDK version (typically API 26 / Android 8)
- Orientation lock (portrait-only, landscape-only, or adaptive)
- Tablet support (yes/no)
- RTL language support required (yes/no)
