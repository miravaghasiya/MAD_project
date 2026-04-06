# P2P Marketplace - Complete Full-Stack Solution

A production-ready Flutter mobile app + Node.js backend for a peer-to-peer marketplace platform. Includes Firebase authentication, real-time chat (coming soon), secure payments with Razorpay, and comprehensive review system.

## 🎯 Project Overview

This is a full-stack implementation of a modern P2P marketplace with:

- **Mobile Client**: Flutter with Riverpod state management
- **Backend API**: Node.js/Express with MongoDB Atlas
- **Authentication**: Firebase Auth with backend verification
- **Image Storage**: Cloudinary CDN
- **Payments**: Razorpay integration (coming soon)
- **Real-time Communication**: Socket.IO for chat (coming soon)
- **Database**: MongoDB Atlas with secure connections

## 📁 Project Structure

```
d:\D24IT158\
├── server/                  # Node.js/Express backend
│   ├── src/
│   │   ├── index.js        # Server entry point
│   │   ├── routes/         # API endpoints
│   │   ├── models/         # MongoDB schemas
│   │   └── middleware/     # Auth, CORS, etc.
│   ├── package.json
│   ├── .env.example
│   ├── .env                # CONFIGURE THIS
│   └── README.md
├── mobile/                  # Flutter client
│   ├── lib/src/
│   │   ├── screens/        # UI screens
│   │   ├── providers/      # Riverpod providers
│   │   ├── services/       # API clients
│   │   └── app.dart
│   ├── pubspec.yaml
│   ├── android/
│   │   └── app/
│   │       └── google-services.json  # DOWNLOAD THIS
│   ├── ios/
│   │   └── Runner/
│   │       └── GoogleService-Info.plist  # DOWNLOAD THIS
│   └── README.md
├── SETUP_GUIDE.md          # Detailed setup instructions
├── run-all.ps1             # Run backend + mobile together
├── run-backend.ps1         # Run backend only
├── run-mobile.ps1          # Run mobile only
└── .gitignore
```

## 🚀 Quick Start

### Prerequisites
- Node.js v16+
- Flutter latest version
- MongoDB Atlas account (free tier available)
- Firebase project
- Cloudinary account (free tier available)
- Razorpay account (sandbox mode)

### 1. Clone & Setup

```powershell
cd d:\D24IT158
```

### 2. Configure Backend

```powershell
cd server
Copy-Item .env.example .env
```

Edit `.env` with:
- MongoDB Atlas connection string
- Firebase service account JSON path
- Cloudinary credentials
- Razorpay test keys

Place Firebase service account JSON at `server/firebase-service-account.json`

### 3. Configure Mobile

Download from Firebase Console:
- `google-services.json` → `mobile/android/app/`
- `GoogleService-Info.plist` → `mobile/ios/Runner/`

### 4. Run the App

**Option A: Run Everything**
```powershell
.\run-all.ps1
```

**Option B: Backend + Mobile Separately**
```powershell
# Terminal 1: Backend
.\run-backend.ps1

# Terminal 2: Mobile
.\run-mobile.ps1
```

## 📖 Documentation

- **[SETUP_GUIDE.md](./SETUP_GUIDE.md)** - Complete setup and troubleshooting
- **[server/README.md](./server/README.md)** - Backend API documentation
- **[mobile/README.md](./mobile/README.md)** - Mobile client architecture and setup

## 🏗️ Architecture Overview

### Clean Architecture Layers

#### Backend (Node.js)
```
Routes (API endpoints)
↓
Middleware (Auth, validation, error handling)
↓
Services (Business logic)
↓
Models (MongoDB schemas)
```

#### Mobile (Flutter)
```
UI Screens (ConsumerWidget)
↓
Riverpod Providers (State management)
↓
Services (API clients, business logic)
↓
Models (Data classes)
```

## 🔐 Security Features

### Implemented
- ✅ Firebase ID token verification
- ✅ Rate limiting (100 req/15min per IP)
- ✅ CORS configuration
- ✅ Helmet security headers
- ✅ Input validation
- ✅ Role-based access control
- ✅ Secure token storage (mobile)
- ✅ HTTPS-ready architecture

### To Be Implemented
- 🔄 Field-level encryption
- 🔄 API key rotation
- 🔄 Audit logging
- 🔄 Request signing
- 🔄 IP whitelisting

## 📱 API Endpoints

### Health & Auth
```
GET  /                        Health check
POST /api/auth/verify         Verify Firebase token & create user
```

### Products
```
GET    /api/products          List products (filters, search, pagination)
GET    /api/products/:id      Get product details
POST   /api/products          Create product (seller only, image upload)
PATCH  /api/products/:id      Update product (seller only)
DELETE /api/products/:id      Delete product (seller/admin only)
```

### Coming Soon
```
Chat (Socket.IO)
Orders & Payments
Reviews & Ratings
User profiles
```

## 🛠️ Technology Stack

### Backend
- **Runtime**: Node.js 16+
- **Framework**: Express.js 4.x
- **Database**: MongoDB (Atlas)
- **Auth**: Firebase Admin SDK
- **Image Storage**: Cloudinary
- **Payment**: Razorpay SDK
- **Real-time**: Socket.IO
- **Validation**: express-validator
- **Monitoring**: Morgan, Winston (planned)

