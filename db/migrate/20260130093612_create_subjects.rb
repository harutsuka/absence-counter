class CreateSubjects < ActiveRecord::Migration[6.1]
  def change
    create_table :subjects do |t|
      t.string :name
      t.integer :absent_count
      t.integer :user_id
      t.timestamps
    end
  end
end
