import express from 'express';
import TenantController from '../controllers/tenantController.js';
import { verifyToken, requireRole } from '../middlewares/authMiddleware.js';
const router = express.Router();

router.get('/get-tenants', verifyToken, requireRole('super_admin'), TenantController.getTenants);

export default router;