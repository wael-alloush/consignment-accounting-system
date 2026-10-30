
import { NavDocuments } from "@/components/nav-documents"
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
import { LayoutDashboardIcon, ListIcon, ChartBarIcon, FolderIcon, UsersIcon, CameraIcon, FileTextIcon, Settings2Icon, CircleHelpIcon, SearchIcon, DatabaseIcon, FileChartColumnIcon, FileIcon, CommandIcon } from "lucide-react"
import { useUserStore } from "@/shared/store/useUserStore"
import logo from "@/assets/images/logo-on-light.png"

const data = {

  navMain: [
    {
      title: "لوحة التحكم",
      url: "#",
      icon: (
        <LayoutDashboardIcon
        />
      ),
    },
    {
      title: "دورة الحياة",
      url: "#",
      icon: (
        <ListIcon
        />
      ),
    },
    {
      title: "التحليلات",
      url: "#",
      icon: (
        <ChartBarIcon
        />
      ),
    },
    {
      title: "المشاريع",
      url: "#",
      icon: (
        <FolderIcon
        />
      ),
    },
    {
      title: "الفريق",
      url: "#",
      icon: (
        <UsersIcon
        />
      ),
    },
  ],
  navClouds: [
    {
      title: "التقاط",
      icon: (
        <CameraIcon
        />
      ),
      isActive: true,
      url: "#",
      items: [
        {
          title: "العروض النشطة",
          url: "#",
        },
        {
          title: "الأرشيف",
          url: "#",
        },
      ],
    },
    {
      title: "عرض",
      icon: (
        <FileTextIcon
        />
      ),
      url: "#",
      items: [
        {
          title: "العروض النشطة",
          url: "#",
        },
        {
          title: "الأرشيف",
          url: "#",
        },
      ],
    },
    {
      title: "الأوامر",
      icon: (
        <FileTextIcon
        />
      ),
      url: "#",
      items: [
        {
          title: "العروض النشطة",
          url: "#",
        },
        {
          title: "الأرشيف",
          url: "#",
        },
      ],
    },
  ],
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
  documents: [
    {
      name: "مكتبة البيانات",
      url: "#",
      icon: (
        <DatabaseIcon
        />
      ),
    },
    {
      name: "التقارير",
      url: "#",
      icon: (
        <FileChartColumnIcon
        />
      ),
    },
    {
      name: "مساعد المستندات",
      url: "#",
      icon: (
        <FileIcon
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
  return (
    <Sidebar collapsible="offcanvas" {...props}>
      <SidebarHeader>
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton
              className="data-[slot=sidebar-menu-button]:p-1.5!"
              render={<a href="#" />}
            >
              {/* <CommandIcon className="size-5!" /> */}
              <img src={logo} alt="logo" className="size-6!" />
              <span className="text-base font-semibold">كمسيون</span>
            </SidebarMenuButton>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>
      <SidebarContent>
        <NavMain items={data.navMain} />
        <NavDocuments items={data.documents} />
        <NavSecondary items={data.navSecondary} className="mt-auto" />
      </SidebarContent>
      <SidebarFooter>
        <NavUser user={sidebarUser} />
      </SidebarFooter>
    </Sidebar>
  )
}
