require File.dirname(__FILE__) + '/../test_helper'

class ActiveRecordTest < Test::Unit::TestCase

  def test_should_return_model_fields_for_typus_user
    expected_fields = [["id", "integer"], 
                       ["email", "string"], 
                       ["first_name", "string"], 
                       ["last_name", "string"], 
                       ["salt", "string"], 
                       ["crypted_password", "string"], 
                       ["status", "boolean"], 
                       ["roles", "string"], 
                       ["token", "string"], 
                       ["created_at", "datetime"], 
                       ["updated_at", "datetime"]]
    assert_equal expected_fields, TypusUser.model_fields
  end

  def test_should_return_typus_fields_for_list_for_typus_user
    expected_fields = [["first_name", "string"], 
                       ["last_name", "string"], 
                       ["email", "string"], 
                       ["roles", "selector"], 
                       ["status", "boolean"]]
    assert_equal expected_fields, TypusUser.typus_fields_for('list')
    assert_equal expected_fields, TypusUser.typus_fields_for(:list)
  end

  def test_should_return_typus_fields_for_form_for_typus_user
    expected_fields = [["first_name", "string"], 
                       ["last_name", "string"], 
                       ["email", "string"], 
                       ["roles", "selector"], 
                       ["password", "password"], 
                       ["password_confirmation", "password"]]
    assert_equal expected_fields, TypusUser.typus_fields_for('form')
    assert_equal expected_fields, TypusUser.typus_fields_for(:form)
  end

  def test_should_return_typus_fields_for_relationship_for_typus_user
    expected_fields = [["first_name", "string"], 
                       ["last_name", "string"], 
                       ["roles", "selector"], 
                       ["email", "string"], 
                       ["status", "boolean"]]
    assert_equal expected_fields, TypusUser.typus_fields_for('relationship')
    assert_equal expected_fields, TypusUser.typus_fields_for(:relationship)
  end

  def test_should_return_all_fields_for_undefined_field_type_on_typus_user
    expected_fields = [["first_name", "string"], 
                       ["last_name", "string"], 
                       ["email", "string"], 
                       ["roles", "selector"], 
                       ["status", "boolean"]]
    assert_equal expected_fields, TypusUser.typus_fields_for('undefined')
    assert_equal expected_fields, TypusUser.typus_fields_for(:undefined)
  end

  def test_should_return_filters_for_typus_user
    assert_equal "status, unexisting", Typus::Configuration.config['TypusUser']['filters']
    assert_equal [["status", "boolean"]], TypusUser.typus_filters
  end

  def test_should_return_actions_on_list_for_typus_user
    assert TypusUser.typus_actions_for('list').empty?
    assert TypusUser.typus_actions_for(:list).empty?
  end

  def test_should_return_actions_on_list_for_post
    assert_equal ["cleanup"], Post.typus_actions_for('list')
    assert_equal ["cleanup"], Post.typus_actions_for(:list)
  end

  def test_should_return_actions_on_form_for_post
    assert_equal ["send_as_newsletter", "preview"], Post.typus_actions_for('form')
    assert_equal ["send_as_newsletter", "preview"], Post.typus_actions_for(:form)
  end

  def test_should_return_field_options_for_post
    assert_equal ["status"], Post.typus_field_options_for('selectors')
    assert_equal ["status"], Post.typus_field_options_for(:selectors)
    assert_equal ["permalink"], Post.typus_field_options_for('read_only')
    assert_equal ["permalink"], Post.typus_field_options_for(:read_only)
    assert_equal ["created_at"], Post.typus_field_options_for('auto_generated')
    assert_equal ["created_at"], Post.typus_field_options_for(:auto_generated)
    assert_equal ["status"], Post.typus_field_options_for('questions')
    assert_equal ["status"], Post.typus_field_options_for(:questions)
  end

  def test_should_return_defaults_for_post
    assert_equal ["title"], Post.typus_defaults_for('search')
    assert_equal ["title"], Post.typus_defaults_for(:search)
    assert_equal ["title", "-created_at"], Post.typus_defaults_for('order_by')
    assert_equal ["title", "-created_at"], Post.typus_defaults_for(:order_by)
  end

  def test_should_return_relationships_for_post
    assert_equal ["tags"], Post.typus_relationships_for('has_and_belongs_to_many')
    assert_equal ["tags"], Post.typus_relationships_for(:has_and_belongs_to_many)
    assert Post.typus_relationships_for('has_many').empty?
    assert Post.typus_relationships_for(:has_many).empty?
  end

  def test_should_return_order_by_for_model
    assert_equal "title ASC, created_at DESC", Post.typus_order_by
  end

  def test_should_return_sql_conditions_on_search_for_typus_user
    expected = "1 = 1 AND (LOWER(first_name) LIKE '%francesc%' OR LOWER(last_name) LIKE '%francesc%' OR LOWER(email) LIKE '%francesc%' OR LOWER(roles) LIKE '%francesc%') "
    params = { 'search' => 'francesc' }
    assert_equal expected, TypusUser.build_conditions(params)
  end

  def test_should_return_sql_conditions_on_search_and_filter_for_typus_user
    expected = "1 = 1 AND status = 't' AND (LOWER(first_name) LIKE '%francesc%' OR LOWER(last_name) LIKE '%francesc%' OR LOWER(email) LIKE '%francesc%' OR LOWER(roles) LIKE '%francesc%') "
    params = { 'search' => 'francesc', 'status' => 'true' }
    assert_equal expected, TypusUser.build_conditions(params)
    params = { 'search' => 'francesc', 'status' => 'false' }
    assert_match /status = 'f'/, TypusUser.build_conditions(params)
  end

  def test_should_return_sql_conditions_on_search_and_filter_for_typus_user
    expected = "1 = 1 AND status = 't' AND (LOWER(first_name) LIKE '%francesc%' OR LOWER(last_name) LIKE '%francesc%' OR LOWER(email) LIKE '%francesc%' OR LOWER(roles) LIKE '%francesc%') "
    params = { 'search' => 'francesc', 'status' => 'true' }
    assert_equal expected, TypusUser.build_conditions(params)
    params = { 'search' => 'francesc', 'status' => 'false' }
    assert_match /status = 'f'/, TypusUser.build_conditions(params)
  end

  def test_should_return_sql_conditions_on_filtering_typus_users_by_status

    expected = "1 = 1 AND status = 't' "
    params = { 'status' => 'true' }
    assert_equal expected, TypusUser.build_conditions(params)

    expected = "1 = 1 AND status = 'f' "
    params = { 'status' => 'false' }
    assert_equal expected, TypusUser.build_conditions(params)

  end

  def test_should_return_sql_conditions_on_filtering_typus_users_by_created_at

    expected = "1 = 1 AND created_at > '#{Time.today.to_s(:db)}' AND created_at < '#{Time.today.tomorrow.to_s(:db)}' "
    params = { 'created_at' => 'today' }
    assert_equal expected, TypusUser.build_conditions(params)

    expected = "1 = 1 AND created_at > '#{6.days.ago.midnight.to_s(:db)}' AND created_at < '#{Time.today.tomorrow.to_s(:db)}' "
    params = { 'created_at' => 'past_7_days' }
    assert_equal expected, TypusUser.build_conditions(params)

    expected = "1 = 1 AND created_at > '#{Time.today.last_month.to_s(:db)}' AND created_at < '#{Time.today.tomorrow.to_s(:db)}' "
    params = { 'created_at' => 'this_month' }
    assert_equal expected, TypusUser.build_conditions(params)

    expected = "1 = 1 AND created_at > '#{Time.today.last_year.to_s(:db)}' AND created_at < '#{Time.today.tomorrow.to_s(:db)}' "
    params = { 'created_at' => 'this_year' }
    assert_equal expected, TypusUser.build_conditions(params)

  end


  def test_should_verify_previous_and_next_is_working
    assert TypusUser.new.respond_to?(:previous_and_next)
    assert typus_users(:admin).previous_and_next.kind_of?(Array)
    assert_equal [typus_users(:admin), typus_users(:disabled_user)], typus_users(:editor).previous_and_next
  end

  def test_should_verify_typus_name_is_working_properly
    assert Category.new.respond_to?(:name)
    assert_equal "First Category", categories(:first).typus_name
    assert Post.new.respond_to?(:to_label)
    assert_equal "Labeled post", posts(:published).typus_name
    assert !Page.new.respond_to?(:name)
    assert !Page.new.respond_to?(:to_label)
    assert_equal "Page#1", pages(:published).typus_name
  end

end