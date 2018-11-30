class AddbasictoUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :specifed_time, :time
    add_column :users, :basic_time, :time
  end
end
