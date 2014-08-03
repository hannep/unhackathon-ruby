class NewFields < ActiveRecord::Migration
  def change
      change_table :signups do |t|
          t.remove :isA
          t.remove :survey
          t.remove :survey_now
          t.remove :lactose

          t.boolean :first_time
          t.boolean :frontend_code
          t.boolean :hardware_hacking
          t.boolean :user_interface
          t.boolean :design
          t.boolean :ideas
          t.boolean :mobile_apps
          t.boolean :game_dev
          t.boolean :data_science
          t.boolean :something_else
          
          t.text :other_interest

          t.integer :experience

          t.text :achieve_text
          t.text :new_skill_text
          t.text :improve_text
          t.text :future_text
      end
  end
end
