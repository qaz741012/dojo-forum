namespace :dev do
  task fake_all: :environment do
    Rake::Task["dev:fake_user"].execute
  end

  task fake_user: :environment do
    20.times do |i|
      User.create( email: FFaker::Name::first_name.downcase + "@example.com",
                   password: "123456",
                   name: FFaker::Name::first_name,
                   avatar: "https://osclass.calinbehtuk.ro/oc-content/themes/vrisko/images/no_user.png",
                   introduction: FFaker::Lorem::sentence(30)
                 )
    end
    puts "#{User.count - 1} fake users were created."
  end

  task fake_post: :environment do
    
  end
end
