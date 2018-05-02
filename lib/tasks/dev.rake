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
                   remote_avatar_url: "https://osclass.calinbehtuk.ro/oc-content/themes/vrisko/images/no_user.png",
                   introduction: FFaker::Lorem::sentence(30)
                 )
    end
    puts "#{User.count - 1} fake users were created."
  end

  task fake_post: :environment do
    Post.destroy_all

    User.find_each do |user|
      if user.role != "admin"
        rand(5).times do |i|
          user.posts.create( title: FFaker::Music::album,
                             content: FFaker::Lorem::sentence(100),
                             remote_photo_url: "https://via.placeholder.com/400x300",
                             draft?: false
                           )
        end
      end
    end
    puts "#{Post.count} fake posts were created."
  end

  task fake_post_category: :environment do
    categories = Category.all

    Post.find_each do |post|
      categories.sample(rand(1..4)).each do |category|
        post.post_categories.create(category_id: category.id)
      end
    end
    puts "Finished relationships between post and category."
  end
end
