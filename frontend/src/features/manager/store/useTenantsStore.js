import { create } from 'zustand';
import { getTenantsRequest } from '../api/managerAuth.js';

export const useTenantsStore = create((set) => ({
    tenants: [],
    loading: false,
    error: null,


    fetchTenants: async () => {
        set({ loading: true, error: null });
        try {
            const res = await getTenantsRequest();
            set({ tenants: res ?? [], loading: false });
        } catch (error) {
            set({ error: error.response?.data?.message || 'فشل في جلب المتاجر',loading: false });
        }
    }
}));