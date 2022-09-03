<template>
  <div id="footer-container">
  <v-footer
    class="bg-grey-lighten-1"
  >
    <v-row
      justify="center"
      no-gutters
    >
      <router-link
        class="mx-5 link-text text-white text-body-2"
        :to="{ name: 'Terms' }"
      >
        利用規約
      </router-link>
      <router-link
        class="mx-5 link-text text-white text-body-2"
        :to="{ name: 'Privacy' }"
      >
        プライバシーポリシー
      </router-link>
      <a
        class="mx-5 link-text text-white text-body-2"
        href="https://docs.google.com/forms/d/e/1FAIpQLSfFvUX5OG5vdFZYL2qqrn5PTVzzi8FGost6k1xucXdta1qI2Q/viewform?usp=sf_link"
        target="_blank"
      >
        お問い合わせ
      </a>
      <a :href="`https://twitter.com/intent/tweet?&text=音読スターは発音した音声がリアルタイムで反映される音読学習アプリ。%0A初心者からTOEICストアを上げたい人まで日々の英語学習をサポートします%0A&hashtags=音読スター%0Ahttps://ondoku-star.com/`" class="text-xl share-link" target="_blank" ><v-icon class="share">mdi-twitter</v-icon></a>
      <v-col
        class="text-center text-white mt-3"
        cols="12"
      >
        <p class="text-body-2">Copyright © 2022. 音読スター All Rights Reserved.</p>
      </v-col>
    </v-row>
  </v-footer>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped>
.share{
  color: white !important;
  margin-top: -3px;
  margin-left: 5px;

}
.share-link{
  text-decoration: none;
}
</style>
