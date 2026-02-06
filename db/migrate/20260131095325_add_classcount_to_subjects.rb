class AddClasscountToSubjects < ActiveRecord::Migration[6.1]
  def change
    add_column :subjects, :class_count, :integer
  end
end
