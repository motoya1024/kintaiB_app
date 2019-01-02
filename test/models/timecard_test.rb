require 'test_helper'

class TimecardTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
     @timecard = @user.timecards.build(year: 2018,month:01,day:01,remark:"備考",arrival_time:"2018-12-01 14:25:00",leaving_time: "2018-12-01 16:25:00")
  end

 test "year shoule be more than 1" do
    @timecard.year = 0
    assert_not @timecard.valid?
  end
  
  test "year shoule be numericality" do
    @timecard.year = "a"
    assert_not @timecard.valid?
  end
  
  test "month shoule be more than 1" do
    @timecard.month = 0
    assert_not @timecard.valid?
  end
  
  test "month shoule be numericality" do
    @timecard.month = "a"
    assert_not @timecard.valid?
  end
  
  test "day shoule be more than 1" do
    @timecard.day = 0
    assert_not @timecard.valid?
  end
  
  test "day shoule be numericality" do
    @timecard.day = "a"
    assert_not @timecard.valid?
  end
  
  test "leaving_time is later than arrival_time" do
    @timecard.arrival_time = "2018-12-01 14:25:00"
    @timecard.leaving_time = "2018-12-01 12:25:00"
    assert_not @timecard.valid?
  end
  
  
end
