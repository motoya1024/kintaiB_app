class CreateInformation < ActiveRecord::Migration[5.1]
  def change
    create_table :information do |t|
      t.datetime :spefified_time
      t.datetime :basic_time
    
      t.timestamps
    end
  end
end
