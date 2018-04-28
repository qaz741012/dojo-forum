class ChangeDefaultToAuthFromPost < ActiveRecord::Migration[5.2]
  def change
    change_column_null :posts, :auth, false
    change_column_default :posts, :auth, "public"
  end
end
