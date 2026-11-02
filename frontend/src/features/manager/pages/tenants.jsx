import { TenantsTable } from "@/features/manager/components/table.jsx"
import { Button } from "@/components/ui/button.jsx"
import { PlusIcon } from "lucide-react"
import { useEffect } from "react";
import { useTenantsStore } from "../store/useTenantsStore.js";

export default function TenantsPage() {

  const { tenants, loading, error, fetchTenants } = useTenantsStore();

  useEffect(() => {
    fetchTenants();
  }, []);

  return (
    <>
    <div className=" flex flex-col gap-4  p-4 ">
      <div className="flex justify-between items-center " >
      <h1>قائمة المتاجر</h1>
      <Button variant="default" className="">
        <PlusIcon className="w-4 h-4" />
        اضافة متجر
      </Button>
      </div>
      <TenantsTable tenants={tenants} loading={loading} error={error} />

    </div>
    </>
  )
}