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
                       ["roles", "string"], 
                       ["status", "boolean"]]
    assert_equal expected_fields, TypusUser.typus_fields_for(:list)
  end

  def test_should_return_typus_fields_for_form_for_typus_user
    expected_fields = [["first_name", "string"], 
                       ["last_name", "string"], 
                       ["email", "string"], 
                       ["roles", "string"], 
                       ["password", "password"], 
                       ["password_confirmation", "password"]]
    assert_equal expected_fields, TypusUser.typus_fields_for(:form)
  end

  def test_should_return_typus_fields_for_relationship_for_typus_user
    expected_fields = [["first_name", "string"], 
                       ["last_name", "string"], 
                       ["roles", "string"], 
                       ["email", "string"], 
                       ["status", "boolean"]]
    assert_equal expected_fields, TypusUser.typus_fields_for(:relationship)
  end

  def test_should_return_all_fields_for_undefined_field_type_on_typus_user
    expected_fields = [["first_name", "string"], 
                       ["last_name", "string"], 
                       ["email", "string"], 
                       ["roles", "string"], 
                       ["status", "boolean"]]
    assert_equal expected_fields, TypusUser.typus_fields_for(:undefined)
  end

  def test_should_return_filters_for_typus_user
    assert_equal [["status", "boolean"]], TypusUser.typus_filters
  end

  def test_should_return_filters_for_pages
    assert_equal [['status', 'boolean']], Page.typus_filters
  end

  def test_should_return_actions_on_list_for_typus_user
    assert_equal [], TypusUser.typus_actions_for('list')
  end

  def test_should_return_actions_on_list_for_post
    assert_equal [ "cleanup" ], Post.typus_actions_for('list')
  end

  def test_should_return_actions_on_form_for_post
    assert_equal [ "send_as_newsletter", "preview" ], Post.typus_actions_for('form')
  end

  def test_should_return_order_by_for_model
    assert_equal "title ASC, created_at DESC", Post.typus_order_by
  end

  def test_should_return_sql_conditions_on_search_for_typus_user
    expected = "1 = 1 AND (LOWER(first_name) LIKE '%francesc%' OR LOWER(last_name) LIKE '%francesc%' OR LOWER(email) LIKE '%francesc%' OR LOWER(roles) LIKE '%francesc%') "
    assert_equal expected, TypusUser.build_conditions("search=francesc")
  end

  def test_should_return_sql_conditions_on_search_and_filter_for_typus_user
    expected = "1 = 1 AND (LOWER(first_name) LIKE '%francesc%' OR LOWER(last_name) LIKE '%francesc%' OR LOWER(email) LIKE '%francesc%' OR LOWER(roles) LIKE '%francesc%') AND status = 't' "
    assert_equal expected, TypusUser.build_conditions("search=francesc&status=true")
  end

  def test_should_return_sql_conditions_on_search_for_post
    expected = "1 = 1 AND (LOWER(first_name) LIKE '%pum%' OR LOWER(last_name) LIKE '%pum%' OR LOWER(email) LIKE '%pum%' OR LOWER(roles) LIKE '%pum%') "
    assert_equal expected, TypusUser.build_conditions("search=pum")
  end

end