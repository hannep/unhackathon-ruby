class AddDoubleLeftoverSent < ActiveRecord::Migration
  def change
    add_column :signups, :is_leftover_double_sent, :boolean, default: false
  end
end
