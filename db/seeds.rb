# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
puts "Deleted all users."

User.create( id: 1,
             email: "admin@example.com",
             password: "12345678",
             name: "Admin",
             remote_avatar_url: "http://www.lets-develop.com/wp-content/themes/olivias_theme/images/custom-avatar-admin.jpg",
             introduction: "Hi! I'm Admin.",
             role: "admin"
           )
puts "Created default admin."

Category.destroy_all
puts "Deleted all categories."

category_names = ["Gossiping", "Game", "Tech", "Animal", "Emotion", "Marvel", "Travel"]
category_names.each do |category_name|
  Category.create( name: category_name )
end
puts "Created default categories."
