interface S3Object {
  id: string
  maleSpeech: string
  femaleSpeech: string
}

interface User {
  id: number
  email: string
  name: string
  avatar: string
  listeningSex?: "male" | "female"
  createdAt: string
  updatedAt: string
}

type AuthUser = User | null

export function speechUrl(object: S3Object, user: AuthUser): string {
  let speechPath = ''
  if(!user || !user.listeningSex){
    speechPath = `sentence/speech/${object.id}/${object.femaleSpeech}`
  }else{
    switch (user.listeningSex) {
      case 'male':
        speechPath = `sentence/speech/${object.id}/${object.maleSpeech}`
        break
      case 'female':
        speechPath = `sentence/speech/${object.id}/${object.femaleSpeech}`
        break
      default:
        speechPath = `sentence/speech/${object.id}/${object.femaleSpeech}`
    }
  }

  return `${import.meta.env.VITE_CLOUD_FRONT}/public/${import.meta.env.MODE}/uploads/${speechPath}.mp3`
}