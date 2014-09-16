class AddInfoSent < ActiveRecord::Migration
  def change
    add_column :signups, :is_location_sent, :boolean, default: false
  end
end
