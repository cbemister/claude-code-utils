# [App Name] - Project Documentation

## Overview
[Brief description of what this React Native app does and its primary purpose]

## Tech Stack
- **React Native** with **Expo SDK** [version, e.g., 51+]
- **TypeScript** with strict mode
- **Expo Router** for file-based navigation
- **NativeWind** for Tailwind-style utility classes (or StyleSheet API)
- **React Query (TanStack Query)** for server state and data fetching
- **Zustand** for client-side state management
- **Zod** for runtime validation
- **Expo EAS** for builds and OTA updates

## Project Structure
```
app/
├── (tabs)/                    # Tab navigator screens
│   ├── index.tsx              # Home tab
│   ├── explore.tsx            # Explore tab
│   └── _layout.tsx            # Tab bar configuration
├── (auth)/                    # Auth flow screens
│   ├── login.tsx
│   └── register.tsx
├── [id].tsx                   # Dynamic routes
├── +not-found.tsx             # 404 screen
└── _layout.tsx                # Root layout (fonts, providers)

components/
├── common/                    # Reusable UI components
│   ├── Button.tsx
│   ├── Input.tsx
│   └── Card.tsx
├── layout/                    # Layout components
│   └── ScreenWrapper.tsx
└── [feature]/                 # Feature-specific components

hooks/
├── useColorScheme.ts          # Dark/light mode
├── useAuth.ts                 # Auth state hook
└── use[Feature].ts            # Feature hooks

services/
├── api.ts                     # Axios/fetch client setup
├── auth.ts                    # Auth API calls
└── [resource].ts              # Resource-specific API calls

stores/
├── authStore.ts               # Zustand auth store
└── [feature]Store.ts          # Feature stores

types/
└── index.ts                   # Shared TypeScript types

utils/
├── formatters.ts              # Date, number, string formatters
└── validators.ts              # Zod schemas

constants/
├── Colors.ts                  # Theme color tokens
└── Layout.ts                  # Spacing, screen dimensions

assets/
├── fonts/
└── images/
```

## Navigation (Expo Router)

### Root Layout
```typescript
// app/_layout.tsx
import { Stack } from 'expo-router';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useFonts } from 'expo-font';
import * as SplashScreen from 'expo-splash-screen';

const queryClient = new QueryClient();

SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const [loaded] = useFonts({
    SpaceMono: require('../assets/fonts/SpaceMono-Regular.ttf'),
  });

  useEffect(() => {
    if (loaded) SplashScreen.hideAsync();
  }, [loaded]);

  if (!loaded) return null;

  return (
    <QueryClientProvider client={queryClient}>
      <Stack>
        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
        <Stack.Screen name="(auth)" options={{ headerShown: false }} />
        <Stack.Screen name="+not-found" />
      </Stack>
    </QueryClientProvider>
  );
}
```

### Programmatic Navigation
```typescript
import { router } from 'expo-router';

// Push screen
router.push('/profile/123');

// Replace current screen
router.replace('/(auth)/login');

// Go back
router.back();

// Navigate with params
router.push({ pathname: '/details/[id]', params: { id: '42' } });
```

## Data Fetching (React Query)

### Query Hook Pattern
```typescript
// hooks/useItems.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { itemsService } from '@/services/items';

export function useItems() {
  return useQuery({
    queryKey: ['items'],
    queryFn: itemsService.getAll,
  });
}

export function useCreateItem() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: itemsService.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['items'] });
    },
  });
}
```

### Service Layer
```typescript
// services/items.ts
import { api } from './api';
import { Item, CreateItemInput } from '@/types';

export const itemsService = {
  getAll: (): Promise<Item[]> => api.get('/items').then(r => r.data),
  getById: (id: string): Promise<Item> => api.get(`/items/${id}`).then(r => r.data),
  create: (data: CreateItemInput): Promise<Item> => api.post('/items', data).then(r => r.data),
  update: (id: string, data: Partial<Item>): Promise<Item> =>
    api.patch(`/items/${id}`, data).then(r => r.data),
  delete: (id: string): Promise<void> => api.delete(`/items/${id}`).then(() => undefined),
};
```

## State Management (Zustand)

