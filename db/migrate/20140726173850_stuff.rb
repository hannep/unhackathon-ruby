class Stuff < ActiveRecord::Migration
  def change
  	add_column :signups, :best, :string
  	add_column :signups, :snack, :string
  	add_column :signups, :allergies, :string
  	add_column :signups, :drink, :string
  	add_column :signups, :shirt_size, :string
  	add_column :signups, :vegetarian, :boolean, default: false
  	add_column :signups, :vegan, :boolean, default: false
  	add_column :signups, :kosher, :boolean, default: false
  	add_column :signups, :halal, :boolean, default: false
  	add_column :signups, :lactose, :boolean, default: false
  	add_column :signups, :survey, :boolean, default: false
  	add_column :signups, :survey_now, :boolean, default: false
  end
end
