import { Outlet } from 'react-router-dom';

/** تخطيط صفحات المصادقة فقط */
export default function AuthLayout() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-slate-100 px-4">
      <div className="w-full max-w-sm rounded-lg bg-white p-6 shadow-sm">
        <p className="mb-5 text-center text-base font-semibold text-slate-800">نظام الكمسيون</p>
        <Outlet />
      </div>
    </div>
  );
}
