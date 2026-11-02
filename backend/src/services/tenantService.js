import prisma from "../config/db.js";

class TenantService {

    async getTenants() {
        const tenants = await prisma.tenant.findMany({
            select: {
                id: true,
                store_name: true,
                owner_name: true,
                status: true,

                subscriptions: {
                    select: {
                        ends_at: true,
                        plan: {
                            select: {
                                name: true,                                
                            },
                        },
                    },
                    orderBy: {ends_at: 'desc'},
                    take: 1,
                }
            },
            orderBy: {
                created_at: 'desc',
            },
        });
        return tenants;
    }

}
export default new TenantService();