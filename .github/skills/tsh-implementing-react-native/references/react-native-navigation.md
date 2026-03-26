# React Native Navigation Patterns

Navigation-specific patterns for the `tsh-implementing-react-native` skill. Load this reference when implementing screen navigation, deep linking, or route structure in React Native.

## Table of Contents

- [Navigation Libraries](#navigation-libraries)
- [Screen Organization](#screen-organization)
- [React Navigation Patterns](#react-navigation-patterns)
- [Expo Router Patterns](#expo-router-patterns)
- [Deep Linking](#deep-linking)
- [Navigation State and TypeScript](#navigation-state-and-typescript)
- [Anti-Patterns](#anti-patterns)

## Navigation Libraries

**Expo Router is the standard** for all Expo projects. It provides file-based routing (like Next.js), automatic deep linking, typed routes, and web parity with zero configuration.

| Library              | Routing Model | When to use                                                |
| -------------------- | ------------- | ---------------------------------------------------------- |
| Expo Router 4+       | File-based    | **Default** — all new Expo projects                        |
| React Navigation 7+  | Imperative    | Legacy projects already using it (do not migrate mid-project) |

Expo Router is built on top of React Navigation, so all React Navigation primitives (native-stack, tabs, drawers) work under the hood. The patterns below for React Navigation are included for projects that already use it — for new code, always use Expo Router.

Do not mix both in the same project.

> **React Navigation 7 note**: React Navigation 7 introduced a **static API** alongside the existing dynamic API. The static API uses `createNativeStackNavigator({ screens: { ... } })` with screen configuration objects instead of JSX `<Stack.Screen>` elements. Both APIs are supported — match the project's existing pattern. The examples in this reference use the dynamic (JSX) API as it's more widely adopted. If the project uses the static API, adapt accordingly.

## Screen Organization

### File-based routing (Expo Router)

```
app/
├── _layout.tsx              # Root layout (providers, fonts, splash)
├── index.tsx                # Home / entry screen
├── (auth)/                  # Auth route group (not shown in URL)
│   ├── _layout.tsx          # Auth stack layout
│   ├── sign-in.tsx
│   └── sign-up.tsx
├── (tabs)/                  # Tab group
│   ├── _layout.tsx          # Tab bar configuration
│   ├── home.tsx
│   ├── search.tsx
│   └── profile.tsx
├── settings/
│   ├── index.tsx            # /settings
│   ├── notifications.tsx    # /settings/notifications
│   └── [id].tsx             # /settings/:id (dynamic segment)
└── +not-found.tsx           # 404 catch-all
```

### Imperative routing (React Navigation)

```
src/
├── navigation/
│   ├── RootNavigator.tsx     # Entry: auth check → AuthStack or MainTabs
│   ├── AuthStack.tsx         # Sign in, sign up, forgot password
│   ├── MainTabs.tsx          # Bottom tab navigator
│   ├── HomeStack.tsx         # Stack within the Home tab
│   ├── ProfileStack.tsx      # Stack within the Profile tab
│   └── types.ts              # All route param types
├── screens/
│   ├── auth/
│   │   ├── SignInScreen.tsx
│   │   └── SignUpScreen.tsx
│   ├── home/
│   │   ├── HomeScreen.tsx
│   │   └── DetailScreen.tsx
│   └── profile/
│       ├── ProfileScreen.tsx
│       └── SettingsScreen.tsx
```

## React Navigation Patterns

### Navigator composition

React Navigation uses a nested navigator model. Common structure:

```typescript
// RootNavigator.tsx
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

const Stack = createNativeStackNavigator<RootStackParamList>();

const RootNavigator = () => (
  <NavigationContainer>
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      {isAuthenticated ? (
        <Stack.Screen name="Main" component={MainTabs} />
      ) : (
        <Stack.Screen name="Auth" component={AuthStack} />
      )}
      {/* Modal screens accessible from anywhere */}
      <Stack.Group screenOptions={{ presentation: 'modal' }}>
        <Stack.Screen name="CreatePost" component={CreatePostScreen} />
      </Stack.Group>
    </Stack.Navigator>
  </NavigationContainer>
);
```

### Native stack

Always use `@react-navigation/native-stack` (not `@react-navigation/stack`). Native stack uses platform-native navigation transitions (UINavigationController on iOS, Fragment on Android) for better performance and native feel.

### Typed navigation

Define param types for all routes and pass them as generics to navigators and hooks:

```typescript
// navigation/types.ts
type RootStackParamList = {
  Main: undefined;
  Auth: undefined;
  CreatePost: undefined;
};

type HomeStackParamList = {
  Home: undefined;
  Detail: { id: string; title: string };
  Search: { query?: string };
};

// In screens — typed navigation hook
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';

type HomeScreenNavProp = NativeStackNavigationProp<HomeStackParamList, 'Home'>;

const HomeScreen = () => {
  const navigation = useNavigation<HomeScreenNavProp>();

  const handlePress = (item: Item) => {
    navigation.navigate('Detail', { id: item.id, title: item.title });
  };
};
```

### Screen options

Configure headers and tabs declaratively via `screenOptions`:

```typescript
const MainTabs = () => (
  <Tab.Navigator
    screenOptions={({ route }) => ({
      tabBarIcon: ({ focused, color, size }) => {
        const icon = tabIcons[route.name];
        return <Icon name={icon} size={size} color={color} />;
      },
      tabBarActiveTintColor: theme.colors.primary500,
      tabBarInactiveTintColor: theme.colors.textSecondary,
      headerShown: false,
    })}
  >
    <Tab.Screen name="Home" component={HomeStack} />
    <Tab.Screen name="Search" component={SearchStack} />
    <Tab.Screen name="Profile" component={ProfileStack} />
  </Tab.Navigator>
);
```

## Expo Router Patterns

### Layouts

Layouts define the navigation structure for a route group:

```typescript
// app/(tabs)/_layout.tsx
import { Tabs } from 'expo-router';

const TabLayout = () => (
  <Tabs
    screenOptions={{
      tabBarActiveTintColor: theme.colors.primary500,
      headerShown: false,
    }}
  >
    <Tabs.Screen
      name="home"
      options={{
        title: 'Home',
        tabBarIcon: ({ color, size }) => <Icon name="home" size={size} color={color} />,
      }}
    />
    <Tabs.Screen
      name="profile"
      options={{
        title: 'Profile',
        tabBarIcon: ({ color, size }) => <Icon name="user" size={size} color={color} />,
      }}
    />
  </Tabs>
);

export default TabLayout;
```

Note: Expo Router layout files use `export default` — this is the one exception to the "named exports only" rule, as the file-based router requires default exports.

### Typed routes

Expo Router generates route types from the file structure automatically. Enable typed routes in `tsconfig.json`:

```json
{
  "compilerOptions": {
    "strict": true
  },
  "include": [".expo/types/**/*.ts", "**/*.ts", "**/*.tsx"]
}
```

This gives you compile-time route validation — `router.push()` and `<Link href>` only accept valid routes:

```typescript
import { useRouter, useLocalSearchParams, Link } from 'expo-router';

const DetailScreen = () => {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();

  const handleBack = () => router.back();
  // Typed — TypeScript errors if route doesn't exist
  const handleNavigate = () => router.push('/settings/notifications');

  // In JSX — href is also type-checked
  return <Link href={{ pathname: '/detail/[id]', params: { id: '123' } }}>Go</Link>;
};
```

### Route groups

Group routes with parentheses `(groupName)` to organize without affecting the URL:

- `(auth)/` — Authentication screens grouped together, using a stack layout
- `(tabs)/` — Tab-based screens grouped together, using a tab layout
- `(settings)/` — Settings-related screens grouped, sharing a common header

### Modal routes

Present screens as modals by configuring the layout:

```typescript
// app/_layout.tsx
<Stack>
  <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
  <Stack.Screen name="modal" options={{ presentation: 'modal' }} />
</Stack>
```

## Deep Linking

### Expo Router

Deep linking is automatic. The file path IS the URL. A file at `app/settings/[id].tsx` responds to `myapp://settings/123` with zero configuration.

Configure the URL scheme in `app.json`:

```json
{
  "expo": {
    "scheme": "myapp"
  }
}
```

For universal links (HTTPS links that open the app), configure `intentFilters` (Android) and `associatedDomains` (iOS) in `app.json`.

### React Navigation

Configure linking in the `NavigationContainer`:

```typescript
const linking: LinkingOptions<RootStackParamList> = {
  prefixes: ['myapp://', 'https://myapp.com'],
  config: {
    screens: {
      Main: {
        screens: {
          Home: 'home',
          Detail: 'detail/:id',
        },
      },
      Auth: {
        screens: {
          SignIn: 'sign-in',
        },
      },
    },
  },
};

<NavigationContainer linking={linking}>
  {/* ... */}
</NavigationContainer>
```

### Deep link testing

Test deep links during development:

```bash
# iOS Simulator
npx uri-scheme open "myapp://detail/123" --ios

# Android Emulator
adb shell am start -a android.intent.action.VIEW -d "myapp://detail/123"

# Expo Go
npx uri-scheme open "exp://127.0.0.1:8081/--/detail/123"
```

## Navigation State and TypeScript

### Navigation-aware data loading

Load screen data in the screen component, triggered by focus:

```typescript
import { useFocusEffect } from '@react-navigation/native'; // or expo-router
import { useCallback } from 'react';

const ProfileScreen = () => {
  const { data, refetch } = useProfile();

  // Refetch when screen comes into focus (e.g., returning from edit screen)
  useFocusEffect(
    useCallback(() => {
      refetch();
    }, [refetch])
  );
};
```

### Preventing navigation with unsaved changes

```typescript
import { usePreventRemove } from '@react-navigation/native';

const EditScreen = () => {
  const [hasUnsavedChanges, setHasUnsavedChanges] = useState(false);

  usePreventRemove(hasUnsavedChanges, ({ data }) => {
    Alert.alert(
      'Discard changes?',
      'You have unsaved changes. Are you sure you want to leave?',
      [
        { text: 'Stay', style: 'cancel' },
        { text: 'Discard', style: 'destructive', onPress: () => data.action() },
      ]
    );
  });
};
```

### Screen tracking / analytics

Centralize screen tracking at the navigator level:

```typescript
// React Navigation
<NavigationContainer
  onStateChange={(state) => {
    const currentRoute = getActiveRouteName(state);
    analytics.trackScreen(currentRoute);
  }}
>
```

```typescript
// Expo Router — use the pathname hook
import { usePathname } from 'expo-router';

// In root layout
const pathname = usePathname();
useEffect(() => {
  analytics.trackScreen(pathname);
}, [pathname]);
```

## Anti-Patterns

| Anti-Pattern                                    | Why                                                   | Fix                                                     |
| ----------------------------------------------- | ----------------------------------------------------- | ------------------------------------------------------- |
| `@react-navigation/stack` (JS-based stack)      | JS-driven transitions, slower than native              | Use `@react-navigation/native-stack`                    |
| Untyped `navigation.navigate('Screen')`         | No param validation, runtime crashes                   | Define `ParamList` types, use typed hooks                |
| Nesting 4+ navigators deep                      | Complex state, hard to reason about, slow transitions  | Flatten: use groups and modal presentations              |
| Fetching data in `useEffect` without focus check | Stale data when returning to screen                   | Use `useFocusEffect` for screen data that can go stale  |
| Passing large objects as route params            | Serialized into navigation state, memory overhead      | Pass IDs only, fetch data in the destination screen     |
| `navigation.reset()` for logout                 | Leaves screens in memory, animations break             | Conditional rendering in root navigator based on auth   |
| Mixing Expo Router and React Navigation          | Conflicting navigation states, unpredictable behavior | Pick one and use it exclusively                          |
| Default export for non-layout components         | Inconsistent imports, harder refactoring              | Named exports (except Expo Router `_layout.tsx` files)  |
| Hardcoded screen names as strings everywhere     | Typo-prone, no refactoring support                    | Use route name constants or typed navigation             |
| Custom modal via `View` overlay                  | No native transition, no gesture dismissal, a11y gaps | Use `presentation: 'modal'` in stack or `@gorhom/bottom-sheet` |

## Bottom Sheet Pattern

`@gorhom/bottom-sheet` is the standard library for bottom sheet navigation in React Native. It integrates with Reanimated and Gesture Handler for native-quality 60 fps interactions.

```typescript
import BottomSheet from '@gorhom/bottom-sheet';
import { useCallback, useMemo, useRef } from 'react';

const FilterSheet = () => {
  const bottomSheetRef = useRef<BottomSheet>(null);
  const snapPoints = useMemo(() => ['25%', '50%', '90%'], []);

  const handleOpen = useCallback(() => {
    bottomSheetRef.current?.expand();
  }, []);

  return (
    <BottomSheet
      ref={bottomSheetRef}
      snapPoints={snapPoints}
      enablePanDownToClose
      index={-1}  // Start closed
    >
      {/* Sheet content */}
    </BottomSheet>
  );
};
```

Key rules:
- Use `@gorhom/bottom-sheet` — not custom `Animated.View` overlays. It handles gesture competition, keyboard avoidance, and accessibility.
- Define `snapPoints` with `useMemo` to avoid re-creating the array on every render.
- Use `index={-1}` to start the sheet closed; control it programmatically via the ref.
- For sheets containing scrollable content, use `BottomSheetScrollView` or `BottomSheetFlatList` instead of standard `ScrollView` / `FlatList` to avoid gesture conflicts.
