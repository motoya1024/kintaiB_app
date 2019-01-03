class Timecard < ApplicationRecord
     belongs_to :user
     
     validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
     validates :month , numericality: { only_integer: true, greater_than_or_equal_to: 1 }
     validates :day , numericality: { only_integer: true, greater_than_or_equal_to: 1 }
     validate :leaving_time_is_later_than_arrival_time

     # 指定年月のタイムカードを取得する
    def self.monthly(user,year,month)
   
      self.where("user_id = ? and year = ? and month = ?", user.id, year, month).all
    end
    
     #出社時間が退社時間より後の時間だった場合のエラーの配列
    def self.leaving_time_is_later_than_arrival_time(timecards,this_month,error)
         if Date.new(this_month.to_date.year,this_month.to_date.month) < Date.new(Date.current.year,Date.current.month) 
             timecards.keys.each do |id|
                 arrival_time = timecards[id]["arrival_time"]
                 leaving_time = timecards[id]["leaving_time"]
                 if !arrival_time.empty?&&!leaving_time.empty?
                     if arrival_time >= leaving_time
                        error.push("error")
                     end
                 end
             end
         elsif Date.new(this_month.to_date.year,this_month.to_date.month) == Date.new(Date.current.year,Date.current.month)
            timecards.keys.each do |id|
                if !id.include?("x")
                     timecard = self.find(id)  
                     if timecard.day < Date.current.day
                        arrival_time = timecards[id]["arrival_time"]
                         leaving_time = timecards[id]["leaving_time"]
                         if !arrival_time.empty?&&!leaving_time.empty?
                             if arrival_time >= leaving_time
                                error.push("error")
                             end
                         end
                     end
                else 
                     if id.delete("x").to_i< Date.current.day
                         arrival_time = timecards[id]["arrival_time"]
                         leaving_time = timecards[id]["leaving_time"]
                         if !arrival_time.empty?&&!leaving_time.empty?
                             if arrival_time >= leaving_time
                                error.push("error")
                             end
                         end
                     end
                end
            end
         end
    end
    
    #過去の、出社時間と退社時間が両方入力された場合のみ編集可能
    def self.both_leaving_time_and_arrival_time(timecards,this_month,error)
         if Date.new(this_month.to_date.year,this_month.to_date.month) < Date.new(Date.current.year,Date.current.month) 
             timecards.keys.each do |id|
                 arrival_time = timecards[id]["arrival_time"]
                 leaving_time = timecards[id]["leaving_time"]
                 if (!arrival_time.empty?&&leaving_time.empty?)||(arrival_time.empty?&&!leaving_time.empty?)
                     error.push("error")
                 end
            end
         elsif Date.new(this_month.to_date.year,this_month.to_date.month) == Date.new(Date.current.year,Date.current.month)
            timecards.keys.each do |id|
                if !id.include?("x")
                     timecard = self.find(id)  
                     if timecard.day < Date.current.day
                         arrival_time = timecards[id]["arrival_time"]
                         leaving_time = timecards[id]["leaving_time"]
                         if (!arrival_time.empty?&&leaving_time.empty?)||(arrival_time.empty?&&!leaving_time.empty?)
                             error.push("error")
                         end
                     end
                else 
                     if id.delete("x").to_i< Date.current.day
                        arrival_time = timecards[id]["arrival_time"]
                        leaving_time = timecards[id]["leaving_time"]
                        if (!arrival_time.empty?&&leaving_time.empty?)||(arrival_time.empty?&&!leaving_time.empty?)
                             error.push("error")
                        end
                     end
                end
            end
         end
    end
    
    #当日は、出社時間と退社時間の両方入力があった場合のみ編集
    def self.today_is_both_leaving_time_and_arrival_time(user,timecards,this_month)
        if this_month.to_date.year == Date.current.year && this_month.to_date.month == Date.current.month
            error = Array.new
            today_timecard = self.where("user_id = ? and year = ? and month = ? and day =?", user.id, Date.current.year, Date.current.month,Date.current.day).first
            if today_timecard
               time = timecards["#{today_timecard[:id]}"]
            else
               time = timecards["x#{Date.current.day}"] 
            end
            
            if today_timecard.nil? 
                if !time["leaving_time"].empty? || !time["arrival_time"].empty?
                     error.push("error")
                end
            elsif !today_timecard.nil?&&(today_timecard.arrival_time.nil?&&today_timecard.leaving_time.nil?)
                if !time["leaving_time"].empty? || !time["arrival_time"].empty?
                     error.push("error")
                end
            elsif !today_timecard.nil?&&(today_timecard.arrival_time&&today_timecard.leaving_time.nil?)
                if (today_timecard.arrival_time.strftime("%H:%M") != time["arrival_time"])
                     error.push("error")
                elsif (today_timecard.arrival_time.strftime("%H:%M") == time["arrival_time"])&&!time["leaving_time"].empty?
                     error.push("error")
                end
            end
        end
    end
    
    private
         # カスタムバリデーション（退社時間が出社時間より後か？）
        def leaving_time_is_later_than_arrival_time
          return if leaving_time.nil? || arrival_time.nil?
    
          if arrival_time > leaving_time
            errors[:base] << '退社時間は、出社時間より後の時間である必要があります'
          end
        end
        

end
