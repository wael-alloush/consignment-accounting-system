import express from 'express';
import userController from '../controllers/userController.js';
import { verifyToken, requireRole } from '../middlewares/authMiddleware.js';

const router = express.Router();

router.post('/create', verifyToken, requireRole('store_admin'), userController.createUser);

export default router;