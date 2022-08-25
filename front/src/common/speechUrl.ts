interface S3Object {
  id: string
  maleSpeech: string
  femaleSpeech: string
}
type Sex = 'male' | 'female'

export function speechUrl(object: S3Object, sex: Sex): string {
  let speechPath = ''
  switch (sex) {
    case 'male':
      speechPath = `sentence/speech/${object.id}/${object.maleSpeech}`
      break
    case 'female':
      speechPath = `sentence/speech/${object.id}/${object.femaleSpeech}`
      break
  }
  return `${import.meta.env.VITE_CLOUD_FRONT}/public/${import.meta.env.MODE}/uploads/${speechPath}.mp3`
}