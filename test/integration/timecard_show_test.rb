require 'test_helper'

class TimecardShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @this_month = Date.current
  end
  
  
  test "timecard interface" do
    log_in_as(@user)
    get timecard_path(@user)
    @time_cards = monthly_time_cards(@user, @this_month.year, @this_month.month)
    
    (@this_month.beginning_of_month..@this_month.end_of_month).each_with_index do |date,index|
        assert_match date.strftime("%m/%d"), response.body
        assert_match %w(日 月 火 水 木 金 土)[date.wday], response.body
        if @time_cards[index]
            if(@time_cards[index].arrival_time)
              assert_match @time_cards[index].arrival_time.hour, response.body
              assert_match @time_cards[index].arrival_time.min, response.body
            else
              if date == Date.current  
                 post timecards_path, params: { timecard: {arrival_time:Time.zone.now } }
                 assert template timecard/show
              end     
            end
            if (@time_cards[index].leaving_time)
              assert_match @time_cards[index].leaving_time.hour, response.body
              assert_match @time_cards[index].leaving_time.min, response.body
            else 
              if date == Date.current && !@time_cards[index].arrival_time.nil?
                 post leavingupdate_path, params: { timecard: {leaving_time:Time.zone.now } }
                 assert template timecard/show
              end 
            end 
            assert_match @timecards[index].remark, response.body
        else
           if date == Date.current  
                post timecards_path(@user), params: { timecard: {arrival_time:Time.zone.now } }
                assert template timecard/show
           end  
        end
     end
  end
  
  
  
  
  
  
end
