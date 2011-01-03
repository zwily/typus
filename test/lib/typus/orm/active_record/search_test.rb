require "test_helper"

class ActiveRecordTest < ActiveSupport::TestCase

  should_eventually "build_search_conditions"

  context "build_boolean_conditions" do

    should "return true" do
      expected = {'status'=>true}
      output = Page.build_boolean_conditions('status', 'true')
      assert_equal expected, output
    end

    should "return false" do
      expected = {'status'=>false}
      output = Page.build_boolean_conditions('status', 'false')
      assert_equal expected, output
    end

  end

=begin

  def build_datetime_conditions(key, value)
    tomorrow = Time.zone.now.beginning_of_day.tomorrow

    interval = case value
               when 'today'         then 0.days.ago.beginning_of_day..tomorrow
               when 'last_few_days' then 3.days.ago.beginning_of_day..tomorrow
               when 'last_7_days'   then 6.days.ago.beginning_of_day..tomorrow
               when 'last_30_days'  then 30.days.ago.beginning_of_day..tomorrow
               end

    ["`#{table_name}`.#{key} BETWEEN ? AND ?", interval.first.to_s(:db), interval.last.to_s(:db)]
  end

=end
  context "build_datetime_conditions" do

    should "work for today" do
      expected = ["`articles`.created_at BETWEEN ? AND ?", 0.day.ago.beginning_of_day.to_s(:db), Time.zone.now.beginning_of_day.tomorrow.to_s(:db)]
      output = Article.build_datetime_conditions('created_at', 'today')
      assert_equal expected, output
    end

  end

  should_eventually "build_has_and_belongs_to_many_conditions"

  should_eventually "build_date_conditions"

  context "build_string_conditions" do

    should "work" do
      expected = {'test'=>'true'}
      output = Page.build_string_conditions('test', 'true')
      assert_equal expected, output
    end

  end

  should_eventually "build_conditions"

end
