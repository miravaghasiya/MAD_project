const mongoose = require('mongoose');

const ProductSchema = new mongoose.Schema({
  sellerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  title: { type: String, required: true, index: true },
  description: { type: String },
  images: [{ type: String }],
  price: { type: Number, required: true },
  currency: { type: String, default: 'INR' },
  category: { type: String, index: true },
  tags: [{ type: String, index: true }],
  condition: { type: String, enum: ['new', 'used'], default: 'used' },
  location: { type: String },
  stock: { type: Number, default: 1 },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

ProductSchema.index({ title: 'text', description: 'text', tags: 'text' });

module.exports = mongoose.model('Product', ProductSchema);
