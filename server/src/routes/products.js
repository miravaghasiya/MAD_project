const express = require('express');
const router = express.Router();
const multer = require('multer');
const cloudinary = require('cloudinary').v2;
const Product = require('../models/product');
const { verifyFirebaseToken, initFirebase } = require('../middleware/firebaseAuth');

// Configure Cloudinary
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: 5 * 1024 * 1024 } });

// Create product (seller must be authenticated via Firebase token)
router.post('/', verifyFirebaseToken, upload.array('images', 6), async (req, res) => {
  try {
    const fb = req.firebase;
    // Find local user
    const User = require('../models/user');
    const localUser = await User.findOne({ uid: fb.uid });
    if (!localUser) return res.status(403).json({ error: 'User not found' });

    // Minimal role check: ensure user can post (seller or admin)
    if (!['seller', 'admin'].includes(localUser.role)) {
      return res.status(403).json({ error: 'Only sellers can create products' });
    }

    const { title, description, price, currency, category, tags, condition, location, stock } = req.body;
    if (!title || !price) return res.status(400).json({ error: 'title and price are required' });

    const imageFiles = req.files || [];
    const imageUploadPromises = imageFiles.map((file) => {
      return cloudinary.uploader.upload_stream({ resource_type: 'image', folder: 'p2p_products' }, (error, result) => {
        if (error) throw error;
        return result.secure_url;
      }).end(file.buffer);
    });

    // Note: multer memory + Cloudinary upload_stream with mapping requires custom handling. For initialization phase we'll handle single uploads sequentially.
    const uploadedUrls = [];
    for (const file of imageFiles) {
      const result = await new Promise((resolve, reject) => {
        const stream = cloudinary.uploader.upload_stream({ resource_type: 'image', folder: 'p2p_products' }, (error, result) => {
          if (error) return reject(error);
          resolve(result);
        });
        stream.end(file.buffer);
      });
      uploadedUrls.push(result.secure_url);
    }

    const product = new Product({
      sellerId: localUser._id,
      title,
      description,
      images: uploadedUrls,
      price: Number(price),
      currency: currency || 'INR',
      category,
      tags: tags ? (Array.isArray(tags) ? tags : String(tags).split(',').map(t => t.trim())) : [],
      condition: condition || 'used',
      location,
      stock: stock ? Number(stock) : 1
    });

    await product.save();
    res.json({ ok: true, product });
  } catch (err) {
    console.error('Create product failed', err);
    res.status(500).json({ error: 'Server error' });
  }
});

// List products with basic filters
router.get('/', async (req, res) => {
  try {
    const { q, category, min, max, sort = 'createdAt', page = 1, limit = 20 } = req.query;
    const filter = {};
    if (q) filter.$text = { $search: q };
    if (category) filter.category = category;
    if (min || max) filter.price = {};
    if (min) filter.price.$gte = Number(min);
    if (max) filter.price.$lte = Number(max);

    const skip = (Number(page) - 1) * Number(limit);
    const products = await Product.find(filter).sort({ [sort]: -1 }).skip(skip).limit(Number(limit));
    res.json({ ok: true, products });
  } catch (err) {
    console.error('List products failed', err);
    res.status(500).json({ error: 'Server error' });
  }
});

// Get product details
router.get('/:id', async (req, res) => {
  try {
    const product = await Product.findById(req.params.id).populate('sellerId', 'name avatarUrl');
    if (!product) return res.status(404).json({ error: 'Product not found' });
    res.json({ ok: true, product });
  } catch (err) {
    console.error('Get product failed', err);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
