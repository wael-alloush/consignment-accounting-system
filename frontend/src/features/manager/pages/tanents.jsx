import { TanentsTable } from "../components/table.jsx"
export default function TanentsPage() {

  return (
    <>
    <div className="p-4 md:p-6 flex flex-col gap-4">
      <h1>قائمة المتاجر</h1>
      <TanentsTable />

    </div>
    </>
  )
}