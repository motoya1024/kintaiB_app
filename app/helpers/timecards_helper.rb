module TimecardsHelper
    
    # 00:00 形式の勤務時間を返す（退社時間‐出社時間）
      def time_diff_str(leaving_time,arrival_time)
        hour = (leaving_time.hour - arrival_time.hour)*60
        minute = leaving_time.min - arrival_time.min
        time = hour + minute
        hours, minutes = time.divmod(60)
        minutes = minutes/60.to_f
        times = hours + minutes
        BigDecimal(times.to_s).floor(2).to_f
        #'%02d' % hours + ':' '%02d' % minutes
        
      end
    
    # 00:00 形式の勤務合計事件を返す
      def total_basictime_str(basic_time,account_count)
          hour = basic_time.hour
          minute = basic_time.min/60.to_f
          times = hour + minute
          total_time = times * account_count
          BigDecimal(total_time.to_s).floor(2).to_f
      end
      
      
    #  10進数表記
      def decimal_time(time)
        hour = time.hour
        minute = time.min/60.to_f
        times = hour + minute
        BigDecimal(times.to_s).floor(2).to_f
      end
    
      # 00:00 形式の在社合計時間を返す
      def total_worktime_str(time_cards)
        sum = 0
        
        time_cards.each do |date|
          if (!date.nil?&&!date.leaving_time.nil?&&!date.arrival_time.nil?)
              #それぞれの日の在社時間
              time = time_diff_str(date.leaving_time,date.arrival_time)
              sum+=time
          end
        end
          "%.2f" % sum
      end
 
end
