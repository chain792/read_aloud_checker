export function role_i18n(role: string): string {
  if(role === "general"){
    return "一般"
  }else if(role === "admin"){
    return "管理者"
  }
  return ""
}