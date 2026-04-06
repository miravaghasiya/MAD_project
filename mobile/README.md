# P2P Marketplace - Flutter Mobile Client

Clean architecture Flutter app with Riverpod state management for a peer-to-peer marketplace.

## Features (Initialization Phase)

- ✅ Firebase Authentication integration
- ✅ Product listing with backend API integration
- ✅ Responsive grid layout with cached images
- ✅ Riverpod-based state management
- ✅ Clean architecture (presentation/domain/data layers)
- 🔄 Authentication flow (in progress)
- 🔄 Product creation with image upload (in progress)
- 🔄 Real-time chat via Socket.IO (in progress)
- 🔄 Payment integration with Razorpay (in progress)

## Project Structure

```
lib/
├── main.dart                          # App entry point
└── src/
    ├── app.dart                       # App configuration & theme
    ├── screens/
    │   └── product_list_screen.dart   # Product listing UI (ConsumerWidget with Riverpod)
    ├── services/
    │   └── api_service.dart           # HTTP client for backend API
    ├── providers/
    │   ├── api_provider.dart          # API service provider
    │   └── product_list_provider.dart # Product list FutureProvider
    └── domain/                        # (To be added) Entities and use cases
```

## Setup Instructions

### 1. Install Dependencies

```bash
cd mobile
flutter pub get
```

### 2. Configure Firebase

Download config files from Firebase Console:

**Android**:
```
mobile/android/app/google-services.json
```

**iOS**:
```
mobile/ios/Runner/GoogleService-Info.plist
```

### 3. Configure Backend URL

Edit `lib/src/providers/api_provider.dart` and set the correct base URL:

```dart
// For Android emulator
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(baseUrl: 'http://10.0.2.2:4000');
});

// For physical device (replace with your machine IP)
// return ApiService(baseUrl: 'http://192.168.1.100:4000');
```

### 4. Run the App

**Android**:
```bash
flutter run
```

**iOS**:
```bash
flutter run -d ios
```

**Specific Device**:
```bash
flutter devices                    # List available devices
flutter run -d <device-id>        # Run on specific device
```

## Architecture Overview

### Clean Architecture Layers

1. **Presentation Layer** (`screens/`)
   - UI widgets (ConsumerWidget, StatelessWidget)
   - Riverpod integration for state management
   - Responsive layouts and animations

2. **Domain Layer** (to be added)
   - Entities (pure Dart objects, no framework dependencies)
   - Use cases (business logic)
   - Repository interfaces (abstract)

3. **Data Layer** (`services/`)
   - Repository implementations
   - Data sources (API, local cache)
   - Models (serialization/deserialization)

### State Management (Riverpod)

**FutureProvider** for async operations:
```dart
final productListProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return await api.fetchProducts();
});
```

**StateNotifierProvider** for mutable state (to be added):
```dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
```

## API Integration

### Product Listing

```dart
// Call backend API
final products = await apiService.fetchProducts(page: 1, limit: 20);

// State management
final asyncProducts = ref.watch(productListProvider);
asyncProducts.when(
  loading: () => LoadingWidget(),
  error: (err, st) => ErrorWidget(error: err),
  data: (products) => ListView(...),
);
```

### Firebase Authentication (Coming Next)

```dart
// Sign up
final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email,
  password: password,
);

// Sign in
final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
  password: password,
);

// Get ID token and verify with backend
final idToken = await user.getIdToken();
final response = await apiService.verifyFirebaseToken(idToken);
```

## UI Components

### ProductListScreen

**Props**:
- ConsumerWidget (Riverpod integrated)
- Watches `productListProvider` for async product list

**States**:
- Loading: CircularProgressIndicator
- Error: Error message display
- Data: GridView with product cards

**Product Card**:
- Cached network image with loading/error placeholders
- Product title, price, condition badge
- Ripple effect on tap (to be added with navigation)

## Testing

### Run Tests

```bash
# Unit tests
flutter test

# Widget tests (specific file)
flutter test test/widget/product_list_screen_test.dart

# Integration tests
flutter drive --target=test_driver/app.dart
```

### Example Widget Test

