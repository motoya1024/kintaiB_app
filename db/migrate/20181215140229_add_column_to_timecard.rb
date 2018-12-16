class AddColumnToTimecard < ActiveRecord::Migration[5.1]
  def change
    
    add_column :timecards, :year, :integer
    add_column :timecards, :month, :integer
    add_column :timecards, :day, :integer
  end
end
