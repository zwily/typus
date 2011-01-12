##
# This model is used to test:
#
#     - ActsAsTree
#     - Default Scope
#
##

class Page < ActiveRecord::Base

  acts_as_tree

  default_scope where(:status => true)

end
