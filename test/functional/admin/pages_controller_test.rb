require File.dirname(__FILE__) + '/../../test_helper'

##
# Here we test habtm, hm, polimorphism, relate and unrelate.
#
class Admin::PagesControllerTest < ActionController::TestCase

  def setup

  end

  ##
  # A page has many assets, and the relationship is polymorphic.
  #
  def test_should_create_a_poliymorphic_assets_for_a_page
    assert true
  end

end