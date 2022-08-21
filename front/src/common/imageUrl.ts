type ImageType = 'avatar'
interface S3Object {
  id: number
  avatar?: string
}

export function imageUrl(type: ImageType, object: S3Object): string {
  let imagePath = ''
  switch (type) {
    case 'avatar':
      if(!object.avatar){
        return 'cat.jpeg'
      }
      imagePath = `user/avatar/${object.id}/${object.avatar}`
  }
  return `${import.meta.env.VITE_CLOUD_FRONT}/public/${import.meta.env.MODE}/uploads/${imagePath}`
}