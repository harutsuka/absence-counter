class AddDayToSubjects < ActiveRecord::Migration[6.1]
  def change
    add_column :subjects, :day, :string
  end
end
