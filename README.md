# read_aloud_checker

## サービス概要
タイピングゲームの感覚で英語の音読学習をすることができるサービス

## メインのターゲットユーザー
- 英語を学習している人
- 英語の音読が続かず挫折する人

## ユーザーが抱える課題
英語力UPに音読が効果的なことは分かっているが続かない。  
音読自体がつまらなく飽きてしまう。  
同じ文章を何度も繰り返し音読するのが大事だと言われているが、やった成果が目に見えないのでサボってしまう。  
どの文章を音読すればいいか分からない。  

## 解決方法
ゲーム感覚で音読をすることで楽しく音読を続けることができる。  
音読した量を可視化することでモチベーションをアップできる。  
音読する文章をサービスが用意してくれる。  

## 実装予定の機能
- ### 全ユーザー
  - 音読機能  
    英文をタイピングゲームのような感じで音読をすることができる。（Web Speech APIを利用）  
    発音が正しくなく一定回数聞き取ってもらえなかった単語はチェックされ、後で振り返ることができる。
  - 音読用英文の提供機能  
    外部APIを利用して音読用の英文を提供する。(News APIを利用？)

- ### 登録済みのユーザー
  - 音読量記録機能  
    音読した単語数を記録することができる。
  - 音声録音機能  
    音読した音声を録音して保存できる
  - 音読する英文のCRUD機能  

## なぜこのサービスを作りたいのか？
プログラミングの学習を進める中で英語で書かれたページを読んだり、英語で解説されてある動画を見る機会が増え、英語の重要性を改めて感じました。
英語力を伸ばそうと英語の勉強方法について調べてみると、音読は英語の上達に効果的という意見が多くありました。
そこで、音読を始めようと意気込んだのですが、ユーザーが抱える課題により続かず挫折してしまいました。
なので、音読を挫折せず楽しく続けることができるサービスがあればいいなと思ったのがきっかけです。

## 主な使用技術
### フロントエンド
- Vite 2.9.9  
- Vue.js 3.2.25  
- vuetify 3(β)  
- vue-router  
- Pinia  
- Vitest  
### バックエンド
- Ruby 3.1.2  
- Ruby on Rails(API モード) 6.1.6  
- 主なGem
  - sorcery  
  - jwt  
  - alba  
  - rspec-rails  

## スケジュール
企画〜技術調査：7/4〆切  
README〜ER図作成：7/10〆切  
メイン機能実装：7/11 - 8/10  
β版をRUNTEQ内リリース（MVP）：8/10〆切  
本番リリース：8月末 


# 画面遷移図
https://www.figma.com/file/rj3SrRK6eHT9Y9IgWyifnX/%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3?node-id=0%3A1

# ER図
https://gyazo.com/973cdb9ba2e197f54241f07e4a8883e0
