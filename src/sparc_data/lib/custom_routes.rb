class ActionDispatch::Routing::Mapper
  def activescaffold_extensions(*resources)
    resources.each do |r|
      Rails.application.routes.draw do
        resources r do
          collection do
            get 'remove_related'
            get 'cancel_inline'
            post 'update_inline'
            get 'edit_inline'
            get 'add_inline'
            get 'search_inline'
            post 'search_ids'
            get 'search_form'
            post 'search_post'
            puts 'get collection'
          end
        end
      end
    end
  end
  def search_inline
    'test' 
  end
end
# module ActionDispatch
#
#   module Routing
#     class Mapper
#       # module Base
#         def activescaffold_extensions
#           puts "================= test"
#           col = {:find_existing => :post, :remove_related => :get, :cancel_inline => :get, :update_inline => :post, :edit_inline => :get}
#           col.each {|name, type| send(type, name)}
#         end
#       # end
#     end
#   end
# end

# module ActiveScaffold
#   module Routing
#     ACTIVE_SCAFFOLD_CORE_ROUTING = {
#       :collection => {:show_search => :get, :render_field => :post, :mark => :post, :find_existing => :post, :remove_related => :get, :cancel_inline => :get, :update_inline => :post},
#       :member => {:update_column => :post, :render_field => [:get, :post], :mark => :post}
#     }
#   end
# end