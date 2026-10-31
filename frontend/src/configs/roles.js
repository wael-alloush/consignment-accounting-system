import { HouseIcon, StoreIcon, ShoppingCartIcon  ,Package2Icon, WalletIcon} from "lucide-react"
export const roles = {
  super_admin: "super_admin",
  store_admin: "store_admin",
  cashier: "cashier",
  vendor: "vendor",
}

export const nav_items = [
    // super admin
    {icon: HouseIcon , title: "لوحة التحكم", path: "/dashboard" , allowedRoles: [roles.super_admin]},
    {icon: StoreIcon , title: "ادارة المتاجر", path: "/tanents" , allowedRoles: [roles.super_admin]},
    {icon: ShoppingCartIcon , title: "الاشتراكات", path: "/subscriptions" , allowedRoles: [roles.super_admin]},
    {icon: Package2Icon , title: "الباقات", path: "/packages" , allowedRoles: [roles.super_admin]},
    // store admin
    {icon: "HomeIcon" , title: "لوحة التحكم", path: "/dashboard-store" , allowedRoles: [roles.store_admin]},
    {icon: WalletIcon , title: "المبيعات", path: "/sales" , allowedRoles: [roles.store_admin ]},
    {icon: "StoreIcon" , title: "المنتجات", path: "/categories" , allowedRoles: [roles.store_admin]},
    {icon: "StoreIcon" , title: "الموردين", path: "/vendors" , allowedRoles: [roles.store_admin]},
    {icon: "StoreIcon" , title: "العملاء", path: "/customers" , allowedRoles: [roles.store_admin]},
    {icon: "StoreIcon" , title: "التقارير", path: "/reports" , allowedRoles: [roles.store_admin]},
    // cashier
 
]