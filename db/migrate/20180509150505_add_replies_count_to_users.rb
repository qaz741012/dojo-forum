class AddRepliesCountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :replies_count, :integer, default: 0, null: false

    User.find_each do |user|
      user.update(replies_count: user.replies.count)
    end
  end
end
