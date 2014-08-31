require 'test_helper'

class ActiveRecordTest < ActiveSupport::TestCase

  test 'mapping with an array' do
    expected = %w(pending published unpublished)

    Post.stub :statuses, expected do
      post = posts(:default)
      assert_equal 'published', post.mapping(:status)

      post.status = 'unpublished'
      assert_equal 'unpublished', post.mapping('status')

      post.status = 'unexisting'
      assert_equal 'unexisting', post.mapping(:status)
    end
  end

  test 'mapping with a two dimension array' do
    expected = [['Publicado', 'published'], ['Pendiente', 'pending'], ['No publicado', 'unpublished']]

    Post.stub :statuses, expected do
      post = posts(:default)
      assert_equal 'Publicado', post.mapping(:status)
      post.status = 'unpublished'
      assert_equal 'No publicado', post.mapping(:status)
    end
  end

  test 'mapping with a hash' do
    expected = {
      'Pending - Hash' => 'pending',
      'Published - Hash' => 'published',
      'Not Published - Hash' => 'unpublished',
    }

    Post.stub :statuses, expected do
      post = posts(:default)
      assert_equal 'Published - Hash', post.mapping(:status)
      post.status = 'unpublished'
      assert_equal 'Not Published - Hash', post.mapping(:status)
    end
  end

  test 'mapping with a hash when value does not exist on the mapping definition' do
    Post.stub :statuses, Hash.new do
      post = posts(:default)
      post.status = 'unexisting'
      assert_equal 'unexisting', post.mapping(:status)
    end
  end

  test 'to_label returns email for TypusUser' do
    typus_user = typus_users(:admin)
    assert_equal typus_user.email, typus_user.to_label
  end

  test 'to_label returns name for Category' do
    category = categories(:default)
    assert_equal 'Default Category', category.to_label
  end

  test 'to_label returns Model#id because Category#name is empty' do
    category = categories(:default)
    category.name = nil
    assert_match /Category#/, category.to_label
  end

  test 'to_label returns default Model#id' do
    assert_match 'Default Post', posts(:default).to_label
  end

  test 'to_resource' do
    assert_equal 'typus_users', TypusUser.to_resource
    assert_equal 'delayed/tasks', Delayed::Task.to_resource
  end

end
