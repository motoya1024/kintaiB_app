class Timecard < ApplicationRecord
     belongs_to :user
     
     # 指定年月のタイムカードを取得する
    def self.monthly(user,year,month)
      @this_month = Date.new(year,month,1)
      @next_month = Date.new(year,month,1)>>1
      #self.all
      self.where("user_id = ? and arrival_time BETWEEN ? AND ?", user.id,@this_month, @next_month).all
    end
end
