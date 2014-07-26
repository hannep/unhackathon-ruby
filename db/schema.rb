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

ActiveRecord::Schema.define(version: 20140726173850) do

  create_table "signups", force: true do |t|
    t.string  "name"
    t.string  "school"
    t.string  "email"
    t.string  "isA"
    t.string  "cell_number"
    t.string  "best"
    t.string  "snack"
    t.string  "allergies"
    t.string  "drink"
    t.string  "shirt_size"
    t.boolean "vegetarian",  default: false
    t.boolean "vegan",       default: false
    t.boolean "kosher",      default: false
    t.boolean "halal",       default: false
    t.boolean "lactose",     default: false
    t.boolean "survey",      default: false
    t.boolean "survey_now",  default: false
  end

end
