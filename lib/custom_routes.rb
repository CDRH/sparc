def add_as_extension item
  collection do
    post 'find_existing'
    get 'remove_related'
    get 'cancel_inline'
    post 'update_inline'
    get 'edit_inline'
    get 'add_inline'
    get 'search_inline'
    post 'search_ids'
    get 'search_form'
    post 'search_post'
    puts "adding routes for collection #{item}"
  end
  
end
