# React Native Navigation Patterns

Navigation-specific patterns for the `tsh-implementing-react-native` skill. Load this reference when implementing screen navigation, deep linking, or route structure in React Native. Select the router from the consuming project's manifest, configuration, entry points, and existing conventions before applying any example.

## Table of Contents

- [Target-project router profile](#target-project-router-profile)
- [Navigation Libraries](#navigation-libraries)
- [Screen Organization](#screen-organization)
- [React Navigation Patterns](#react-navigation-patterns)
- [Expo Router Patterns](#expo-router-patterns)
- [Deep Linking](#deep-linking)
- [Navigation State and TypeScript](#navigation-state-and-typescript)
- [Verification Boundary](#verification-boundary)
- [Anti-Patterns](#anti-patterns)

## Target-project router profile

Before choosing a pattern, inspect the target project's `package.json`, app configuration, entry points, route directories, native directories, package-manager scripts, and installed tooling. Record:

- whether the project is Expo managed, Expo prebuild/dev client, or bare React Native;
- the installed React Native, React, Expo SDK, Expo Router, and React Navigation package versions, when present;
- the configured entry point and whether the project uses an `app/` or configured Expo Router directory, a `src/navigation/` tree, or another established convention;
- the JavaScript engine, New Architecture setting, iOS/Android targets, and available simulators, emulators, or web tooling; and
- the installed deep-link, sheet, analytics, and type-generation tooling.

Use the detected profile and the official documentation for those exact installed versions as the authority. If the manifest and source conventions identify one router, preserve it. If both routers appear, inspect the actual entry point and rendered navigation tree; do not infer the active router from a dependency alone. If the router is absent or the evidence is ambiguous, stop for a target-project decision rather than selecting a router, adding a package, or migrating navigation implicitly.

Do not mix Expo Router and an independently configured React Navigation root in one navigation tree unless the target project's documented architecture explicitly supports that arrangement. This reference supports both router paths; neither is a universal default.

## Navigation Libraries

| Router path | Routing model | Apply when |
| --- | --- | --- |
| Expo Router | File-based routes and layouts | The target profile contains a compatible Expo Router installation and its configured route entry/conventions. |
| React Navigation | Navigator composition with dynamic or, when supported by the installed version, static configuration | The target profile uses React Navigation as its active navigation tree, including existing bare React Native projects. |

Keep the project's current router and API style. A new screen should follow the selected router's structure and installed package versions; do not introduce a second router or convert dynamic configuration to static configuration as part of unrelated work.

## Screen Organization

### File-based routing (Expo Router)

Use this structure only when the target profile selects Expo Router and the directory is configured accordingly:

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
└── +not-found.tsx           # 404 catch-all, when supported by the installed version
```

### Navigator composition (React Navigation)

Use this structure only when React Navigation is the active router and matches the project's existing conventions:

```
src/
├── navigation/
│   ├── RootNavigator.tsx     # Entry: auth check -> AuthStack or MainTabs
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

### Export contract by file role

- **Expo Router route files and layout files:** follow the route-module contract documented for the installed Expo Router version and configured route directory. If that version requires a default-exported route or layout component, use that default export. Do not apply this rule to ordinary components imported by the route.
- **React Navigation route screen files and navigator/layout composition files:** React Navigation does not impose a file-based route export contract. Follow the target project's established module convention; in this collection, ordinary screen, navigator, and layout components use named exports unless the target project explicitly requires another contract.
- **Ordinary React Native components in either path:** retain the collection's named-export convention. A route or layout file is an exception only when the selected router's installed version requires it, not because it is a UI component or because the project targets web.

Verify the contract against the consuming project's installed router and official version-specific documentation before changing an export. If it cannot be verified, stop under the Task 1.3 stop rule.

## React Navigation Patterns

Apply these examples only when the target profile selects React Navigation and the referenced packages and APIs are installed and compatible with one another.

### Navigator composition

Use the project's installed native-stack package and existing navigator style. The package name and options below must be checked against the exact installed version:

```typescript
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

type RootStackParamList = {
  Main: undefined;
  Auth: undefined;
  CreatePost: undefined;
};

const Stack = createNativeStackNavigator<RootStackParamList>();

export const RootNavigator = () => (
  <NavigationContainer>
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      {isAuthenticated ? (
        <Stack.Screen name="Main" component={MainTabs} />
      ) : (
        <Stack.Screen name="Auth" component={AuthStack} />
      )}
      <Stack.Group screenOptions={{ presentation: 'modal' }}>
        <Stack.Screen name="CreatePost" component={CreatePostScreen} />
      </Stack.Group>
    </Stack.Navigator>
  </NavigationContainer>
);
```

If the target profile does not have a compatible native-stack package, use the navigator already supported by that project and its official migration guidance. Do not replace an existing navigator solely because this example uses native stack.

### Dynamic and static configuration

The dynamic JSX API and the static configuration API are separate React Navigation API paths. Use the one already used by the target project. Use the static form only when the installed React Navigation packages expose it and the exact installed-version documentation confirms the signature:

```typescript
// Dynamic API: use when the target project uses JSX navigator elements.
const Stack = createNativeStackNavigator<RootStackParamList>();

export const MainStack = () => (
  <Stack.Navigator>
    <Stack.Screen name="Home" component={HomeScreen} />
    <Stack.Screen name="Detail" component={DetailScreen} />
  </Stack.Navigator>
);
```

```typescript
// Static API: use only when the installed version supports this API and syntax.
const RootStack = createNativeStackNavigator({
  screens: {
    Home: HomeScreen,
    Detail: DetailScreen,
  },
});
```

The static example is intentionally not a version guarantee. Check the target manifest and official React Navigation documentation before using it; otherwise keep the project's dynamic configuration.

### Typed navigation

Define route parameters for the selected navigator and use the type helpers exported by the installed React Navigation packages:

```typescript
type HomeStackParamList = {
  Home: undefined;
  Detail: { id: string; title: string };
  Search: { query?: string };
};

import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';

type HomeScreenNavigationProp = NativeStackNavigationProp<HomeStackParamList, 'Home'>;

export const HomeScreen = () => {
  const navigation = useNavigation<HomeScreenNavigationProp>();

  const handlePress = (item: Item) => {
    navigation.navigate('Detail', { id: item.id, title: item.title });
  };
};
```

Use the type helpers and navigator package actually installed. If the project uses the static API or a different navigator, adapt the types to that API's official contract rather than copying this generic.

## Expo Router Patterns

Apply these examples only when the target profile selects Expo Router, the project has a compatible Expo installation, and the configured route directory matches the project convention.

### Layouts and route exports

Expo Router route files and layout files must follow the route-module export contract documented for the installed version. Where that contract requires a default-exported route component, this example uses a default export; verify route screens and layouts individually:

```typescript
import { Tabs } from 'expo-router';

const TabLayout = () => (
  <Tabs
    screenOptions={{
      tabBarActiveTintColor: theme.colors.primary500,
      headerShown: false,
    }}
  >
    <Tabs.Screen name="home" options={{ title: 'Home' }} />
    <Tabs.Screen name="profile" options={{ title: 'Profile' }} />
  </Tabs>
);

export default TabLayout;
```

If the installed version or project configuration specifies another contract, follow that contract. Route files and layouts are router modules; ordinary components imported by them remain named exports.

### Typed and dynamic routes

File-based static and dynamic segments are available only when supported by the installed Expo Router version and enabled by the project configuration. A route such as `settings/[id].tsx` represents a dynamic segment only under that configured file-based router:

```typescript
import { Link, useLocalSearchParams, useRouter } from 'expo-router';

export default function DetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();

  return (
    <>
      <Text>{id}</Text>
      <Button title="Back" onPress={() => router.back()} />
      <Link href={{ pathname: '/settings/[id]', params: { id: '123' } }}>
        Open detail
      </Link>
    </>
  );
}
```

Enable generated typed routes only when the target project's installed Expo Router version supports them and its documented configuration is present. Confirm the generated type location and `Link`/`router` signatures against that version; otherwise use the project's supported route types and runtime validation.

### Route groups

Group routes with parentheses `(groupName)` to organize without affecting the URL when that behavior is supported by the installed file-based router:

- `(auth)/` - authentication screens grouped together, using a stack layout;
- `(tabs)/` - tab-based screens grouped together, using a tab layout; and
- `(settings)/` - settings-related screens grouped together, sharing a common header.

### Modal routes and sheets

For an Expo Router project, configure a modal route through its layout only when the installed router and native navigator support the `presentation` option:

```typescript
import { Stack } from 'expo-router';

export default function RootLayout() {
  return (
    <Stack>
      <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
      <Stack.Screen name="modal" options={{ presentation: 'modal' }} />
    </Stack>
  );
}
```

For a draggable bottom sheet, use a sheet package only if it is already installed and its Reanimated, gesture-handler, React Native, platform, and New Architecture compatibility is confirmed in the target profile. Otherwise use the router's supported modal presentation or the project's existing sheet abstraction; do not add `@gorhom/bottom-sheet` from this reference.

## Deep Linking

Deep linking is a target-project configuration concern. First confirm the selected router, URL scheme or universal/app-link configuration, platform targets, and installed development tools. A browser URL or web route does not prove native deep-link behavior.

### Expo Router

Use file paths as deep-link paths only when the target project has a compatible Expo Router file-based setup and the route is present in its configured route directory. Configure a scheme in the target project's app configuration only when its installed Expo tooling supports that field:

```json
{
  "expo": {
    "scheme": "myapp"
  }
}
```

Universal links or Android app links also require the target project's installed-version platform configuration, associated-domain/intent-filter setup, and native credentials or hosting where applicable. Follow the official Expo and platform documentation for that profile.

### React Navigation

Use `linking` on the target project's `NavigationContainer` only when React Navigation is the active router and the installed packages support the configured linking type:

```typescript
const linking: LinkingOptions<RootStackParamList> = {
  prefixes: ['myapp://', 'https://myapp.example'],
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

Match the `config` tree to the actual nested navigator and use only schemes and domains configured by the target project. Do not add linking configuration or a native URL scheme as part of a collection-only change.

### Platform-specific deep-link commands

Run a deep-link command only when the target profile provides all of the following: the selected router's configuration, a built or running target app, the named platform, and the command-line tool. These are target-project commands, not collection validation:

```bash
# iOS Simulator: requires a booted simulator and an installed uri-scheme tool.
npx uri-scheme open "myapp://detail/123" --ios

# Android Emulator: requires a booted emulator, adb, and an installed app.
adb shell am start -a android.intent.action.VIEW -d "myapp://detail/123"

# Expo development client or Go: use only when the installed Expo workflow
# documents the exp:// URL shape and the target dev server is running.
npx uri-scheme open "exp://127.0.0.1:8081/--/detail/123" --ios
```

The collection does not execute or claim native simulator, emulator, device, or deep-link verification. If the target project lacks the required platform tool or build, record the native check as unavailable or target-project-owned.

## Navigation State and TypeScript

### Navigation-aware data loading

Refresh-on-focus is router- and package-specific. For React Navigation, use `useFocusEffect` only when the installed `@react-navigation/native` version exposes it and the target project uses that lifecycle contract:

```typescript
import { useFocusEffect } from '@react-navigation/native';
import { useCallback } from 'react';

export const ProfileScreen = () => {
  const { data, refetch } = useProfile();

  useFocusEffect(
    useCallback(() => {
      refetch();
    }, [refetch])
  );
};
```

For Expo Router, use the focus hook exported or explicitly supported by the installed Expo Router version, or its documented equivalent. Do not import a hook merely because the project uses Expo. If the selected router has no compatible focus API, use its documented navigation listener or an explicit refresh action; a mount-only effect is not an equivalent focus refresh.

### Preventing navigation with unsaved changes

For React Navigation, use `usePreventRemove` only when the installed package version supports it and the target navigator uses that event contract:

```typescript
import { usePreventRemove } from '@react-navigation/native';

export const EditScreen = () => {
  const [hasUnsavedChanges, setHasUnsavedChanges] = useState(false);

  usePreventRemove(hasUnsavedChanges, ({ data }) => {
    Alert.alert('Discard changes?', 'You have unsaved changes.', [
      { text: 'Stay', style: 'cancel' },
      { text: 'Discard', style: 'destructive', onPress: () => data.action() },
    ]);
  });
};
```

For Expo Router, use the installed version's documented prevention or before-remove mechanism. Do not assume that a React Navigation hook is re-exported by Expo Router; verify the import and compatibility first.

### Screen tracking and analytics

Screen tracking belongs at the selected router's root navigation boundary and must use the analytics client already installed by the target project.

For React Navigation, use `onStateChange` only when the target root owns a `NavigationContainer`:

```typescript
<NavigationContainer
  onStateChange={(state) => {
    const currentRoute = getActiveRouteName(state);
    analytics.trackScreen(currentRoute);
  }}
>
  {/* ... */}
</NavigationContainer>
```

For Expo Router, use the installed version's documented root-layout pathname or navigation-state API, such as `usePathname`, only when that export and the target analytics integration are available:

```typescript
import { usePathname } from 'expo-router';

export default function RootLayout() {
  const pathname = usePathname();

  useEffect(() => {
    analytics.trackScreen(pathname);
  }, [pathname]);

  return <Stack />;
}
```

Respect the target project's consent, redaction, and event naming rules. If no analytics client or selected-router state API is installed, do not add one from this reference; document the integration prerequisite.

## Verification Boundary

The collection can validate Markdown and, for web-compatible artifacts, browser behavior through its existing web/Playwright workflow. It cannot execute or claim native iOS/Android simulator, emulator, device, deep-link, gesture, safe-area, VoiceOver, TalkBack, or native E2E verification. Those checks require target-project-owned builds, devices, accessibility tooling, and evidence. Keep any browser URL, screenshot, or Playwright result scoped to web behavior and do not use it as native navigation evidence.

## Anti-Patterns

| Anti-Pattern | Why | Fix |
| --- | --- | --- |
| Treating Expo Router as the default for every project | The collection has no target application profile and projects may use bare React Native or React Navigation. | Inspect the manifest, configuration, entry point, versions, and conventions; preserve the detected router. |
| Migrating an existing router while adding a screen | Router migration changes route contracts, linking, exports, and native configuration. | Keep the existing router and escalate a migration as a separate target-project decision. |
| Mixing Expo Router and an independent React Navigation root | Two navigation ownership models can create conflicting state and linking behavior. | Use the selected router's supported integration only after checking its installed-version documentation. |
| Using static or dynamic APIs without checking the installed version | API availability and signatures vary by router package version. | Match the project's existing API style and verify alternatives against the exact installed packages. |
| Applying typed-route examples without generated/configured types | Type examples can compile only when the target router has the required generation or param-list setup. | Confirm the target configuration and use its supported type contract or runtime fallback. |
| Default-exporting every React Native component | Ordinary component imports in this collection use named exports. | Reserve router-required exports for route and layout modules; keep ordinary components named. |
| Running a deep-link command without a target build and platform tool | A command alone is not evidence that native linking works. | Require the target platform, installed tool, configured scheme, and target-project-owned evidence. |
| Requiring `@gorhom/bottom-sheet` or another sheet package | Package compatibility depends on the target's RN, router, engine, architecture, and native setup. | Use an installed compatible abstraction, router modal support, or a target-project-approved dependency. |
| Treating browser or Playwright results as native navigation verification | Browser artifacts do not establish native route, device, gesture, or accessibility behavior. | Keep browser evidence web-only and record native verification as target-project-owned or unavailable. |
