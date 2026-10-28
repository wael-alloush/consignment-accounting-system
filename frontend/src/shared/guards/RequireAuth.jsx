import { Navigate, useLocation } from 'react-router-dom';
import { useUserStore } from '../store/useUserStore.js';

/** يمنع دخول الصفحات المحمية بدون جلسة */
export default function RequireAuth({ children }) {
  const isAuthenticated = useUserStore((s) => s.isAuthenticated);
  const location = useLocation();

  if (!isAuthenticated) {
    return <Navigate to="/login" replace state={{ from: location }} />;
  }

  return children;
}
