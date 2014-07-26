class Signups < ActiveRecord::Migration
  def change
  	create_table :signups do |t|
  		t.string :name
  		t.string :school
  		t.string :email
  		t.string :isA
  		t.string :cell_number
  	end	
  end
end
