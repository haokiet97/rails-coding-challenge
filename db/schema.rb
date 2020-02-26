# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190726235403) do

  create_table "notes", force: true do |t|
    t.integer  "contact_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activity_type"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.text     "data"
  end

  create_table "people", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_1"
    t.string   "email"
    t.string   "website"
    t.string   "twitter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "accessed_at"
    t.string   "skype"
    t.text     "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "post_code"
    t.string   "country"
    t.string   "business_name"
    t.string   "phone_2"
    t.string   "phone_3"
    t.string   "phone_1_label"
    t.string   "phone_2_label"
    t.string   "phone_3_label"
    t.string   "account_status"
    t.datetime "last_note_at"
    t.text     "position"
    t.text     "credentials"
    t.text     "superpowers"
    t.string   "type"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: true do |t|
    t.string "name"
  end

end
