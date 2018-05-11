namespace :dev do
  task fake_all: :environment do
    Rake::Task["dev:fake_user"].execute
    Rake::Task["dev:fake_post"].execute
    Rake::Task["dev:fake_post_category"].execute
    Rake::Task["dev:fake_reply"].execute
    Rake::Task["dev:fake_collect"].execute
    Rake::Task["dev:fake_friendship"].execute
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

    draft_list = [true, false]
    auth_list = ["public", "friend", "self"]
    User.find_each do |user|
      if user.role != "admin"
        rand(7).times do |i|
          user.posts.create( title: FFaker::Music::album,
                             content: FFaker::Lorem::sentence(100),
                             remote_photo_url: "https://via.placeholder.com/400x300",
                             auth: auth_list.sample,
                             draft?: draft_list.sample
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
    puts "Finished fake relationships between post and category."
  end

  task fake_reply: :environment do
    users = User.all

    Post.find_each do |post|
      users.sample(rand(0..5)).each do |user|
        reply = post.replies.build( user_id: user.id,
                                    comment: FFaker::Lorem::sentence(50) )
        reply.save
        post.update(last_replied_time: reply.created_at)
      end
    end
    puts "Created fake replies."
  end

  task fake_collect: :environment do
    posts = Post.all

    User.find_each do |user|
      rand(2..6).times do |i|
        user.collects.create( post_id: posts.sample.id )
      end
    end
    puts "Created fake collects."
  end

  task fake_friendship: :environment do
    status_list = ["request", "confirm"]
    friends = User.all
    User.find_each do |user|
      rand(0..6).times do |i|
        friend = friends.sample
        if user.id == friend.id || user.friends.include?(friend)
          next
        else
          status = status_list.sample
          user.friendships.create( status: status,
                                   friend_id: friend.id )
          case status
          when "request"
            friend.friendships.create( status: "unconfirm",
                                       friend_id: user.id )
          when "confirm"
            friend.friendships.create( status: "confirm",
                                       friend_id: user.id )
          end
        end
      end
    end
    puts "Created fake friendships."
  end

end
