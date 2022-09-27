interface User {
  id: number
  avatar?: string
}

export function avatarUrl(user: User): string {
  let imagePath = ''

  if(!user.avatar){
    return '/default.png'
  }
  imagePath = `user/avatar/${user.id}/${user.avatar}`

  return `${import.meta.env.VITE_CLOUD_FRONT}/public/${import.meta.env.MODE}/uploads/${imagePath}`
}