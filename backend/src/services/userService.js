import prisma from '../config/db.js';
import bcrypt from 'bcryptjs';

class userService {
  async createUser(tenantId, tenantScope, data) {
    const { name, email, password, role, phone } = data;

    if (tenantId == null || tenantScope == null) {
      throw new Error('تعذر تحديد المتجر من جلسة المستخدم.');
    }

    const existingUser = await prisma.user.findUnique({
      where: { email },
    });
    if (existingUser) {
      throw new Error('البريد الإلكتروني مستخدم بالفعل');
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await prisma.user.create({
      data: {
        name,
        email,
        password: hashedPassword,
        role,
        status: 'active',
        phone: phone || null,
        tenant_id: tenantId,
        tenant_scope: tenantScope,
      },
    });

    const { password: _, ...userData } = user;
    return userData;
  }
}

export default new userService();
