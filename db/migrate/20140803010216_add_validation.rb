class AddValidation < ActiveRecord::Migration
  def change
    add_column :signups, :is_validated, :boolean, default: false
    add_column :signups, :validation_token, :string
  end
end
