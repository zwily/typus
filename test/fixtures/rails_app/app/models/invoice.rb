class Invoice < ActiveRecord::Base
  belongs_to :order
  belongs_to :typus_user
end
