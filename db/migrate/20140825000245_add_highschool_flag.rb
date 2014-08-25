class AddHighschoolFlag < ActiveRecord::Migration
  def change
    add_column :signups, :is_highschool, :boolean, default: false
  end
end
