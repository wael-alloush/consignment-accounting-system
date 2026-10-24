// backend/src/controllers/authController.js
import authService from '../services/authService.js';

class AuthController {
    async register(req, res) {
      try {
        const data = await authService.registerTenantAndAdmin(req.body);
        res.status(201).json({
          success: true,
          message: 'تم تسجيل المتجر والمستخدم بنجاح',
          data
        });
      } catch (error) {
        res.status(400).json({
          success: false,
          message: error.message || 'حدث خطأ أثناء التسجيل'
        });
      }
    }
    async login(req, res) {
        try {
          const { email, password } = req.body;
          const result = await authService.login(email, password);
          res.status(200).json({
            success: true,
            message: 'تم تسجيل الدخول بنجاح',
            data: result
          });
        } catch (error) {
          res.status(400).json({
            success: false,
            message: error.message || 'فشل تسجيل الدخول'
          });
        }
      }
    }
export default new AuthController();