# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require '../../factories'

##
# CRUD
##

5.times { Factory(:entry) }

##
# CRUD Extended
##

5.times { Factory(:post) }

##
# HasManyThrough
##

5.times do
  project = Factory(:project)
  5.times do
    project.collaborators << Factory(:user)
  end
end

##
# HasOne
##

5.times { Factory(:invoice) }
