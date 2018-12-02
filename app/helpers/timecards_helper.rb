module TimecardsHelper
    
    # 00:00 形式の勤務時間を返す
      def time_diff_str(second)
        hours, rest = second.divmod(60 * 60)
        minutes, rest = rest.divmod(60)
    
        '%02d' % hours + ':' '%02d' % minutes
      end
    
    # 00:00 形式の勤務合計事件を返す
      def total_basictime_str(basic_time,time_cards)
        hour = basic_time.hour
        minute = basic_time.min/60.to_f
        
        times = hour + minute
        total_time = times * time_cards.count
      end
    
      # 00:00 形式の勤務合計事件を返す
      def total_worktime_str(time_cards)
        sum = 0
        time_cards.each do |date|
          if (!date.nil?)
            diff = date.leaving_time - date.arrival_time
            hours, rest = diff.divmod(60 * 60)
            minutes, rest = rest.divmod(60)
            time = hours + minutes/60.to_f
            sum+=time
          end
        end
        "%.2f" % sum
        
      end
 
end
