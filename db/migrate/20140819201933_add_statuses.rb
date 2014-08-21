class AddStatuses < ActiveRecord::Migration
  def change
  	add_column :signups, :status, :string, default: "none"
  end
end