### Store Pattern
```typescript
// stores/authStore.ts
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';

interface AuthState {
  user: User | null;
  token: string | null;
  setUser: (user: User | null) => void;
  setToken: (token: string | null) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      token: null,
      setUser: (user) => set({ user }),
      setToken: (token) => set({ token }),
      logout: () => set({ user: null, token: null }),
    }),
    {
      name: 'auth-storage',
      storage: createJSONStorage(() => AsyncStorage),
    }
  )
);
```

## Component Patterns

### Screen Component
```typescript
// app/(tabs)/index.tsx
import { View, FlatList, ActivityIndicator } from 'react-native';
import { useItems } from '@/hooks/useItems';
import { ItemCard } from '@/components/items/ItemCard';
import { ThemedText } from '@/components/common/ThemedText';

export default function HomeScreen() {
  const { data: items, isLoading, error } = useItems();

  if (isLoading) return <ActivityIndicator style={{ flex: 1 }} />;
  if (error) return <ThemedText>Something went wrong.</ThemedText>;

  return (
    <FlatList
      data={items}
      keyExtractor={(item) => item.id}
      renderItem={({ item }) => <ItemCard item={item} />}
      contentContainerStyle={{ padding: 16 }}
    />
  );
}
```

### Reusable Component
```typescript
// components/common/Button.tsx
import { Pressable, Text, StyleSheet } from 'react-native';

interface ButtonProps {
  label: string;
  onPress: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
}

export function Button({ label, onPress, variant = 'primary', disabled }: ButtonProps) {
  return (
    <Pressable
      style={[styles.base, styles[variant], disabled && styles.disabled]}
      onPress={onPress}
      disabled={disabled}
    >
      <Text style={styles.label}>{label}</Text>
    </Pressable>
  );
}
```

## Styling

### NativeWind (Tailwind-style)
```typescript
import { View, Text } from 'react-native';

export function Card({ title }: { title: string }) {
  return (
    <View className="bg-white rounded-2xl p-4 shadow-md">
      <Text className="text-lg font-semibold text-gray-900">{title}</Text>
    </View>
  );
}
```

### StyleSheet API
```typescript
const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    padding: 16,
  },
  heading: {
    fontSize: 24,
    fontWeight: '700',
    color: '#111827',
  },
});
```

## Environment Variables
Create `.env` (use `expo-constants` or `react-native-dotenv`):
```bash
EXPO_PUBLIC_API_URL=https://api.example.com
EXPO_PUBLIC_APP_ENV=development
```

Access in code:
```typescript
const apiUrl = process.env.EXPO_PUBLIC_API_URL;
```

## Key Files
| Purpose | File |
|---------|------|
| Types | `types/index.ts` |
| API client | `services/api.ts` |
| Auth store | `stores/authStore.ts` |
| Color tokens | `constants/Colors.ts` |
| Root layout | `app/_layout.tsx` |

## Commands
```bash
npx expo start              # Start Metro bundler
npx expo start --clear      # Start with cleared cache
npx expo run:ios            # Build and run on iOS simulator
npx expo run:android        # Build and run on Android emulator
npx expo install            # Install Expo-compatible package versions

eas build --platform ios    # EAS cloud build for iOS
eas build --platform android  # EAS cloud build for Android
eas update                  # Publish OTA update

npx tsc --noEmit            # TypeScript type check
npx expo lint               # Run ESLint
```

## Code Style

### TypeScript
- Strict mode enabled in `tsconfig.json`
- Use interfaces for props and data models
- Path aliases configured: `@/` maps to project root

### Components
- One component per file, named export
- Props interface defined above component
- Platform-specific files use `.ios.tsx` / `.android.tsx` extensions

### Performance
- Use `useCallback` and `useMemo` for stable references passed to lists
- Prefer `FlatList` over `ScrollView` for long lists
- Use `React.memo` for pure list item components

---

## Notes
[Any additional project-specific notes, native module setup, or important information]

## Resources
- [Expo Documentation](https://docs.expo.dev/)
- [Expo Router Documentation](https://expo.github.io/router/docs)
- [React Query Documentation](https://tanstack.com/query/latest)
- [Zustand Documentation](https://docs.pmnd.rs/zustand/getting-started/introduction)
- [NativeWind Documentation](https://www.nativewind.dev/)
