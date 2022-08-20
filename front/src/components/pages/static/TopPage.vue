<template>
  <div>トップページです</div>
  <v-btn flat color="secondary" :size="a" class="ma-lg-5" @click="axiosTest">
    Secondary
  </v-btn>
  <v-btn flat color="secondary" :size="a" class="ma-lg-5" @click="start">
    start
  </v-btn>
  <v-btn flat color="secondary" :size="a" class="ma-lg-5" @click="stop">
    stop
  </v-btn>
  <!-- <audio ref="audio" src="" controls></audio> -->

    <a id="download">Download</a>
  <button id="stop">Stop</button>
</template>

<script setup lang="ts">
import { computed, ref } from "vue"
import { useDisplay } from "vuetify"
import axios from "@/plugins/axios"
import Axios from "axios"
const display = useDisplay()
const a = computed(() => {
  if (display.md.value) {
    return "large"
  } else {
    return "small"
  }
})

const axiosTest = () => {
  axios
    .get("users")
    .then((res) => {
      console.log('success')
      console.log(res)
    })
    .catch((e) => {
      console.log('fail')
      console.log(e)
    })
}


// var mediaRecorder: any;
// var localStream: any;
// const audio = ref<HTMLAudioElement>()


// const start = () => {
//       navigator.mediaDevices.getUserMedia({audio: true })
//         .then(function (stream) {
//           console.log(stream)
//             localStream = stream;
//             mediaRecorder = new MediaRecorder(stream);
//             console.log(mediaRecorder)
//             mediaRecorder.start();
//             console.log("Status: " + mediaRecorder.state);
//         }).catch(function (err) {
//             console.log(err);
//         });
// }

// const stop = () => {
//     mediaRecorder.stop();
//     console.log(mediaRecorder)
//     console.log("Status: " + mediaRecorder.state);
//     mediaRecorder.ondataavailable = function (event) {
//       const blob_url = window.URL.createObjectURL(event.data)
//         audio.value!.src = blob_url
//         console.log(event.data)
//         uploadAvatarToS3(event.data)

//         // audio.value!.onloadeddata = (e) => {
//         //   console.log(e)
//         //   window.URL.revokeObjectURL(blob_url)
//         // }
//     }
//     localStream.getTracks().forEach(track => {
//       console.log(track)
//       track.stop()});
// }

// const uploadAvatarToS3 = async (file: File | null): Promise<void> => {
//   if(!file) return

//   try{
//     const res = await axios.get("sentences/presign", {
//       params: {
//         name: 'test'
//       }
//     })
//     const formData = new FormData()
//     for(let key in res.data.fields) {
//       formData.append(key, res.data.fields[key])
//     }
//     formData.append('file', file)
//     console.log(formData)
//     await Axios.post(res.data.url, formData, {
//       headers: {
//         'accept': 'multipart/form-data'
//       }
//     })
//   } catch(e) {
//     console.log(e)
//   }
// }



</script>

<style scoped></style>
