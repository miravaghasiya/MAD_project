# P2P Marketplace - Complete Setup & Run Guide

## Project Structure
```
d:\D24IT158\
├── server/          # Node.js Express backend
│   ├── src/
│   │   ├── index.js
│   │   ├── routes/
│   │   ├── models/
│   │   └── middleware/
│   ├── .env          # CONFIGURE THIS (copy from .env.example)
│   ├── package.json
│   └── README.md
├── mobile/          # Flutter client
│   ├── lib/src/
│   ├── pubspec.yaml
│   └── README.md
├── run-all.ps1      # Run backend + mobile together
├── run-backend.ps1  # Run only backend
└── run-mobile.ps1   # Run only mobile
```

## Prerequisites
- **Node.js** (v16+): https://nodejs.org/
- **Flutter** (latest): https://flutter.dev/
- **Android SDK** or **Xcode** for iOS
- **MongoDB Atlas** account with cluster created
- **Firebase** project with Android & iOS apps configured
- **Cloudinary** account for image uploads
- **Razorpay** sandbox account for payment testing

## Step 1: Configure Environment Variables

### Backend Setup
```powershell
cd d:\D24IT158\server
```

1. Copy `.env.example` to `.env`:
   ```powershell
   Copy-Item .env.example .env
   ```

2. Edit `.env` with your credentials:
   ```properties
   # MongoDB Atlas - get from cluster connection string
   MONGODB_URI=mongodb+srv://YOUR_USERNAME:YOUR_PASSWORD@cluster0.mongodb.net/p2p_marketplace?retryWrites=true&w=majority

   # Firebase - download service account JSON from Firebase Console
   FIREBASE_SERVICE_ACCOUNT=./firebase-service-account.json

   # Cloudinary - https://cloudinary.com/
   CLOUDINARY_CLOUD_NAME=your_cloud_name
   CLOUDINARY_API_KEY=your_api_key
   CLOUDINARY_API_SECRET=your_api_secret

   # Razorpay - https://razorpay.com/ (sandbox mode for testing)
   RAZORPAY_KEY_ID=your_key_id
   RAZORPAY_KEY_SECRET=your_key_secret

   PORT=4000
   NODE_ENV=development
   ```

3. Place **Firebase Service Account JSON**:
   - Download from Firebase Console → Project Settings → Service Accounts
   - Save as `d:\D24IT158\server\firebase-service-account.json`

### Mobile Setup
1. Download Firebase config files:
   - **Android**: `google-services.json` → `d:\D24IT158\mobile\android\app\`
   - **iOS**: `GoogleService-Info.plist` → `d:\D24IT158\mobile\ios\Runner\`

## Step 2: Run the Application

### Option A: Run Both Backend & Mobile (Recommended)
```powershell
cd d:\D24IT158
.\run-all.ps1
```
This will:
1. Check prerequisites (Node, Flutter, Android emulator)
2. Install backend dependencies
3. Install Flutter dependencies
4. Start backend server (port 4000) in new terminal
5. Start Flutter app in current terminal

### Option B: Run Backend Only
```powershell
cd d:\D24IT158
.\run-backend.ps1
```
Server will start on `http://localhost:4000`

### Option C: Run Mobile Only
```powershell
cd d:\D24IT158
.\run-mobile.ps1
```
Mobile will connect to `http://10.0.2.2:4000` (Android emulator)

### Option D: Manual Commands

**Backend**:
```powershell
cd d:\D24IT158\server
npm install
npm run dev
# Server ready: http://localhost:4000
```

**Mobile** (in new terminal):
```powershell
cd d:\D24IT158\mobile
flutter pub get
flutter run
```

## Step 3: Test the Application

### Quick Health Checks
```powershell
# Test backend API
Invoke-RestMethod -Method GET -Uri 'http://localhost:4000/'

# List products
Invoke-RestMethod -Method GET -Uri 'http://localhost:4000/api/products'
```

