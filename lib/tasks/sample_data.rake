require 'faker'

namespace :db do
  desc "Fill database with sample data"

  task :populate => :environment do
    #reset db
    Rake::Task['db:reset'].invoke

    #add admin
    admin = User.create!(:name => "Example User",
                          :email => "admin@railstutorial.org",
                          :password => "foobar",
                          :password_confirmation => "foobar")
    admin.toggle!(:admin)

    #add some sample data
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
  end
end
