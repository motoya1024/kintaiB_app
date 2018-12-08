class TimecardsController < ApplicationController
    
    before_action :logged_in, only: [:show, :edit, :leaving_update,]
    before_action :timecard_logged_in, only: [:show, :edit, :leaving_update]
    
    
    def edit
        
        if params[:month]
          @this_month = params[:month].to_date
        end
        
        @user = User.find(params[:id])
        
        @year = @this_month.year
        
        @month = @this_month.month
        
        @time_cards = monthly_time_cards(@user, @year, @month)
        
        @timecards = Array.new
        
       # render plain: @time_cards[@this_month.beginning_of_month.day-1].inspect
        
        @time_cards.each do |time_card|
            
           if !time_card.nil?
               
               @timecards.push(time_card)
               
           else
               
               @timecards.push(current_user.timecards.build)
               
           end
           
       end
       
      #render plain: @ti.inspect
        
        
        
    end
    
    def show
        
        @this_month = params[:month] ? params[:month].to_date : Date.today

        @user = User.find(params[:id])
        
        @admin_user = User.find_by(admin: true)
        
        @year = @this_month.year
        
        @month = @this_month.month
        
        @timecard = @user.timecards.build
      
        @time_cards = monthly_time_cards(@user, @year, @month)
        
        @arrival_count = @time_cards.count { |i| i != nil }
        
        @admin_time = (@admin_user.basic_time.hour + (@admin_user.basic_time.min)/60) * @time_cards.count
        
        #render plain: current_user.inspect
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
    
    def update
    
      @user = User.find(params[:id])
      
      render plain: @user.inspect
       
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
           #render plain:results
       end 
           
        def timecard_logged_in
          unless admin_logged_in?
            @user = User.find(params[:id])
            unless current_user?(@user)
                flash[:danger] = "アクセス権限がありません。"
                redirect_to login_url
            end
          end
        end
       
     private
        def timecards_params
          params.permit(timecards: [:arrival_time, :leaving_time])[:timecards]
        end
    
end
