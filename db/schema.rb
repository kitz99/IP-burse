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

ActiveRecord::Schema.define(version: 20150325113707) do

  create_table "application_extras", force: :cascade do |t|
    t.decimal  "value",          default: 0.0
    t.integer  "domain_data_id"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "application_extras", ["application_id"], name: "index_application_extras_on_application_id"
  add_index "application_extras", ["domain_data_id"], name: "index_application_extras_on_domain_data_id"

  create_table "applications", force: :cascade do |t|
    t.date     "submission_date"
    t.date     "approval_date"
    t.string   "status",          limit: 255
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "scholarship_id"
    t.integer  "user_id"
    t.integer  "on_card"
    t.text     "response"
    t.integer  "domain_id",                   default: 0
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "path",           limit: 255
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "period_id"
    t.integer  "scholarship_id"
  end

  add_index "documents", ["period_id"], name: "index_documents_on_period_id"
  add_index "documents", ["scholarship_id"], name: "index_documents_on_scholarship_id"

  create_table "domain_data", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "sort",       limit: 255
    t.integer  "domain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "domain_data", ["domain_id"], name: "index_domain_data_on_domain_id"

  create_table "domains", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.decimal  "money"
    t.integer  "order_number"
    t.integer  "scholarship_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "period_id"
    t.integer  "an_studiu"
    t.integer  "procent"
    t.string   "specializare"
  end

  add_index "domains", ["period_id"], name: "index_domains_on_period_id"
  add_index "domains", ["scholarship_id"], name: "index_domains_on_scholarship_id"

  create_table "news", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "content"
    t.datetime "post_date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news", ["user_id"], name: "index_news_on_user_id"

  create_table "papers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "user_uid"
    t.string   "document"
  end

  create_table "periods", force: :cascade do |t|
    t.date     "start"
    t.date     "end"
    t.integer  "buget"
    t.boolean  "activ"
    t.integer  "nr_stud"
    t.integer  "min_salary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scholarships", force: :cascade do |t|
    t.string   "stype",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "uid",           limit: 255
    t.string   "first_name",    limit: 255
    t.string   "last_name",     limit: 255
    t.string   "status",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token",         limit: 255
    t.string   "email",         limit: 255
    t.boolean  "is_student"
    t.boolean  "is_teacher"
    t.boolean  "is_management"
    t.boolean  "is_admin"
    t.string   "iban",          limit: 255
    t.string   "bank",          limit: 255
  end

end