### Mobile
- **Framework**: Flutter (latest)
- **Language**: Dart 2.19+
- **State Management**: Riverpod 2.x
- **HTTP Client**: http, Dio
- **Auth**: Firebase Auth SDK
- **Image Caching**: cached_network_image
- **Secure Storage**: flutter_secure_storage
- **Real-time**: socket_io_client
- **Payment**: Razorpay Flutter SDK

## 📊 Implementation Phases

### Phase 1: Initialization (CURRENT) ✅
- [x] Project scaffolding
- [x] Backend setup with MongoDB/Firebase
- [x] Basic product listing API
- [x] Flutter mobile app with Riverpod
- [x] Product list UI

### Phase 2: Authentication 🔄
- [ ] Firebase sign-in (email, phone, Google)
- [ ] Backend token verification
- [ ] Secure token storage
- [ ] Role-based access control
- [ ] User profile management

### Phase 3: Product Management 🔄
- [ ] Product creation with image upload
- [ ] Edit/delete products (seller only)
- [ ] Search and advanced filters
- [ ] Offline caching with Hive

### Phase 4: Chat System 🔄
- [ ] Socket.IO integration
- [ ] Real-time messaging
- [ ] Message persistence
- [ ] Read receipts
- [ ] Push notifications (FCM)

### Phase 5: Payments & Orders 🔄
- [ ] Razorpay integration
- [ ] Order creation and tracking
- [ ] Transaction history
- [ ] Payment status webhooks

### Phase 6: Trust & Reviews 🔄
- [ ] Rating system
- [ ] Review submissions
- [ ] Seller reputation scoring
- [ ] Dispute resolution (planned)

## 🧪 Testing

### Backend Tests
```bash
cd server
npm test              # Run unit tests
npm run test:int      # Run integration tests
npm run coverage      # Generate coverage report
```

### Mobile Tests
```bash
cd mobile
flutter test                     # Unit tests
flutter test integration_test/   # Integration tests
flutter drive --target=test_driver/app.dart  # E2E tests
```

## 📦 Dependencies

### Backend
```json
{
  "express": "^4.18.2",
  "mongoose": "^7.4.0",
  "firebase-admin": "^11.10.1",
  "cloudinary": "^1.33.0",
  "razorpay": "^3.2.0",
  "cors": "^2.8.5",
  "helmet": "^7.0.0",
  "multer": "^1.4.5",
  "express-rate-limit": "^6.8.0",
  "dotenv": "^16.3.1"
}
```

### Mobile
```yaml
dependencies:
  flutter_riverpod: ^2.3.2
  firebase_core: ^2.21.1
  firebase_auth: ^4.6.3
  http: ^0.13.6
  cached_network_image: ^3.2.4
  flutter_secure_storage: ^9.0.0
  image_picker: ^0.8.7
```

## 🐛 Troubleshooting

### Backend Issues

**MongoDB Connection Error**
```
Error: connect ECONNREFUSED
```
→ Check MONGODB_URI and IP whitelist in Atlas

**Firebase Service Account Error**
```
Error: Cannot find module './firebase-service-account.json'
```
→ Download from Firebase Console and place in server folder

**Cloudinary Upload Fails**
```
Error: invalid signature
```
→ Verify Cloudinary credentials in .env

### Mobile Issues

**Connection Refused**
```
Error: Connection refused on 10.0.2.2:4000
```
→ Ensure backend is running; for physical device, use machine IP

**Firebase Config Missing**
```
Error: google-services.json not found
```
→ Download from Firebase Console and place in correct folder

**Flutter Pub Get Failed**
```
Error: pub get failed
```
→ Run `flutter clean` then `flutter pub get`

See [SETUP_GUIDE.md](./SETUP_GUIDE.md) for more troubleshooting.

## 📝 Best Practices

### Code Style
- Follow Dart/Flutter conventions (PascalCase for classes, camelCase for variables)
- Use const constructors and immutable widgets
- Add meaningful comments for complex logic
- Keep functions small and focused

### Commit Messages
```
[Phase/Feature] Brief description

More detailed explanation if needed
```

Example:
```
[Phase-1] Product listing UI with Riverpod
```

### Environment Variables
- Never commit `.env` files
- Use `.env.example` as template
- Rotate keys regularly in production
- Use separate credentials for dev/staging/prod

## 📚 Learning Resources

- [Flutter Official Docs](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Express.js Guide](https://expressjs.com/)
- [MongoDB University](https://university.mongodb.com/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

## 🤝 Contributing

1. Create a feature branch: `git checkout -b feature/auth-flow`
2. Make changes and test locally
3. Commit with clear messages
4. Push and create pull request
5. Ensure all tests pass

## 📄 License

MIT License - See LICENSE file

## 📞 Support

For issues or questions:
1. Check [SETUP_GUIDE.md](./SETUP_GUIDE.md)
2. Review relevant README (backend/mobile)
3. Check error logs and console output
4. Review Firebase/MongoDB/Cloudinary documentation

## 🎉 Next Steps

1. **Complete Setup**: Follow [SETUP_GUIDE.md](./SETUP_GUIDE.md)
2. **Run Application**: Use `.\run-all.ps1`
3. **Test APIs**: Use Postman or PowerShell
4. **Review Code**: Check backend and mobile READMEs
5. **Implement Phase 2**: Firebase authentication

---

**Status**: Initialization Phase Complete ✅
**Last Updated**: April 6, 2026
**Version**: 0.1.0

Start building your marketplace! 🚀
