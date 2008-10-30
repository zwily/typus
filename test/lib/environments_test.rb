require File.dirname(__FILE__) + '/../test_helper'

class EnvironmentsTest < Test::Unit::TestCase

  def test_should_should_return_methods_of_rails_module
    assert Rails.respond_to?(:environment)
    assert Rails.respond_to?('development?')
    assert Rails.respond_to?('test?')
    assert Rails.respond_to?('production?')
    assert Rails.respond_to?('none?')
  end

end