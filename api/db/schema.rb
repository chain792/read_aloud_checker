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

ActiveRecord::Schema.define(version: 2022_10_26_074510) do

  create_table "authentications", charset: "utf8mb4", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.string "image"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "bookmarks", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "sentence_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sentence_id"], name: "index_bookmarks_on_sentence_id"
    t.index ["user_id", "sentence_id"], name: "index_bookmarks_on_user_id_and_sentence_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "categories", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "news", charset: "utf8mb4", force: :cascade do |t|
    t.string "title", null: false
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

  create_table "sentence_categories", charset: "utf8mb4", force: :cascade do |t|
    t.string "sentence_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_sentence_categories_on_category_id"
    t.index ["sentence_id", "category_id"], name: "index_sentence_categories_on_sentence_id_and_category_id", unique: true
    t.index ["sentence_id"], name: "index_sentence_categories_on_sentence_id"
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
    t.string "thumbnail"
    t.integer "word_count"
    t.index ["creater_type", "creater_id"], name: "index_sentences_on_creater"
  end

  create_table "trainings", id: { type: :string, limit: 36 }, charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "sentence_id", null: false
    t.string "voice"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title", null: false
    t.text "body", null: false
    t.string "male_speech"
    t.string "female_speech"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "refresh_token"
    t.datetime "refresh_token_expires_at"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.integer "listening_sex", default: 0, null: false
    t.integer "email_status", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["refresh_token"], name: "index_users_on_refresh_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "authentications", "users"
  add_foreign_key "bookmarks", "sentences"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "result_words", "trainings"
  add_foreign_key "sentence_categories", "categories"
  add_foreign_key "sentence_categories", "sentences"
  add_foreign_key "trainings", "sentences"
  add_foreign_key "trainings", "users"
end