```dart
testWidgets('ProductListScreen displays products', (WidgetTester tester) async {
  // Mock API response
  when(mockApi.fetchProducts()).thenAnswer((_) async => [
    {'id': '1', 'title': 'Test Product', 'price': 100, 'images': []}
  ]);

  // Build widget
  await tester.pumpWidget(const ProviderScope(child: MyApp()));

  // Verify product appears
  expect(find.text('Test Product'), findsOneWidget);
});
```

## Performance Optimization

### Image Caching
- Uses `CachedNetworkImage` for automatic HTTP cache
- Configurable cache size and expiration
- Placeholder and error widgets

### State Caching
- `FutureProvider.autoDispose` automatically disposes when unwatched
- Local cache layer coming with Hive integration

### Network Optimization
- HTTP connection pooling via Dio
- Gzip compression for API responses
- Request timeout configuration

## Dependencies

### Core
- `flutter_riverpod: ^2.3.2` - State management
- `http: ^0.13.6` - HTTP client
- `firebase_core: ^2.21.1` - Firebase core
- `firebase_auth: ^4.6.3` - Firebase authentication

### UI
- `cached_network_image: ^3.2.4` - Image caching
- `cupertino_icons: ^1.0.2` - iOS icons

### Storage
- `flutter_secure_storage: ^9.0.0` - Secure token storage
- `image_picker: ^0.8.7` - Image selection (coming in phase 2)

## Best Practices

### Code Style
- Follow Dart/Flutter conventions
- Use const constructors where possible
- Prefer immutable widgets
- Use meaningful variable names

### State Management
- One provider per logical entity
- Keep providers focused and single-responsibility
- Use `.autoDispose` for providers with side effects
- Avoid passing BuildContext between layers

### Error Handling
- Catch specific exceptions
- Provide meaningful error messages to users
- Log errors for debugging
- Implement retry logic for transient failures

### Security
- Store Firebase ID tokens in `flutter_secure_storage`
- Never hardcode API keys or secrets
- Validate user input on client side
- Use HTTPS for all API calls

## Debugging

### Enable Debug Logging

```dart
// In main.dart
void main() {
  // Enable verbose logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  
  runApp(const ProviderScope(child: MyApp()));
}
```

### Riverpod DevTools

```bash
flutter pub add riverpod_generator
flutter pub add build_runner
flutter pub run build_runner watch
```

### Flutter DevTools

```bash
flutter pub global activate devtools
devtools
```

Then navigate to `http://localhost:9100`

## Common Issues & Solutions

### Build Errors

**Error**: `Target of URI doesn't exist: 'package:firebase_core/firebase_core.dart'`
- Solution: Run `flutter pub get` and rebuild

**Error**: `Android SDK not found`
- Solution: Set `ANDROID_SDK_ROOT` environment variable or configure in Android Studio

### Runtime Errors

**Error**: `Connection refused` from emulator
- Solution: Ensure backend is running on correct port (default 4000)
- For Android emulator, use `http://10.0.2.2:4000`
- For physical device, use machine IP (e.g., `http://192.168.1.100:4000`)

**Error**: `E/Zygote: Not starting debugger since process cannot load Xposed`
- Solution: This is harmless; can be ignored

## Next Steps

1. **Phase 2 - Authentication**
   - Firebase sign-in UI (email, phone, Google)
   - Token verification with backend
   - Secure storage of tokens
   - Role-based access control

2. **Phase 3 - Product Management**
   - Create product form with validation
   - Image picker and upload to Cloudinary
   - Edit/delete product (seller only)

3. **Phase 4 - Real-time Chat**
   - Socket.IO client integration
   - Message UI and persistence
   - Push notifications (FCM)

4. **Phase 5 - Payments**
   - Razorpay SDK integration
   - Order creation and tracking
   - Transaction history

5. **Phase 6 - Ratings & Reviews**
   - Review form and display
   - Seller rating aggregation
   - Trust scoring

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Dart Effective Guide](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)

## Support & Contributing

For issues or questions:
1. Check Flutter doctor: `flutter doctor`
2. Review server logs for API errors
3. Use DevTools for state inspection
4. Check Firebase Console for auth issues
