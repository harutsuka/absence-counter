class CreateUserSubject < ActiveRecord::Migration[6.1]
  def change
    create_table :user_subject do |t|
      t.integer :user_id
      t.integer :subject_id

      t.timestamps
    end
  end
end
