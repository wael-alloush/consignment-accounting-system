import express from 'express';
import controllers from '../controllers/userController.js';
const [userController, superAdminController] = controllers;
import { verifyToken, requireRole } from '../middlewares/authMiddleware.js';

const router = express.Router();
const superAdminRouter = express.Router();


router.post('/create', verifyToken, requireRole('store_admin'), userController.createUser);
superAdminRouter.post('/create-super-admin', verifyToken, requireRole('super_admin'), superAdminController.createSuperAdmin);


export default [router, superAdminRouter];  