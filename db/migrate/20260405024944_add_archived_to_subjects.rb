class AddArchivedToSubjects < ActiveRecord::Migration[6.1]
  def change
    add_column :subjects, :archived, :boolean, default: false
  end
end
