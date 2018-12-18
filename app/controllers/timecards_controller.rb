class TimecardsController < ApplicationController
    
    before_action :logged_in, only: [:show, :edit, :leaving_update, :create, :update_all]
    before_action :timecard_logged_in, only: [:show, :edit, :leaving_update, :create, :update_all]
    
    
    def edit
        
        if params[:month]
          @this_month = params[:month].to_date
        end
        
        @user = User.find(params[:id])
        
        year = @this_month.year
        
        month = @this_month.month
        
        #当月分のタイムカードを取得
        @time_cards = monthly_time_cards(@user, year, month)
        
        @timecards = Array.new
        
        # 当月分のタイムカードをループでとりだしてnilの場合はインスタンスを生成
        @time_cards.each do |time_card|
            
           if !time_card.nil?
               @timecards.push(time_card)
           else
               @timecards.push(@user.timecards.build)
           end
           
        end
        
    end
    
    def show
        
        @this_month = params[:month] ? params[:month].to_date : Date.today

        @user = User.find(params[:id])
        
        @admin_user = User.find_by(admin: true)
        
        year = @this_month.year
        
        month = @this_month.month
        
        @timecard = @user.timecards.build
      
        # 当月分のタイムカードを配列の取得（ない日はnil)
        @time_cards = monthly_time_cards(@user, year, month)
        # 出勤日数
        @arrival_count = @time_cards.count { |i| i != nil && i.leaving_time !=nil }
        
    end
    
    
    def create
        
         @user = User.find(params[:id])
         
         today = Time.zone.now
         
         timecard = @user.timecards.where("year = ? and month = ? and day = ?", today.year, today.month, today.day).first
         
         if timecard.nil?
              @timecard = @user.timecards.build
         else
              @timecard = timecard
         end
        
         if params[:arrival_time]
            @timecard.arrival_time = today
            @timecard.year = today.year
            @timecard.month = today.month
            @timecard.day = today.strftime('%-d').to_i
         end
    
         if @timecard.save
             redirect_to timecard_path(@user)
         end
         
    end
    
    #出社時間を登録したタイムカードに退社時間を更新
    def leaving_update
        
         @user = User.find(params[:id])
         
         #　指定されたユーザーの出社日と同じ日の出社時間のタイムカードを取得
         @timecard = Timecard.where("user_id = ? and arrival_time BETWEEN ? AND ?",@user.id,Time.zone.now.beginning_of_day,Time.zone.now.end_of_day).first
         
         if params[:leaving_time]
            @timecard.leaving_time = Time.zone.now
         end
      
       
         if @timecard.save
            redirect_to timecard_path(@user)
         end
       
    end
    
    
    
    def update_all
    
      @user = User.find(params[:id])
      
      @this_month = params[:month]
      
      @timecard = params[:timecards]
      
      day = 0
      # timecard送信データのキー値（id)をループする　!-->
      params[:timecards].keys.each do |id|
      day+=1   
     
      # 既存データを編集する場合　!-->
        if !id.include?("x")
             # id値からtimecardデータを取得する　!-->
             timecard= Timecard.find(id)
             if !params[:timecards][id]["arrival_time"].empty?
                 timecard.arrival_time = Time.zone.local(@this_month.to_date.year,@this_month.to_date.month,day,@timecard[id]["arrival_time"].to_time.hour,@timecard[id]["arrival_time"].to_time.min)
             end
             if !params[:timecards][id]["leaving_time"].empty?
                 timecard.leaving_time = Time.zone.local(@this_month.to_date.year,@this_month.to_date.month,day,@timecard[id]["leaving_time"].to_time.hour,@timecard[id]["leaving_time"].to_time.min)
             end
             timecard.remark = @timecard[id]["remark"]
             timecard.save
  
         else
             #出社時間・退社時間・備考のどれかが入力された場合のみ新規登録する。
             if !params[:timecards][id]["arrival_time"].empty?||!params[:timecards][id]["leaving_time"].empty?||!params[:timecards][id]["remark"].empty?
                 timecard = @user.timecards.build
                 
                 # 出社時間が空でなかったら 
                 if !params[:timecards][id]["arrival_time"].empty?
                     timecard.arrival_time = Time.zone.local(@this_month.to_date.year,@this_month.to_date.month,day,@timecard[id]["arrival_time"].to_time.hour,@timecard[id]["arrival_time"].to_time.min)
                 end
                 #　退社時間が空でなかったら
                 if !params[:timecards][id]["leaving_time"].empty?
                     timecard.leaving_time = Time.zone.local(@this_month.to_date.year,@this_month.to_date.month,day,@timecard[id]["leaving_time"].to_time.hour,@timecard[id]["leaving_time"].to_time.min)
                 end
                 
                 timecard.year = @this_month.to_date.year
                 timecard.month = @this_month.to_date.month
                 timecard.day = day
                 timecard.remark = params[:timecards][id]["remark"]
                 
                 timecard.save
             end
         end    
      end
      
    redirect_to timecard_path(@user)
         
    end
    
    private
        # 指定年月の全ての日のタイムカードの配列を取得する（タイムカードが存在しない日はnil）
       def monthly_time_cards(user, year, month)
           #指定年月末を取得
           number_of_days_in_month = Date.new(year, month, 1).next_month.prev_day.day
           
           results = Array.new(number_of_days_in_month) # 月の日数分nilで埋めた配列を用意
      
           time_cards = Timecard.monthly(user,year,month)   #ユーザーごとの指定年月のtimecard履歴を取得
           
           #ユーザーごとの指定年月のtimecard履歴をループしてインデックスを付与する
    
           time_cards.each do |card|
              results[card.day - 1] = card
           end
           results
          
       end 
           
        def timecard_logged_in
          #管理者ユーザーでなかった場合  
          unless admin_logged_in?
            @user = User.find(params[:id])
            #自分以外のユーザーでなければ
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
