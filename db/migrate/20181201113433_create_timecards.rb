class CreateTimecards < ActiveRecord::Migration[5.1]
  def change
    create_table :timecards do |t|
      t.datetime :arrival_time
      t.datetime :leaving_time
      t.string :remark
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
