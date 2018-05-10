json.data do
  json.array! @posts do |post|
    json.(post, :id, :title, :content, :photo, :replies_count, :viewed_count)
    json.categories post.categories, :id, :name
  end
end
