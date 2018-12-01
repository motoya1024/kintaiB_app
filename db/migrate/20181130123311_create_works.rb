class CreateWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :works do |t|
      t.time :arrival_time
      t.time :leaving_time
      t.text :remark
      t.timestamps
    end
  end
end
