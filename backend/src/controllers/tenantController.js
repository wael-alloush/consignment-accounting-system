import tenantService from "../services/tenantService.js";

class TenantController {
    async getTenants(req, res) {
        try {
            const tenants = await tenantService.getTenants();
            res.status(200).json({
                success: true,
                message: 'تم جلب المتاجر بنجاح',
                data: tenants,
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
export default new TenantController();