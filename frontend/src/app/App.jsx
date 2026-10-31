import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import AuthLayout from './layouts/AuthLayout.jsx';
import LoginPage from '../features/auth/pages/LoginPage.jsx';
import RequireAuth from '../shared/guards/RequireAuth.jsx';
import { useUserStore } from '../shared/store/useUserStore.js';
import DashboardLayout from './layouts/DashboardLayout.jsx';
import TanentsPage from '../features/manager/pages/tanents.jsx';
import HomeDashboard from './dashboard/HomeDashboard.jsx';
import ProtectedRoutes from '../components/ProtectedRoute.jsx';
import {roles} from '../configs/roles.js';
function PublicOnly({ children }) {
  const isAuthenticated = useUserStore((s) => s.isAuthenticated);
  if (isAuthenticated) {
    return <Navigate to="/" replace />;
  }
  return children;
}

export default function App() {
  return (
    <div >
    <BrowserRouter dir="rtl">
      <Routes>
        <Route
          element={
            <PublicOnly>
              <AuthLayout />
            </PublicOnly>
          }
        >
          <Route path="/login" element={<LoginPage />} />
        </Route>

        <Route
          path="/"
          element={
            <RequireAuth>
            <DashboardLayout />
            </RequireAuth>
          }
        >
          <Route index element={<HomeDashboard />} />
          <Route element={<ProtectedRoutes allowedRoles={[roles.super_admin]} />} >
            <Route path="/tanents" element={<TanentsPage />} />
          </Route>

        </Route>


        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
    </div>
  )
}
