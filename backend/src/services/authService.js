import prisma from '../config/db.js';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

class authService {
    async registerTenantAndAdmin(data) {
        const { store_name, owner_name, owner_phone, currency, email, password, phone } = data;

        // hash password
        const hashedPassword = await bcrypt.hash(password, 10)

        // create tenant and admin

        const result = await prisma.$transaction(async (tx) => {
            const tenant = await tx.tenant.create({
                data: {
                    store_name,
                    owner_name,
                    owner_phone,
                    currency: currency || 'SYP',
                    status: 'trial',
                }
            });

            const user = await tx.user.create({
                data: {
                    tenant_id: tenant.id,
                    tenant_scope: tenant.id, // مطبق بناءً على السكيما لتعدد المستأجرين
                    name: owner_name,
                    email,
                    password: hashedPassword,
                    phone: phone || owner_phone,
                    role: 'store_admin',
                    status: 'active'
                  }
            });
            return { tenant, user }
        });
        return result

    }

    async login(email, password) {
        const user = await prisma.user.findUnique({
            where: { email },
            include: {
                tenant: true
            }
        });

        if (!user || user.status !== 'active') {
            throw new Error('البريد الإلكتروني غير صحيح أو الحساب غير مفعل.');
    }

        const isPasswordValid = await bcrypt.compare(password, user.password);
        if(!isPasswordValid) {
            throw new Error('كلمة المرور غير صحيحة.');
        }

        // create token jwt
        const token = jwt.sign(
            {
                userId: user.id,
                tenantId: user.tenant_id,
                tenantScope: user.tenant_scope,
                role: user.role,
            },
            process.env.JWT_SECRET,
            { expiresIn: '1d' } // 1 day
        );

        return { 
            token,
             user: {
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role,
                tenantId: user.tenant_id,
                tenantScope: user.tenant_scope,
            },
        }
}}

export default new authService()