# P2P Marketplace Backend Server

Express.js + MongoDB Atlas backend for peer-to-peer marketplace with Firebase authentication and Cloudinary image uploads.

## Features (Initialization Phase)

- ✅ Firebase ID token verification
- ✅ User management (create/retrieve)
- ✅ Product listing with filters and search
- ✅ Cloudinary image upload integration
- ✅ MongoDB Atlas database integration
- ✅ Rate limiting and security middleware
- 🔄 Chat system with Socket.IO (in progress)
- 🔄 Payment processing with Razorpay (in progress)
- 🔄 Order management (in progress)
- 🔄 Review & rating system (in progress)

## Project Structure

```
src/
├── index.js                      # Application entry point
├── middleware/
│   └── firebaseAuth.js           # Firebase token verification middleware
├── models/
│   ├── user.js                   # User schema (Mongoose)
│   └── product.js                # Product schema with text indexes
└── routes/
    ├── auth.js                   # Authentication endpoints
    └── products.js               # Product CRUD & listing endpoints
```

## Installation & Setup

### 1. Install Dependencies

```powershell
cd server
npm install
```

### 2. Configure Environment Variables

Copy `.env.example` to `.env` and fill in your credentials:

```powershell
Copy-Item .env.example .env
```

Edit `.env`:

```properties
# MongoDB Atlas
MONGODB_URI=mongodb+srv://YOUR_USERNAME:YOUR_PASSWORD@cluster0.mongodb.net/p2p_marketplace?retryWrites=true&w=majority

# Firebase service account (download from Firebase Console)
FIREBASE_SERVICE_ACCOUNT=./firebase-service-account.json

# Cloudinary
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# Razorpay (sandbox for testing)
RAZORPAY_KEY_ID=rzp_test_xxxxxxx
RAZORPAY_KEY_SECRET=xxxxxxx

# Server
PORT=4000
NODE_ENV=development
```

### 3. Place Firebase Service Account

1. Go to Firebase Console → Project Settings
2. Click "Service Accounts" tab
3. Click "Generate New Private Key"
4. Save as `server/firebase-service-account.json`

### 4. Run the Server

**Development** (with nodemon auto-reload):
```powershell
npm run dev
```

**Production**:
```powershell
npm start
```

Server will start on `http://localhost:4000`

## API Endpoints

### Health Check

**GET** `/`

Check if server is running.

**Response**:
```json
{
  "ok": true,
  "message": "P2P Marketplace API"
}
```

---

### Authentication

#### Verify Firebase ID Token

**POST** `/api/auth/verify`

Verify Firebase ID token and create/update local user record in MongoDB.

**Headers**:
```
Authorization: Bearer <firebase-id-token>
Content-Type: application/json
```

**Request**:
```bash
curl -X POST http://localhost:4000/api/auth/verify \
  -H "Authorization: Bearer YOUR_FIREBASE_ID_TOKEN"
```

**Response**:
```json
{
  "ok": true,
  "user": {
    "_id": "507f1f77bcf86cd799439011",
    "uid": "firebase_uid_here",
    "email": "user@example.com",
    "name": "John Doe",
    "role": "buyer",
    "avatarUrl": null,
    "createdAt": "2026-04-06T10:30:00.000Z",
    "updatedAt": "2026-04-06T10:30:00.000Z"
  }
}
```

**Error Response**:
```json
{
  "error": "Invalid token"
}
```

---

### Products

#### List Products

**GET** `/api/products`

Get paginated list of products with optional filters and search.

**Query Parameters**:
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `q` | string | Full-text search (title, description, tags) | - |
| `category` | string | Filter by category | - |
| `min` | number | Minimum price | - |
| `max` | number | Maximum price | - |
| `sort` | string | Sort field (createdAt, price, etc.) | createdAt |
| `page` | number | Page number (1-indexed) | 1 |
| `limit` | number | Results per page | 20 |

**Request**:
```bash
# List all products
curl http://localhost:4000/api/products

# Search with filters
curl "http://localhost:4000/api/products?q=laptop&category=electronics&min=10000&max=50000&page=1&limit=20"
```

**Response**:
```json
{
  "ok": true,
  "products": [
    {
      "_id": "507f1f77bcf86cd799439011",
      "sellerId": "507f1f77bcf86cd799439012",
      "title": "MacBook Pro 2023",
      "description": "Excellent condition, minimal use",
      "images": ["https://res.cloudinary.com/..."],
      "price": 85000,
      "currency": "INR",
      "category": "electronics",
      "tags": ["laptop", "apple", "m2"],
      "condition": "used",
      "location": "Mumbai",
      "stock": 1,
      "createdAt": "2026-04-06T10:30:00.000Z",
      "updatedAt": "2026-04-06T10:30:00.000Z"
    }
  ]
}
```

