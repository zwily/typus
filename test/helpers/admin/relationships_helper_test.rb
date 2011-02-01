require "test_helper"

class Admin::RelationshipsHelperTest < ActiveSupport::TestCase

  include Admin::RelationshipsHelper

  should_eventually "test setup_relationship"
  should_eventually "test typus_form_has_many"
  should_eventually "test typus_form_has_and_belongs_to_many"
  should_eventually "test build_pagination"
  

end
