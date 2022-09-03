import { createApp } from "vue"
import App from "./App.vue"
import router from "./router"
import vuetify from "./plugins/vuetify"
import { loadFonts } from "./plugins/webfontloader"
import { createPinia } from "pinia"
import VueGtag from "vue-gtag";

loadFonts()

const app = createApp(App).use(router)

if(import.meta.env.PROD){
  app.use(VueGtag, {
    config: { 
      id: import.meta.env.VITE_GA4_ID,
    },
  }, router)
}

app.use(vuetify).use(createPinia()).mount("#app")
