class CreateWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :works do |t|
      t.time :arrival_time
      t.time :leaving_time
      t.string :remark
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
