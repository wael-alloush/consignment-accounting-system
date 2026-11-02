"use client"

import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { Badge } from "@/components/ui/badge"


   const values = {
     store_name: " المتجر",
     owner_name: " المالك",
     plan_name: "الباقة",
     status: "الحالة",
    end_date: "تاريخ الانتهاء",
  }



// const invoices = [
//   {
//     invoice: "INV001",
//     paymentStatus: "paid",
//     totalAmount: "$250.00",
//     paymentMethod: "creditCard",
//   },
//   {
//     invoice: "INV002",
//     paymentStatus: "pending",
//     totalAmount: "$150.00",
//     paymentMethod: "paypal",
//   },
//   {
//     invoice: "INV003",
//     paymentStatus: "unpaid",
//     totalAmount: "$350.00",
//     paymentMethod: "bankTransfer",
//   },
//   {
//     invoice: "INV004",
//     paymentStatus: "paid",
//     totalAmount: "$450.00",
//     paymentMethod: "creditCard",
//   },
//   {
//     invoice: "INV005",
//     paymentStatus: "paid",
//     totalAmount: "$550.00",
//     paymentMethod: "paypal",
//   },
//   {
//     invoice: "INV006",
//     paymentStatus: "pending",
//     totalAmount: "$200.00",
//     paymentMethod: "bankTransfer",
//   },
//   {
//     invoice: "INV007",
//     paymentStatus: "unpaid",
//     totalAmount: "$300.00",
//     paymentMethod: "creditCard",
//   },
// ]

export function TenantsTable({ tenants, loading, error }) {
  if (loading) return <div>جاري التحميل...</div>;
  if (error) return <div>Error: {error}</div>;
  if (tenants.length === 0) return <div>لا يوجد متاجر</div>;
  return (
    <div className="border border-border rounded-lg">

    <Table dir="rtl"   className="w-full "    >
      <TableHeader className={"bg-sidebar"}>
        <TableRow>
          <TableHead className="text-start">{values.store_name}</TableHead>
          <TableHead>{values.owner_name}</TableHead>
          <TableHead>{values.plan_name}</TableHead>
          <TableHead>{values.status}</TableHead>
          <TableHead>{values.end_date}</TableHead>
        </TableRow>
      </TableHeader>
        <TableBody >
          {tenants.map((tenant) => (
          <TableRow key={tenant.id} className=" border-t border-b border-border bg-background hover:bg-primary/10" >
            <TableCell className="text-start p-3">{tenant.store_name}</TableCell>
            <TableCell className="p-3">{tenant.owner_name}</TableCell>
            <TableCell className="p-3">{tenant.subscriptions[0]?.plan?.name || 'لا يوجد باقة'}</TableCell>
            <TableCell className="p-3">{<Badge className={tenant.status === 'active' ? 'bg-green-700/70 text-white '
               : tenant.status === 'expired' || tenant.status === 'suspended' ? 'bg-red-700/70 text-white'
               : 'bg-yellow-100 text-yellow-900 dark:bg-yellow-950 dark:text-yellow-300'}>
                {tenant.status === 'active' ? 'فعال' : tenant.status === 'expired' ? 'منتهي'
               : tenant.status === 'suspended' ? 'معلق' : 'لا يوجد حالة'}</Badge>}</TableCell>
            <TableCell className="p-3">{ tenant.subscriptions[0]?.ends_at ? new Date(tenant.subscriptions[0]?.ends_at).toLocaleDateString("ar") : 'لا يوجد تاريخ انتهاء'}</TableCell>
          </TableRow>
        ))}
      </TableBody>
   
    </Table>
    </div>
  )
}
