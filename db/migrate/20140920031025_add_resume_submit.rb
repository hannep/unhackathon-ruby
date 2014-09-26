class AddResumeSubmit < ActiveRecord::Migration
  def change
      create_table :resume_submits do |t|
          t.string :email
          t.column :resume, :binary
      end
  end
end
