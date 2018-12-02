module TimecardsHelper
    
    # 00:00 形式の勤務時間を返す
      def time_diff_str(second)
        hours, rest = second.divmod(60 * 60)
        minutes, rest = rest.divmod(60)
    
        '%02d' % hours + ':' '%02d' % minutes
      end
    
 
end
