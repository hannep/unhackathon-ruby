class AddConfirmation < ActiveRecord::Migration
  def change
    add_column :signups, :is_double_confirmed, :boolean, default: false
    add_column :signups, :location, :string
  end
end
