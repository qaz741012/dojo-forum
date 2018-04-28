class ChangeRepliesAndViewedCountSetting < ActiveRecord::Migration[5.2]
  def change
    change_column_null :posts, :replies_count, false
    change_column_default :posts, :replies_count, 0

    change_column_null :posts, :viewed_count, false
    change_column_default :posts, :viewed_count, 0
  end
end
