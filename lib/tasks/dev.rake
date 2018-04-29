namespace :dev do
  task fake_all: :environment do
    Rake::Task["dev:fake_user"].execute
    Rake::Task["dev:fake_post"].execute
  end

  task fake_user: :environment do
    20.times do |i|
      User.create( id: i + 2,
                   email: FFaker::Name::first_name.downcase + "@example.com",
                   password: "123456",
                   name: FFaker::Name::first_name,
                   avatar: "https://osclass.calinbehtuk.ro/oc-content/themes/vrisko/images/no_user.png",
                   introduction: FFaker::Lorem::sentence(30)
                 )
    end
    puts "#{User.count - 1} fake users were created."
  end

  task fake_post: :environment do
    Post.destroy_all

    User.find_each do |user|
      if user.role != "admin"
        rand(4).times do |i|
          user.posts.create( title: FFaker::Music::album,
                             content: FFaker::Lorem::sentence(100),
                             photo: "https://via.placeholder.com/400x300",
                             draft?: false
                           )
        end
      end
    end
    puts "#{Post.count} fake posts were created."
  end
end
