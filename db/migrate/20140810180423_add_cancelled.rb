class AddCancelled < ActiveRecord::Migration
  def change
    add_column :signups, :cancelled, :boolean, default: false
  end
end
