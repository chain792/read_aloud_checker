# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_08_25_210531) do

  create_table "bookmarks", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "sentence_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sentence_id"], name: "index_bookmarks_on_sentence_id"
    t.index ["user_id", "sentence_id"], name: "index_bookmarks_on_user_id_and_sentence_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "news", charset: "utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "news_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["news_category_id"], name: "index_news_on_news_category_id"
  end

  create_table "news_categories", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "result_words", charset: "utf8mb4", force: :cascade do |t|
    t.string "training_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position", null: false
    t.integer "result", default: 0, null: false
    t.index ["training_id"], name: "index_result_words_on_training_id"
  end

  create_table "sentences", id: { type: :string, limit: 36 }, charset: "utf8mb4", force: :cascade do |t|
    t.string "creater_type", null: false
    t.bigint "creater_id", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "male_speech"
    t.string "female_speech"
    t.index ["creater_type", "creater_id"], name: "index_sentences_on_creater"
  end

  create_table "trainings", id: { type: :string, limit: 36 }, charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "sentence_id", null: false
    t.string "voice"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sentence_id"], name: "index_trainings_on_sentence_id"
    t.index ["user_id"], name: "index_trainings_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "name", null: false
    t.string "avatar"
    t.integer "role", default: 0, null: false
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "refresh_token"
    t.datetime "refresh_token_expires_at"
    t.string "oauth_avatar"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.integer "listening_sex", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["refresh_token"], name: "index_users_on_refresh_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "bookmarks", "sentences"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "news", "news_categories"
  add_foreign_key "result_words", "trainings"
  add_foreign_key "trainings", "sentences"
  add_foreign_key "trainings", "users"
end
