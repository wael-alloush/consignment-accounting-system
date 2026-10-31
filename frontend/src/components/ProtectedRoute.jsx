import { Navigate , Outlet} from "react-router-dom"
import { useUserStore } from "@/shared/store/useUserStore"

export default function ProtectedRoute({ allowedRoles }) {
    const { user, isAuthenticated } = useUserStore();
    if (!isAuthenticated) {
        return <Navigate to="/login" />
    }
    if (allowedRoles && !allowedRoles.includes(user.role)) {
        return <Navigate to="/" />
    }
    return <Outlet />
}