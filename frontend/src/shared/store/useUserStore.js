import { create } from 'zustand';
import { persist } from 'zustand/middleware';


export const useUserStore = create(persist((set) => ({
    user: null,
    token: null,
    tenantId: null,
    isAuthenticated: false,
    setAuth: (user, token) => {
        localStorage.setItem('token', token);
        if (user?.tenantId) {
            localStorage.setItem('tenantId', user.tenantId);
        }
        set({ user, token, tenantId: user?.tenantId || null, isAuthenticated: true });
    },
    logout: () => {
        localStorage.removeItem('token');
        localStorage.removeItem('tenantId');
        set({ user: null, token: null, tenantId: null, isAuthenticated: false });
      },
    }),
    {
      name: 'auth-storage',
    }
  )
);