---

#### Get Product Details

**GET** `/api/products/:id`

Get detailed information about a specific product including seller info.

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | ObjectId | Product MongoDB ID |

**Request**:
```bash
curl http://localhost:4000/api/products/507f1f77bcf86cd799439011
```

**Response**:
```json
{
  "ok": true,
  "product": {
    "_id": "507f1f77bcf86cd799439011",
    "sellerId": {
      "_id": "507f1f77bcf86cd799439012",
      "name": "John Doe",
      "avatarUrl": "https://res.cloudinary.com/..."
    },
    "title": "MacBook Pro 2023",
    "description": "Excellent condition, minimal use",
    "images": ["https://res.cloudinary.com/..."],
    "price": 85000,
    "currency": "INR",
    "category": "electronics",
    "tags": ["laptop", "apple", "m2"],
    "condition": "used",
    "location": "Mumbai",
    "stock": 1,
    "createdAt": "2026-04-06T10:30:00.000Z",
    "updatedAt": "2026-04-06T10:30:00.000Z"
  }
}
```

**Error Response**:
```json
{
  "error": "Product not found"
}
```

---

#### Create Product (Seller Only)

**POST** `/api/products`

Create a new product listing with image uploads.

**Headers**:
```
Authorization: Bearer <firebase-id-token>
Content-Type: multipart/form-data
```

**Form Data**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | string | Yes | Product title (max 200 chars) |
| `description` | string | No | Product description |
| `price` | number | Yes | Price in specified currency |
| `currency` | string | No | Currency code (default: INR) |
| `category` | string | No | Product category |
| `tags` | string | No | Comma-separated tags |
| `condition` | string | No | "new" or "used" (default: used) |
| `location` | string | No | Seller location |
| `stock` | number | No | Available quantity (default: 1) |
| `images` | file[] | No | Up to 6 images (max 5MB each) |

**Request** (using curl):
```bash
curl -X POST http://localhost:4000/api/products \
  -H "Authorization: Bearer YOUR_FIREBASE_ID_TOKEN" \
  -F "title=MacBook Pro 2023" \
  -F "description=Excellent condition" \
  -F "price=85000" \
  -F "currency=INR" \
  -F "category=electronics" \
  -F "tags=laptop,apple,m2" \
  -F "condition=used" \
  -F "location=Mumbai" \
  -F "stock=1" \
  -F "images=@/path/to/image1.jpg" \
  -F "images=@/path/to/image2.jpg"
```

**Response**:
```json
{
  "ok": true,
  "product": {
    "_id": "507f1f77bcf86cd799439011",
    "sellerId": "507f1f77bcf86cd799439012",
    "title": "MacBook Pro 2023",
    "description": "Excellent condition",
    "images": [
      "https://res.cloudinary.com/...",
      "https://res.cloudinary.com/..."
    ],
    "price": 85000,
    "currency": "INR",
    "category": "electronics",
    "tags": ["laptop", "apple", "m2"],
    "condition": "used",
    "location": "Mumbai",
    "stock": 1,
    "createdAt": "2026-04-06T10:30:00.000Z",
    "updatedAt": "2026-04-06T10:30:00.000Z"
  }
}
```

**Error Responses**:
```json
{
  "error": "title and price are required"
}
```

```json
{
  "error": "Only sellers can create products"
}
```

---

## Database Models

### User

```javascript
{
  uid: String (Firebase UID, unique, required),
  email: String (unique, required),
  name: String,
  role: String (enum: ['buyer', 'seller', 'admin'], default: 'buyer'),
  avatarUrl: String,
  fcmToken: String (Firebase Cloud Messaging token),
  createdAt: Date (default: now),
  updatedAt: Date (default: now)
}
```

### Product

```javascript
{
  sellerId: ObjectId (ref: User, required),
  title: String (required, indexed for text search),
  description: String,
  images: [String] (Cloudinary URLs),
  price: Number (required),
  currency: String (default: 'INR'),
  category: String (indexed),
  tags: [String] (indexed),
  condition: String (enum: ['new', 'used'], default: 'used'),
  location: String,
  stock: Number (default: 1),
  createdAt: Date (default: now),
  updatedAt: Date (default: now)
}
```

**Indexes**:
- Text index on: title, description, tags (full-text search)
- Single indexes on: sellerId, category, tags
- Compound indexes to be added for common queries

---

## Security Features

### Implemented

- ✅ **Firebase Authentication**: Verify ID tokens from Firebase
- ✅ **Rate Limiting**: 100 requests per 15 minutes per IP
- ✅ **CORS**: Cross-origin requests configured
- ✅ **Helmet**: HTTP security headers
- ✅ **Input Validation**: Required fields checked
- ✅ **Role-Based Access**: Sellers can only create products
- ✅ **Parameterized Queries**: Mongoose prevents injection

