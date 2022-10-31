import { Sentence } from '@/@types/model.d';

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

export function thumbnailUrl(sentence: Sentence): string {
  if(!sentence.thumbnail){
    return '/favicon.png'
  }
  const imagePath = `sentence/thumbnail/${sentence.id}/${sentence.thumbnail}`

  return `${import.meta.env.VITE_CLOUD_FRONT}/public/${import.meta.env.MODE}/uploads/${imagePath}`
}

export function previewThumbnailUrl(sentence: Sentence | undefined): string | undefined {
  if(!sentence){
    return
  }

  if(!sentence.thumbnail){
    return
  }
  const imagePath = `sentence/thumbnail/${sentence.id}/${sentence.thumbnail}`

  return `${import.meta.env.VITE_CLOUD_FRONT}/public/${import.meta.env.MODE}/uploads/${imagePath}`
}