class TimecardsController < ApplicationController
    
    def edit
        
        
        
    end
    
    
    
    def show
        
        if params[:month]
          @this_month = params[:month].to_date
        else
          @this_month = Date.today 
        end   

        @current_user = User.find(params[:id])
        
        @admin_user = User.find_by(admin: true)
        
        @year = @this_month.year
        
        @month = @this_month.month
        
        @timecard = @current_user.timecards.build
      
        @time_cards = monthly_time_cards(current_user, @year, @month)
        
        @arrival_count = @time_cards.count { |i| i != nil }
        
        @admin_time = (@admin_user.basic_time.hour + (@admin_user.basic_time.min)/60) * @time_cards.count
        
        
        
        #render plain: @admin_time.inspect
    end
    
    
    def create
      
         @timecard = current_user.timecards.build
        
         if params[:arrival_time]
            @timecard.arrival_time = Time.now
         end
       
         if @timecard.save
           redirect_to timecard_path(current_user)
         end
       
    end
    
    def leaving_update
    
         @timecard = Timecard.where("user_id = ? and arrival_time >= ?",current_user.id,Time.zone.now.beginning_of_day).first
         
         if params[:leaving_time]
            @timecard.leaving_time = Time.now
         end
       
         if @timecard.save
           redirect_to timecard_path(current_user)
         end
       
    end
    
    
    
    private
        # 指定年月の全ての日のタイムカードの配列を取得する（タイムカードが存在しない日はnil）
       def monthly_time_cards(user, year, month)
           number_of_days_in_month = Date.new(year, month, 1).next_month.prev_day.day
           results = Array.new(number_of_days_in_month) # 月の日数分nilで埋めた配列を用意
           #time_cards = Timecard.all
           time_cards = Timecard.monthly(user,year,month)
           time_cards.each do |card|
            results[card.arrival_time.day - 1] = card
           end
           results
       end     
    
end
