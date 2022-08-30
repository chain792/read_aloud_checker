<template>
  <v-app>
    <Header v-if="userStore.authUser" />
    <HeaderBeforeLoginVue v-else />
    <FlashMessage />
    <v-main>
      <router-view />
    </v-main>
    <Footer />
  </v-app>
</template>

<script setup lang="ts">
import Header from './components/shared/Header.vue'
import HeaderBeforeLoginVue from './components/shared/HeaderBeforeLogin.vue'
import Footer from './components/shared/Footer.vue'
import FlashMessage from './components/shared/FlashMessage.vue'
import { useUserStore } from './store/userStore'

const userStore = useUserStore()

</script>

<style>
/***************************************************
  ページ全体
 ***************************************************/
body{
  font-family: "Helvetica Neue", "Hiragino Kaku Gothic ProN", Meiryo, sans-serif;
}

.link-text{
  text-decoration: none;
}

.link-text:hover{
  text-decoration: underline;
}

/***************************************************
  vuetify
 ***************************************************/
.v-input__details{
  margin-bottom: 12px !important;
}

/***************************************************
  モーダル
 ***************************************************/
 .modal{
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  background-color: rgba(0,0,0,.3);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  z-index: 2000;
}

.modal-content{
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 3000;
}

/***************************************************
  サイドメニュー
 ***************************************************/
 .side-menu{
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  right: 40%;
  z-index: 4000;
}

.side-menu .v-list{
  height: 100%;
}

.side-menu .v-list-item{
  padding-inline-start: 20px !important;
  padding-inline-end: 20px !important;
  padding-top: 12px;
  padding-bottom: 12px;
}

.side-menu .v-list-item-title{
  font-size: 1.1rem !important;
}

/***************************************************
  ソーシャルログイン
 ***************************************************/
 /* twitter */
.twitter-btn{
  background-color: #55acee;
}

.twitter-btn:hover{
  background-color: #55a8ee;
}

.twitter-btn .v-btn__prepend{
  padding-top: 3px;
  color: white;
}

.mdi-twitter{
  margin-left: -2px;
  font-size: 20px;
}

 /* google */
.google-logo{
  width: 38px;
  height: 38px;
  margin-left: -10px;
  margin-right: 3px;
  object-fit: none;
}

 /* yahoo */
.yahoo-btn{
  border: 1px solid #ff0033;
}

.yahoo-logo{
  position: absolute;
  width: 32px;
  height: 18px;
  left: 10px;
}

.yahoo-text-container{
  position: absolute;
  height: 100%;
  width: calc(100% - 52px);
  left: 52px;
  background-color: #ff0033;
  border-radius: 1px;
}

.yahoo-text{
  color: #fff;
  margin-top: 8px;
  margin-left: -15px;
}

</style>
