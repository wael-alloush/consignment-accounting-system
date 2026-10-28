import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { loginRequest } from '../api/authApi.js';
import { useUserStore } from '../../../shared/store/useUserStore.js';

export default function LoginPage() {
  const navigate = useNavigate();
  const setAuth = useUserStore((s) => s.setAuth);

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const result = await loginRequest(email, password);
      if (!result.success) {
        setError(result.message || 'فشل تسجيل الدخول');
        return;
      }
      const { token, user } = result.data;
      setAuth(user, token);
      navigate('/', { replace: true });
    } catch (err) {
      const message =
        err.response?.data?.message || err.message || 'تعذر الاتصال بالخادم';
      setError(message);
    } finally {
      setLoading(false);
    }
  }

  return (
    <>

    <form onSubmit={handleSubmit} className="flex w-full flex-col gap-3">
      <div>
        <h1 className="text-xl font-semibold text-slate-900">تسجيل الدخول</h1>
        <p className="mt-1 text-sm text-slate-600">أدخل بريدك وكلمة المرور للمتابعة</p>
      </div>

      <label className="flex flex-col gap-1 text-sm text-slate-700">
        البريد الإلكتروني
        <input
          type="email"
          required
          autoComplete="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="rounded border border-slate-300 px-3 py-2 outline-none focus:border-slate-500"
        />
      </label>

      <label className="flex flex-col gap-1 text-sm text-slate-700">
        كلمة المرور
        <input
          type="password"
          required
          autoComplete="current-password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="rounded border border-slate-300 px-3 py-2 outline-none focus:border-slate-500"
        />
      </label>

      {error ? (
        <p className="rounded border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700" role="alert">
          {error}
        </p>
      ) : null}

      <button
        type="submit"
        disabled={loading}
        className="rounded bg-slate-900 px-4 py-2 text-white hover:bg-slate-800 disabled:opacity-60"
      >
        {loading ? 'جارٍ الدخول…' : 'دخول'}
      </button>
    </form>
    </>
  );
}
