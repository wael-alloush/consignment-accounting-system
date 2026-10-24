// backend/src/routes/authRoutes.js
import express from 'express';
const router = express.Router();
import authController from '../controllers/authController.js';

// route to register a new tenant and admin
router.post('/register', authController.register);

// route to login
router.post('/login', authController.login);

export default router;