### Test Workflows
1. **List Products**: Open mobile app → see grid of products from MongoDB
2. **Product Details**: Tap a product card to view details
3. **Authentication** (coming in next phase): Login with Firebase Auth
4. **Create Product** (coming in next phase): Add new products with image upload

## Troubleshooting

### MongoDB Connection Error
```
Error: connect ECONNREFUSED 127.0.0.1:27017
```
- Check MONGODB_URI is correct in `.env`
- Whitelist your IP in MongoDB Atlas (Network Access)
- For local dev: enable 0.0.0.0/0 (not recommended for production)

### Firebase Service Account Not Found
```
Error: Cannot find module './firebase-service-account.json'
```
- Download service account JSON from Firebase Console
- Place at `d:\D24IT158\server\firebase-service-account.json`
- Update FIREBASE_SERVICE_ACCOUNT path in `.env` if different

### Cloudinary Upload Errors
```
Error: invalid signature
```
- Verify CLOUDINARY_CLOUD_NAME, API_KEY, API_SECRET in `.env`
- Check credentials at https://cloudinary.com/console

### Flutter Connection Refused
```
Error: Connection refused on 10.0.2.2:4000
```
- Ensure backend server is running (`npm run dev` in server folder)
- For physical device: replace `10.0.2.2` with your machine IP in `mobile/lib/src/providers/api_provider.dart`

### Port Already in Use
```
Error: listen EADDRINUSE :::4000
```
- Change PORT in `.env` to different value (e.g., 5000)
- Or kill process: `Get-Process node | Stop-Process -Force`

### Flutter Emulator Not Found
```
No devices detected
```
- Start Android emulator: `emulator -avd <avd_name>`
- Or list AVDs: `emulator -list-avds`
- Or connect physical device via USB (enable Developer Mode)

## Project Architecture

### Backend (Node.js + Express + MongoDB)
- **Models**: User, Product, Order, Chat, Message, Review, Transaction
- **Routes**: 
  - `/api/auth/verify` - Firebase token verification
  - `/api/products` - Product CRUD + list with filters
  - `/api/users` - User profile
- **Security**: Firebase auth verification, input validation, rate limiting, CORS
- **Database**: MongoDB Atlas with Mongoose ODM

### Mobile (Flutter + Riverpod)
- **State Management**: Riverpod (FutureProvider, StateNotifier)
- **Architecture**: Clean architecture (presentation/domain/data layers)
- **Key Features**: 
  - Product listing with caching
  - Firebase Authentication (coming next)
  - Real-time chat (coming next)
  - Payment integration (coming next)

## Next Steps (Phases)

1. **Phase 2 - Authentication**:
   - Firebase sign-in on mobile
   - Backend token verification
   - Secure token storage
   - Role-based access (buyer/seller)

2. **Phase 3 - Product Creation**:
   - Product form with image picker
   - Image upload to Cloudinary
   - Seller product management

3. **Phase 4 - Real-time Chat**:
   - Socket.IO integration
   - Message persistence
   - Push notifications (FCM)

4. **Phase 5 - Payments**:
   - Razorpay integration
   - Order creation & tracking
   - Transaction history

5. **Phase 6 - Reviews & Trust**:
   - Ratings system
   - Seller reviews
   - Trust scoring

## Documentation Links

- [Express.js Docs](https://expressjs.com/)
- [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
- [Firebase Admin SDK](https://firebase.google.com/docs/admin/setup)
- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod](https://riverpod.dev/)
- [Cloudinary Upload API](https://cloudinary.com/documentation/upload_widget)
- [Razorpay Integration](https://razorpay.com/docs/)

## Support

For issues:
1. Check error messages carefully
2. Verify all environment variables are set
3. Check Firebase service account file exists
4. Ensure MongoDB Atlas IP whitelist includes your IP
5. Review server console logs for detailed errors

Good luck! 🚀
