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

ActiveRecord::Schema.define(version: 20150225061008) do

  create_table "external_mapping_maps", force: true do |t|
    t.integer  "mapped_id",     null: false
    t.string   "mapped_type",   null: false
    t.integer  "external_type", null: false
    t.string   "external_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "external_mapping_maps", ["mapped_type", "mapped_id", "external_type"], name: "index_unique_mapped_and_external", unique: true
  add_index "external_mapping_maps", ["mapped_type", "mapped_id"], name: "index_external_mapping_maps_on_mapped_type_and_mapped_id"

  create_table "mappeds", force: true do |t|
  end

end
