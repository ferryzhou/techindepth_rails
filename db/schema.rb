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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130101004123) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.text     "content"
    t.datetime "pubdate"
    t.integer  "magzine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wpid"
  end

  add_index "articles", ["magzine_id"], :name => "index_articles_on_magzine_id"

  create_table "magzines", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
