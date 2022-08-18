<template>
  <div id="footer-container">
  <v-footer
    class="bg-grey-lighten-1"
  >
    <v-row
      justify="center"
      no-gutters
    >
      <v-btn
        color="white"
        variant="text"
        class="mx-2"
        rounded="xl"
        :to="{ name: 'Terms' }"
      >
        利用規約
      </v-btn>
      <v-btn
        color="white"
        variant="text"
        class="mx-2"
        rounded="xl"
        :to="{ name: 'Privacy' }"
      >
        プライバシーポリシー
      </v-btn>
      <v-btn
        color="white"
        variant="text"
        class="mx-2"
        rounded="xl"
        href="https://docs.google.com/forms/d/e/1FAIpQLSfFvUX5OG5vdFZYL2qqrn5PTVzzi8FGost6k1xucXdta1qI2Q/viewform?usp=sf_link"
        target="_blank"
      >
        お問い合わせ
      </v-btn>
      <v-col
        class="text-center text-white mt-4"
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
</style>