class AddAbsentRatioToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :absent_ratio, :float, default: 0.6666
  end
end
