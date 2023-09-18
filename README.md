# 音読スター
https://ondoku-star.com/  
→ 2023/09/18 サービス停止しました。

## サービス概要
英語の音読学習をすることができるサービス

## 実装機能
  - 音読機能  
    英文をタイピングゲームのような感じで音読をすることができる。（Web Speech APIを利用）  
    発音が正しくなく一定回数聞き取ってもらえなかった単語はチェックされ、後で振り返ることができる。
   ![gif_image1](https://github.com/chain792/read_aloud_checker/assets/97337735/d7e8595a-550a-4a30-a9fe-74e47389e16d)
  - 音読した音声の録音機能
  - 音読記録機能 (音読した単語数と精度を月毎にグラフ表示) 
    ![gif_image7](https://github.com/chain792/read_aloud_checker/assets/97337735/34044f47-db23-41d8-be21-11f644d6f787)

  - 音読履歴機能
  - 音読用英文のスクレイピング  
    ニュースサイトから音読用の英文を取得する処置を実装。
  - 英文検索機能  
    ![gif_image2](https://github.com/chain792/read_aloud_checker/assets/97337735/178920a9-74a2-4983-92aa-8ad2278a16a5)
  - ページネーション機能 
  - 英文の新規投稿順・人気順でのソート  
    ![gif_image3](https://github.com/chain792/read_aloud_checker/assets/97337735/685e3da2-8447-4299-be54-1826948383a0)
  - 英文のブックマーク機能
    ![gif_image4](https://github.com/chain792/read_aloud_checker/assets/97337735/46b3494f-d1a8-4f6c-9d75-9f7493a15378)
  - 音読する英文のCRUD機能 
    ![gif_image5](https://github.com/chain792/read_aloud_checker/assets/97337735/85304910-d9b5-4b71-9f4b-c4ef614c3e0d)
  - 英文の音声変換機能 (Amazon Pollyを利用)   
    英文を作成・編集した際に、作成した英文から音声に変更し、お手本の音声として再生する機能を実装。
  - 英文の音声の性別変更機能
  - カテゴリー機能　
  - 画像のトリミング機能  
    ![gif_image6](https://github.com/chain792/read_aloud_checker/assets/97337735/372f5f40-c991-4304-9bff-e2d76d1705dd)
  - ソーシャルログイン機能 (Twitter, Google, Yahoo) 
    ![スクリーンショット 2023-09-18 21 36 55](https://github.com/chain792/read_aloud_checker/assets/97337735/6197a84d-4d6d-4c0a-8e7a-d0958a2300b9)
  - パスワードリセット機能
  - メール送信機能 (Amazon SESを利用)

- ### 管理画面
  - 検索機能
  - ユーザーのCRUD機能 
  - 英文のCRUD機能 

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
  - rubocop  
  - capistrano  


# インフラ構成図
![infra drawio](https://user-images.githubusercontent.com/97337735/191248071-f07cfff5-5234-4c50-a5c8-bfeccb002f2a.png)

# 画面遷移図
https://www.figma.com/file/rj3SrRK6eHT9Y9IgWyifnX/%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3?node-id=0%3A1

# ER図
![er drawio](https://user-images.githubusercontent.com/97337735/201737676-6b14330b-16ec-4d54-a4d6-0a3cd9b6bf9b.png)
