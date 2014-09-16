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

ActiveRecord::Schema.define(version: 20140916024250) do

  create_table "mentor_signups", force: true do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "email"
    t.string  "cell_number"
    t.string  "company"
    t.string  "software_skills"
    t.string  "design_skills"
    t.string  "hardware_skills"
    t.string  "other_skills"
    t.boolean "wants_to_judge"
    t.boolean "sunday0"
    t.boolean "sunday1"
    t.boolean "sunday2"
    t.boolean "sunday3"
    t.boolean "sunday4"
    t.boolean "saturday0"
    t.boolean "saturday1"
    t.boolean "saturday2"
    t.boolean "saturday3"
    t.boolean "saturday4"
    t.boolean "saturday5"
    t.boolean "saturday6"
    t.boolean "saturday7"
  end

  create_table "signups", force: true do |t|
    t.string  "name"
    t.string  "school"
    t.string  "email"
    t.string  "cell_number"
    t.string  "best"
    t.string  "snack"
    t.string  "allergies"
    t.string  "drink"
    t.string  "shirt_size"
    t.boolean "vegetarian",          default: false
    t.boolean "vegan",               default: false
    t.boolean "kosher",              default: false
    t.boolean "halal",               default: false
    t.boolean "is_validated",        default: false
    t.string  "validation_token"
    t.boolean "first_time"
    t.boolean "frontend_code"
    t.boolean "hardware_hacking"
    t.boolean "user_interface"
    t.boolean "design"
    t.boolean "ideas"
    t.boolean "mobile_apps"
    t.boolean "game_dev"
    t.boolean "data_science"
    t.boolean "something_else"
    t.text    "other_interest"
    t.integer "experience"
    t.text    "achieve_text"
    t.text    "new_skill_text"
    t.text    "improve_text"
    t.text    "future_text"
    t.string  "transit"
    t.boolean "cancelled",           default: false
    t.string  "status",              default: "none"
    t.boolean "is_highschool",       default: false
    t.boolean "is_double_confirmed", default: false
    t.string  "location"
    t.boolean "is_location_sent",    default: false
  end

end
