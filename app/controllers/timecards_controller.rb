class TimecardsController < ApplicationController
    
    before_action :logged_in, only: [:show, :edit, :leaving_update, :create, :update_all]
    before_action :timecard_logged_in, only: [:show, :edit, :leaving_update, :create, :update_all]
    
    def edit
        
        @user = User.find(params[:id])
        
        if params[:month]
          @this_month = params[:month].to_date
        end
        
        year = @this_month.year
        month = @this_month.month
        
        #当月分のタイムカードを取得
        @time_cards = monthly_time_cards(@user, year, month)
        
    end
    
    def show
   
        @this_month = params[:month] ? params[:month].to_date : Date.current
   
        year = @this_month.year
        month = @this_month.month
        
        @user = User.find(params[:id])
        @admin_user = User.find_by(admin: true)
        
        #timecardのインスタンスを作成（新規登録のため）
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
         #render plain: today.strftime('%Y-%m-%d %H:%M').inspect
         if params[:arrival_time]
            @timecard.arrival_time = today.strftime('%Y-%m-%d %H:%M')
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
            @timecard.leaving_time = Time.zone.now.strftime('%Y-%m-%d %H:%M')
         end
      
         if @timecard.save
            redirect_to timecard_path(@user)
         end
       
    end
    
    def update_all
    
      @user = User.find(params[:id])
      @this_month = params[:month]
      
      error = Array.new
        #出社時間が退社時間より後の時間だった場合のエラーの配列
      Timecard.leaving_time_is_later_than_arrival_time(params[:timecards],error)
      
      day = 0
      if error.count == 0
        # timecard送信データのキー値（id)をループする　!-->
          params[:timecards].keys.each do |id|
              day+=1   
              
              arrival_time = params[:timecards][id]["arrival_time"]
              leaving_time = params[:timecards][id]["leaving_time"]
              remark = params[:timecards][id]["remark"]
         
               # 既存データを編集する場合　!-->
                if !id.include?("x")
                     # id値からtimecardデータを取得する　!-->
                     timecard= Timecard.find(id)
                # 新規登録で出社時間及び退社時間及び備考欄のいずれかに記入があった場合       
                elsif id.include?("x")&&(!arrival_time.empty?||!leaving_time.empty?||!remark.empty?)     
                     # インスタンスを作成する　!-->
                     timecard = @user.timecards.build  
                end         
                #timecardが存在したら    
                if timecard
                     #出社時間は入力されていたら
                     if !arrival_time.empty?
                         timecard.arrival_time = Time.zone.local(@this_month.to_date.year,@this_month.to_date.month,day,arrival_time.to_time.hour,arrival_time.to_time.min)
                     end
                     #退社時間は入力されていたら
                     if !leaving_time.empty?
                         timecard.leaving_time = Time.zone.local(@this_month.to_date.year,@this_month.to_date.month,day,leaving_time.to_time.hour,leaving_time.to_time.min)
                     end
                     timecard.year = @this_month.to_date.year
                     timecard.month = @this_month.to_date.month
                     timecard.day = day
                     timecard.remark = remark
                     timecard.save
                 end    
           end
           redirect_to timecard_path(@user)
       else
         flash[:danger] = "退社時間は出社時間より後の時間にして下さい。"
         redirect_to edit_timecard_path(@user,month:@this_month)
       end
    end
    
    private
        # 指定年月の全ての日のタイムカードの配列を取得する（タイムカードが存在しない日はnil）
       def monthly_time_cards(user, year, month)
           number_of_days_in_month = Date.new(year, month, 1).next_month.prev_day.day    #指定年月末を取得
           results = Array.new(number_of_days_in_month) # 月の日数分nilで埋めた配列を用意
           time_cards = Timecard.monthly(user,year,month)   #ユーザーごとの指定年月のtimecard履歴を取得
           #ユーザーごとの指定年月のtimecard履歴をループしてインデックスを付与する
           time_cards.each do |card|
              results[card.day - 1] = card
           end
           results
       end 
       
        #一般ユーザーは自分以外のユーザーデータを参照・編集できない  
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
    
end
