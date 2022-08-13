type ImageType = 'avatar'
interface S3Object {
  id: number
  avatar?: string
}

export function imageUrl(type: ImageType, object: S3Object): string {
  const basePath: string = import.meta.env.VITE_S3_BUCKET
  let imagePath = ''
  switch (type) {
    case 'avatar':
      if(!object.avatar){
        return 'cat.jpeg'
      }
      imagePath = `user/avatar/${object.id}/${object.avatar}`
  }
  return `${basePath}/uploads/${imagePath}`
}