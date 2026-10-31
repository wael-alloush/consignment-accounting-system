"use client"

import {
  Table,
  TableBody,
  TableCaption,
  TableCell,
  TableFooter,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"

const translations = {

    dir: "rtl",
    values: {
      caption: "قائمة بفواتيرك الأخيرة.",
      invoice: "الفاتورة",
      status: "الحالة",
      method: "الطريقة",
      amount: "المبلغ",
      paid: "مدفوع",
      pending: "قيد الانتظار",
      unpaid: "غير مدفوع",
      creditCard: "بطاقة ائتمانية",
      paypal: "PayPal",
      bankTransfer: "تحويل بنكي",
      total: "المجموع",
    },
  }



const invoices = [
  {
    invoice: "INV001",
    paymentStatus: "paid",
    totalAmount: "$250.00",
    paymentMethod: "creditCard",
  },
  {
    invoice: "INV002",
    paymentStatus: "pending",
    totalAmount: "$150.00",
    paymentMethod: "paypal",
  },
  {
    invoice: "INV003",
    paymentStatus: "unpaid",
    totalAmount: "$350.00",
    paymentMethod: "bankTransfer",
  },
  {
    invoice: "INV004",
    paymentStatus: "paid",
    totalAmount: "$450.00",
    paymentMethod: "creditCard",
  },
  {
    invoice: "INV005",
    paymentStatus: "paid",
    totalAmount: "$550.00",
    paymentMethod: "paypal",
  },
  {
    invoice: "INV006",
    paymentStatus: "pending",
    totalAmount: "$200.00",
    paymentMethod: "bankTransfer",
  },
  {
    invoice: "INV007",
    paymentStatus: "unpaid",
    totalAmount: "$300.00",
    paymentMethod: "creditCard",
  },
]

export function TanentsTable() {

  return (
    <Table dir="rtl">
      <TableCaption>{translations.values.caption}</TableCaption>
      <TableHeader>
        <TableRow>
          <TableHead className="w-[100px]">{translations.values.invoice}</TableHead>
          <TableHead>{translations.values.status}</TableHead>
          <TableHead>{translations.values.method}</TableHead>
          <TableHead className="text-right">{translations.values.amount}</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        {invoices.map((invoice) => (
          <TableRow key={invoice.invoice}>
            <TableCell className="font-medium">{invoice.invoice}</TableCell>
            <TableCell>{invoice.paymentStatus}</TableCell>
            <TableCell>{invoice.paymentMethod}</TableCell>
            <TableCell className="text-right">{invoice.totalAmount}</TableCell>
          </TableRow>
        ))}
      </TableBody>
      <TableFooter>
        <TableRow>
          <TableCell colSpan={3}>{translations.values.total}</TableCell>
          <TableCell className="text-right">$2,500.00</TableCell>
        </TableRow>
      </TableFooter>
    </Table>
  )
}
