const express = require('express');
const router = express.Router();
const { verifyFirebaseToken } = require('../middleware/firebaseAuth');
const User = require('../models/user');

// Endpoint: verify Firebase ID token and create or update local user record
router.post('/verify', verifyFirebaseToken, async (req, res) => {
  try {
    const fb = req.firebase; // contains uid, email, name etc
    if (!fb || !fb.uid) return res.status(400).json({ error: 'Invalid firebase token payload' });

    let user = await User.findOne({ uid: fb.uid });
    if (!user) {
      user = new User({ uid: fb.uid, email: fb.email, name: fb.name, avatarUrl: fb.picture });
      await user.save();
    } else {
      user.email = fb.email || user.email;
      user.name = fb.name || user.name;
      user.avatarUrl = fb.picture || user.avatarUrl;
      user.updatedAt = new Date();
      await user.save();
    }

    // Respond with local user record
    res.json({ ok: true, user });
  } catch (err) {
    console.error('Auth verify failed', err);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
