export function displayDate(createdAt: string): string {
  const [year, month, day, hour, minute] = createdAt.split(/[-\s:]/)
  const date = new Date()
  const currentYear = date.getFullYear()
  if(currentYear === Number(year)){
    return `${Number(month)}/${Number(day)} ${Number(hour)}:${minute}`
  }else{
    return `${year}/${Number(month)}/${Number(day)} ${Number(hour)}:${minute}`
  }
}