### To Be Implemented

- 🔄 Input sanitization (express-validator)
- 🔄 API key rotation and refresh tokens
- 🔄 Request signing for webhooks
- 🔄 Audit logging for sensitive operations
- 🔄 Field-level encryption for sensitive data
- 🔄 IP whitelisting for admin endpoints

---

## Error Handling

All endpoints follow consistent error response format:

```json
{
  "error": "Description of the error"
}
```

**Common HTTP Status Codes**:
| Code | Meaning |
|------|---------|
| 200 | Success |
| 400 | Bad request (missing/invalid params) |
| 401 | Unauthorized (invalid/missing token) |
| 403 | Forbidden (insufficient permissions) |
| 404 | Not found (resource doesn't exist) |
| 500 | Server error |

---

## Testing API Endpoints

### Using PowerShell

```powershell
# List products
Invoke-RestMethod -Method GET -Uri 'http://localhost:4000/api/products'

# Get specific product
Invoke-RestMethod -Method GET -Uri 'http://localhost:4000/api/products/507f1f77bcf86cd799439011'

# Verify token
$headers = @{ 'Authorization' = 'Bearer YOUR_TOKEN' }
Invoke-RestMethod -Method POST -Uri 'http://localhost:4000/api/auth/verify' -Headers $headers
```

### Using Postman

1. Create new request → POST → `http://localhost:4000/api/auth/verify`
2. Headers → Add `Authorization: Bearer <token>`
3. Send

### Using cURL

```bash
# List products
curl http://localhost:4000/api/products

# Verify token
curl -X POST http://localhost:4000/api/auth/verify \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## Deployment

### Docker

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY src ./src
EXPOSE 4000
CMD ["npm", "start"]
```

Build and run:
```bash
docker build -t p2p-marketplace-server .
docker run -p 4000:4000 --env-file .env p2p-marketplace-server
```

### Environment Setup for Production

```properties
NODE_ENV=production
MONGODB_URI=mongodb+srv://prod_user:prod_password@...
JWT_SECRET=<long-random-secret>
RAZORPAY_KEY_ID=rzp_live_...
RAZORPAY_KEY_SECRET=...
PORT=4000
```

---

## Monitoring & Logging

### Console Output

Server logs all requests via Morgan middleware:
```
GET /api/products 200 45ms
POST /api/auth/verify 200 123ms
GET /api/products/123 404 2ms
```

### To Add

- 🔄 Sentry for error tracking
- 🔄 Winston for structured logging
- 🔄 Prometheus metrics for monitoring
- 🔄 CloudWatch for AWS deployments

---

## Next Steps (Upcoming Phases)

1. **Phase 2 - Chat System**
   - Socket.IO integration
   - Real-time messaging
   - Push notifications (FCM)

2. **Phase 3 - Payments**
   - Razorpay payment processing
   - Order creation and tracking
   - Webhook handling

3. **Phase 4 - Reviews & Ratings**
   - Review submission
   - Aggregated ratings
   - Seller trust scoring

4. **Phase 5 - Advanced Features**
   - Favorite/wishlist system
   - User activity feeds
   - Recommendation engine

---

## Troubleshooting

### MongoDB Connection Error

```
MongooseError: Cannot connect to MongoDB
```

**Solution**:
- Verify `MONGODB_URI` in `.env`
- Whitelist your IP in MongoDB Atlas (0.0.0.0/0 for dev)
- Check MongoDB credentials

### Firebase Service Account Not Found

```
Error: Cannot find module './firebase-service-account.json'
```

**Solution**:
- Download from Firebase Console → Project Settings → Service Accounts
- Place at `server/firebase-service-account.json`

### Cloudinary Upload Failure

```
Error: invalid signature
```

**Solution**:
- Verify CLOUDINARY_CLOUD_NAME, API_KEY, API_SECRET
- Check at https://cloudinary.com/console/settings

### Port Already in Use

```
Error: listen EADDRINUSE :::4000
```

**Solution**:
```powershell
# Kill process using port 4000
Get-Process node | Stop-Process -Force

# Or change PORT in .env to 5000
```

---

## Resources

- [Express.js Documentation](https://expressjs.com/)
- [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
- [Firebase Admin SDK](https://firebase.google.com/docs/admin/setup)
- [Mongoose ODM](https://mongoosejs.com/)
- [Cloudinary Upload API](https://cloudinary.com/documentation/upload_widget)
- [Razorpay Integration](https://razorpay.com/docs/)

## Support

For issues:
1. Check error message carefully
2. Review server console logs
3. Verify environment variables
4. Test with curl or Postman
5. Check database and external service status

