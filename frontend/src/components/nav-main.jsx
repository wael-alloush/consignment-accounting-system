import {
  SidebarGroup,
  SidebarGroupContent,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from "@/components/ui/sidebar"
import { useNavigate } from "react-router-dom"
export function NavMain({
  items
}) {
  const navigate = useNavigate()
  return (
    <SidebarGroup>
      <SidebarGroupContent className="flex flex-col gap-2">
        <SidebarMenu>
       
        </SidebarMenu>
        <SidebarMenu>
          {items.map((item) => (
            <SidebarMenuItem key={item.title} >
              <SidebarMenuButton 
              onClick={() => {
                navigate(item.path)
              }}
              tooltip={item.title} 
              className="hover:bg-primary/90 hover:text-primary-foreground">
              { <item.icon className="size-4!" />}
                <span className=" font-semibold text-xs">{item.title}</span>
              </SidebarMenuButton>
            </SidebarMenuItem>
          ))}
        </SidebarMenu>
      </SidebarGroupContent>
    </SidebarGroup>
  )
}
