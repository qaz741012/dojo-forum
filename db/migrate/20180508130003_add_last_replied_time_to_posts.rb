class AddLastRepliedTimeToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :last_replied_time, :datetime
  end
end
