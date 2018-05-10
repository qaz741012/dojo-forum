json.message "Post was successfully updated."
json.result do
  json.(@post, :id, :title, :content, :photo, :replies_count, :viewed_count, :auth, :draft?)
  json.categories @post.categories, :id, :name
end
