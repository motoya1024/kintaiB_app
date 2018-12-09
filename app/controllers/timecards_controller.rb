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
        
        #出社時間を登録したタイムカードに退社時間を更新
        @time_cards = monthly_time_cards(@user, @year, @month)
        
        @timecards = Array.new
        
       # render plain: @time_cards[@this_month.beginning_of_month.day-1].inspect
        
        # 当月分のタイムカードをループでとりだしてnilの場合はインスタンスを生成
        @time_cards.each do |time_card|
            
           if !time_card.nil?
               
               @timecards.push(time_card)
               
           else
               
               @timecards.push(@user.timecards.build)
               
           end
           
       end
       
      #render plain: @timecards.inspect
        
        
        
    end
    
    def show
        
        @this_month = params[:month] ? params[:month].to_date : Date.today

        @user = User.find(params[:id])
        
        @admin_user = User.find_by(admin: true)
        
        @year = @this_month.year
        
        @month = @this_month.month
        
        @timecard = @user.timecards.build
      
        # 当月分のタイムカードを配列の取得（ない日はnil)
        @time_cards = monthly_time_cards(@user, @year, @month)
        
        @arrival_count = @time_cards.count { |i| i != nil }
        
        @admin_time = (@admin_user.basic_time.hour + (@admin_user.basic_time.min)/60) * @time_cards.count
        
        #render plain: @time_cards.inspect
        
    end
    
    
    def create
        
         @user = User.find(params[:id])
      
         @timecard = @user.timecards.build
        
         if params[:arrival_time]
            @timecard.arrival_time = Time.now
         end
       
         if @timecard.save
           redirect_to timecard_path(@user)
         end
       
    end
    
    #出社時間を登録したタイムカードに退社時間を更新
    def leaving_update
        
         @user = User.find(params[:id])
    
         @timecard = Timecard.where("user_id = ? and arrival_time >= ?",@user.id,Time.zone.now.beginning_of_day).first
         
         if params[:leaving_time]
            @timecard.leaving_time = Time.now
         end
       
         if @timecard.save
           redirect_to timecard_path(@user)
         end
       
    end
    
    
    
    def update_all
    
      @user = User.find(params[:id])
      
      @this_month = params[:month]
      
      @timecard = params[:timecards]
      
      #render plain: @timecard["x1"]["arrival_time"].inspect
      #render plain: @timecard.keys.inspect
      #day = 1
      #render plain: Time.zone.local(@this_month.to_date.year,@this_month.to_date.month,day,11,11).inspect
      day = 0
      params[:timecards].keys.each do |id|
      day+=1   
      #puts day
        if !id.include?("x")
             timecard= Timecard.find(id)
             
             timecard.arrival_time = Time.zone.local(@this_month.to_date.year,@this_month.to_date.month,day,@timecard[id]["arrival_time"].to_time.hour,@timecard[id]["arrival_time"].to_time.min)
             timecard.leaving_time = Time.zone.local(@this_month.to_date.year,@this_month.to_date.month,day,@timecard[id]["leaving_time"].to_time.hour,@timecard[id]["leaving_time"].to_time.min)
             #timecard.remark = @timecard[id]["remark"]
             timecard.save
  
        end
      end
     # render plain: timecard.arrival_time.inspect
      
     redirect_to timecard_path(@user)
         
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
       
        def timecards_params
          params.permit(timecards: [:arrival_time, :leaving_time, :remark])[:timecards]
        end
    
end
