json.(@post, :id, :title, :content, :photo, :replies_count, :viewed_count)
json.categories @post.categories, :id, :name
