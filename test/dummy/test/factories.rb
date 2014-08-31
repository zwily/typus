# CRUD

FactoryGirl.define do
  factory :entry_bulk do
    sequence(:title) { |n| "EntryBulk##{n}" }
    content 'Body of the entry'
  end

  factory :entry_trash do
    sequence(:title) { |n| "EntryTrash##{n}" }
    content 'Body of the entry'
  end

  factory :case do
    sequence(:title) { |n| "Case##{n}" }
    content 'Body of the entry'
  end
end

# CRUD Extended

FactoryGirl.define do
  factory :asset do
    sequence(:caption) { |n| "Asset##{n}" }
    dragonfly File.new("#{Rails.root}/public/images/rails.png")
    dragonfly_required File.new("#{Rails.root}/public/images/rails.png")
    paperclip File.new("#{Rails.root}/public/images/rails.png")
    paperclip_required File.new("#{Rails.root}/public/images/rails.png")
  end

  factory :comment do
    sequence(:name) { |n| "Comment##{n}" }
    sequence(:email) { |n| "john+#{n}@example.com" }
    body 'Body of the comment'
    association :post
  end

  factory :page do
    sequence(:title) { |n| "Page##{n}" }
    body 'Content'
  end

end

# HasOne Association

FactoryGirl.define do
  factory :invoice do
    sequence(:number) { |n| "Invoice##{n}" }
    association :order
  end

  factory :order do
    sequence(:number) { |n| "Order##{n}" }
  end
end

# HasManyThrough Association

FactoryGirl.define do
  factory :project_collaborators do
    association :user
    association :project
  end
end

# Polymorphic

FactoryGirl.define do
  factory :animal do
    sequence(:name) { |n| "Animal##{n}" }
  end

  factory :bird do
    sequence(:name) { |n| "Bird##{n}" }
  end

  factory :dog do
    sequence(:name) { |n| "Dog##{n}" }
  end

  factory :image_holder do
    sequence(:name) { |n| "ImageHolder##{n}" }
  end
end
