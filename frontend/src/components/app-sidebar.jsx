
// import { NavDocuments } from "@/components/nav-documents"
import { NavMain } from "@/components/nav-main"
import { NavSecondary } from "@/components/nav-secondary"
import { NavUser } from "@/components/nav-user"
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from "@/components/ui/sidebar"
import { Settings2Icon, CircleHelpIcon, SearchIcon } from "lucide-react"
import { useUserStore } from "@/shared/store/useUserStore"
import { nav_items } from "@/configs/roles"
import logo from "@/assets/images/logo-on-light.png"

const data = {


  navSecondary: [
    {
      title: "الإعدادات",
      url: "#",
      icon: (
        <Settings2Icon
        />
      ),
    },
    {
      title: "المساعدة",
      url: "#",
      icon: (
        <CircleHelpIcon
        />
      ),
    },
    {
      title: "بحث",
      url: "#",
      icon: (
        <SearchIcon
        />
      ),
    },
  ],
  
}
export function AppSidebar({
  ...props
}) {

  const user = useUserStore((s) => s.user)
  const sidebarUser = {
    name: user.name,
    role: user.role,
    email: user.email,
    avatar: logo
  }
  const visibleNavItems = nav_items.filter((item) => user?.role ? item.allowedRoles.includes(user.role) : false)
  return (
    <Sidebar collapsible="offcanvas" {...props}>
      <SidebarHeader>
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton
              className="data-[slot=sidebar-menu-button]:p-1.5!"
              render={<a href="#" />}
            >
              
              <img src={logo} alt="logo" className="size-15!" />
              <span className=" font-semibold text-xl">كمسيون</span>
            </SidebarMenuButton>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>
      <SidebarContent>
        <NavMain items={visibleNavItems} />
        {/* <NavDocuments items={data.documents} /> */}
        <NavSecondary items={data.navSecondary} className="mt-auto" />
      </SidebarContent>
      <SidebarFooter>
        <NavUser user={sidebarUser} />
      </SidebarFooter>
    </Sidebar>
  )
}
