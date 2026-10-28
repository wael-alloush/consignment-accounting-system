// backend/src/middlewares/authMiddleware.js
import jwt from 'jsonwebtoken';

export const verifyToken = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ success: false, message: 'مطلوب تسجيل الدخول، الرمز غير موجود.' });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'fallback_secret_key');
    req.user = decoded; // includes: userId, tenantId, tenantScope, role
    next();
  } catch (error) {
    return res.status(403).json({ success: false, message: 'رمز المصادقة غير صالح أو انتهت صلاحيته.' });
  }
};


// middleware to check if the user has the required role
export const requireRole = (role) => (req, res, next) => {
  if (req.user && req.user.role === role) {
    next();
  } else {
    return res.status(403).json({ success: false, message: `ليس لديك صلاحيات ${role}.` });
  }
};
