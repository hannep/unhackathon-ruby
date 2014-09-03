class AddMentors < ActiveRecord::Migration
  def change
    create_table :mentor_signups do |t|
        t.string :first_name
        t.string :last_name
        t.string :email
        t.string :cell_number
        t.string :company
        t.string :software_skills
        t.string :design_skills
        t.string :hardware_skills
        t.string :other_skills
        t.boolean :wants_to_judge
        (0..4).each {|x|
            t.boolean "sunday#{x}"
        }
        (0..7).each {|x|
            t.boolean "saturday#{x}"
        }
    end 
  end
end
