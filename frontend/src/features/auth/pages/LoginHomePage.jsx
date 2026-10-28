import { useNavigate } from 'react-router-dom';
import { useUserStore } from '../../../shared/store/useUserStore.js';

/** صفحة مؤقتة بعد نجاح الدخول — بدون لوحة تحكم */
export default function LoginHomePage() {
  const navigate = useNavigate();
  const user = useUserStore((s) => s.user);
  const logout = useUserStore((s) => s.logout);

  function handleLogout() {
    logout();
    navigate('/login', { replace: true });
  }

  return (
    <main className="mx-auto max-w-lg p-8">
      <h1 className="text-xl font-semibold text-slate-900">تم تسجيل الدخول</h1>
      <p className="mt-2 text-sm text-slate-600">مسار الدخول يعمل. لوحة التحكم ستُبنى لاحقاً.</p>

      <dl className="mt-6 space-y-2 rounded border border-slate-200 bg-white p-4 text-sm">
        <div className="flex justify-between gap-4">
          <dt className="text-slate-500">الاسم</dt>
          <dd className="font-medium text-slate-900">{user?.name}</dd>
        </div>
        <div className="flex justify-between gap-4">
          <dt className="text-slate-500">البريد</dt>
          <dd className="font-medium text-slate-900">{user?.email}</dd>
        </div>
        <div className="flex justify-between gap-4">
          <dt className="text-slate-500">الدور</dt>
          <dd className="font-medium text-slate-900">{user?.role}</dd>
        </div>
        <div className="flex justify-between gap-4">
          <dt className="text-slate-500">المتجر</dt>
          <dd className="font-medium text-slate-900">{user?.tenantId ?? '—'}</dd>
        </div>
      </dl>

      <button
        type="button"
        onClick={handleLogout}
        className="mt-6 rounded border border-slate-300 px-4 py-2 text-sm hover:bg-slate-50"
      >
        تسجيل الخروج
      </button>
    </main>
  );
}
