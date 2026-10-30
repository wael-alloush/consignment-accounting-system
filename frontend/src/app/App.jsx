import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import AuthLayout from './layouts/AuthLayout.jsx';
import LoginPage from '../features/auth/pages/LoginPage.jsx';
import RequireAuth from '../shared/guards/RequireAuth.jsx';
import { useUserStore } from '../shared/store/useUserStore.js';
import DashboardPage from './dashboard/DashboardPage.jsx';

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
              <DashboardPage />
            </RequireAuth>
          }
        />

        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
    </div>
  )
}
