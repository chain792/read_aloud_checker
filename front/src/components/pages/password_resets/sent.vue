<template>
  <v-card width="600" class="mx-auto mt-10 px-5 py-3">
    <v-card-item>
      <v-card-title class="text-center text-h5">メール送信完了</v-card-title>
    </v-card-item>
    <v-card-text class="mt-3">
      <div>
        再設定ページのURLをメールで送信いたしましたので、ご確認ください。<br>
      </div>
      <v-divider class="my-5"></v-divider>
      <p>メールが届かない場合は以下の場合が考えられます</p>
      <ul>
        <li>迷惑メールフォルダに入ってしまっている場合</li>
        <li>メールアドレスが間違っている場合</li>
        <li>メールアドレスが登録されていない場合</li>
      </ul>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
</script>

<style scoped>
ul{
  margin-block-start: 0.5em;
  margin-block-end: 0.5em;
  padding-inline-start: 20px;
}
</style>
