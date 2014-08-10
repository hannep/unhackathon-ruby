class AddTransit < ActiveRecord::Migration
  def change
    add_column :signups, :transit, :string
  end
end
