const admin = require('firebase-admin');

let initialized = false;

function initFirebase() {
  if (initialized) return;
  const svcAccountPath = process.env.FIREBASE_SERVICE_ACCOUNT;
  if (!svcAccountPath) throw new Error('FIREBASE_SERVICE_ACCOUNT not set in env');
  const serviceAccount = require(svcAccountPath);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
  initialized = true;
}

async function verifyFirebaseToken(req, res, next) {
  try {
    initFirebase();
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) return res.status(401).json({ error: 'No token provided' });
    const idToken = authHeader.split(' ')[1];
    const decoded = await admin.auth().verifyIdToken(idToken);
    req.firebase = decoded;
    next();
  } catch (err) {
    console.error('Firebase token verification failed', err);
    res.status(401).json({ error: 'Invalid token' });
  }
}

module.exports = { initFirebase, verifyFirebaseToken };
