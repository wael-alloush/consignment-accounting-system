import userService from '../services/userService.js';

class userController {
  async createUser(req, res) {
    try {
      const { tenantId, tenantScope } = req.user;
      const userData = await userService.createUser(tenantId, tenantScope, req.body);
      res.status(201).json({
        success: true,
        message: 'تم انشاء المستخدم بنجاح',
        data: userData,
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'حدث خطأ ما',
        error: error.message,
      });
    }
  }
}

export default new userController();
