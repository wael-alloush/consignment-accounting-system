import { Outlet } from 'react-router-dom';

/** تخطيط صفحات المصادقة فقط */
export default function AuthLayout() {
  return (
    <div>
      
        <Outlet />
    </div>  
  );
}
