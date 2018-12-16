module TimecardsHelper
    
    # 00:00 形式の勤務時間を返す（退社時間‐出社時間）
      def time_diff_str(leaving_time,arrival_time)
        hour = (leaving_time.hour - arrival_time.hour)*60
        minute = leaving_time.min - arrival_time.min
        time = hour + minute
        hours, minutes = time.divmod(60)
        
        '%02d' % hours + ':' '%02d' % minutes
        
      end
    
    # 00:00 形式の勤務合計事件を返す
      def total_basictime_str(basic_time,time_cards)
        hour = basic_time.hour
        minute = basic_time.min/60.to_f
        times = hour + minute
        total_time = times * time_cards.count
      end
    
      # 00:00 形式の在社合計時間を返す
      def total_worktime_str(time_cards)
        sum = 0
        
        time_cards.each do |date|
          if (!date.nil?&&!date.leaving_time.nil?)
            
              hour = (date.leaving_time.hour - date.arrival_time.hour)*60
              minute = date.leaving_time.min - date.arrival_time.min
              time = hour + minute
              hours, minutes = time.divmod(60)
              
              time = hours + minutes/60.to_f
              sum+=time
          end
        end
          "%.2f" % sum
      end
 
end
