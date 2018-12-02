class WorksController < ApplicationController
    
    
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
        
        @work = @current_user.monthly_time_cards(user, @year,@month)
      
    
    end
    
    
    def create
      
         @work = current_user.works.build
        
         if params[:arrival_time]
            @work.arrival_time = Time.now
         elsif params[:leaving_time]
            @work.leaving_time = Time.now
         end
       
         if @work.save
           redirect_to work_path(current_user)
         end
       
    end
    
    private
        # 指定年月の全ての日のタイムカードの配列を取得する（タイムカードが存在しない日はnil）
        def monthly_time_cards(user, year, month)
          number_of_days_in_month = Date.new(year, month, 1).next_month.prev_day.day
          results = Array.new(number_of_days_in_month) # 月の日数分nilで埋めた配列を用意
          time_cards = TimeCard.monthly(user, year, month)
              time_cards.each do |card|
                results[card.day - 1] = card
              end
          results
        end
    
    
    
end
