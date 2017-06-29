class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_doc_type_name(type)
    if type == "feature_record_select_artifact"
      "Feature Record (Select Artifact)"
    else
      type.titleize if type
    end
  end

  # require 'custom_routes'
  require 'new_by_search'
  
  def search_form
    redirect_to action: :show_search
  end
  
  def search_ids
    puts params
    session["as:#{params[:controller]}"]['search'] = params['search']
    respond_to do |format|
      format.html {redirect_to action: 'index'}
      format.xls { redirect_to action: 'index', :format => 'xls' }
    end
  end
  
  def cancel_inline
    # debugger
    klass = Object.const_get params[:parent]
    pr = klass.find params[:parent_id]
    col = self.active_scaffold_config.columns[params['column']]
    if params[:id] == '999999999999'
      o = col.association.klass.new
      o.id = 999999999999
    else
      o = col.association.klass.find params[:id]
    end
    @col = col
    render :partial => 'horizontal_subform', :locals => {:object => o, :parent_record => pr, :column => col, :associated => pr.send(params[:column])}
    # render :active_scaffold => params['column'], :constraints => {col.association.foreign_key => params[:parent_id]}
  end

  def update_inline
    # debugger
    klass = Object.const_get params[:parent]
    pr = klass.find params[:parent_id]
    col = self.active_scaffold_config.columns[params['column']]
    if params[:id] == '999999999999'
      o = col.association.klass.new
      # o.id = 999999999999
      o.save
      if col.plural_association?
        pr.update_attribute(params['column'], pr.send(params['column'])+[o])
      else
        pr.update_attribute(params['column'], o)
      end
      pr.save
    else
      o = col.association.klass.find params[:id]
    end
    # debugger
    params[:data].each do |k,v|
      if k != 'id' and k != '--related--id'
        if !k.include? '--related--'
          o.update_attribute(k, v) 
        else
          field = k.gsub('--related--','')
          klass = Object.const_get field.singularize.camelize
          rel = klass.find v
          o.update_attribute(field, rel) 
        end
      end
    end
    o.save
    # if params[:id] == '999999999999'
    #   o.id = 999999999999
    # end
    @col = col
    render :partial => 'horizontal_subform', :locals => {:object => o, :parent_record => pr, :column => col, :associated => pr.send(params[:column])}
    # render :active_scaffold => params['column'], :constraints => {col.association.foreign_key => params[:parent_id]}
  end

  def edit_inline
    # debugger
    klass = Object.const_get params[:parent]
    pr = klass.find params[:parent_id]
    col = self.active_scaffold_config.columns[params['column']]
    o = col.association.klass.find params[:id]
    @col = col
    render :partial => 'horizontal_subform_custom', :locals => {:object => o, :parent_record => pr, :column => col}
    # render :active_scaffold => params['column'], :constraints => {col.association.foreign_key => params[:parent_id]}
  end

  def add_inline
    # debugger
    klass = Object.const_get params[:parent]
    pr = klass.find params[:parent_id]
    col = self.active_scaffold_config.columns[params['column']]
    o = col.association.klass.new
    o.id = 999999999999
    @col = col
    render :partial => 'horizontal_subform_custom', :locals => {:object => o, :parent_record => pr, :column => col}
    # render :active_scaffold => params['column'], :constraints => {col.association.foreign_key => params[:parent_id]}
  end
  
  def find_existing
    klass = Object.const_get params[:klass].to_s.singularize
    query = ''
    p = []
    if params[:search_params] != nil and params[:search_params] != ''
      params[:search_params].each do |k,v|
        if v != nil and v != ''
          query += ' and ' if query != ''
          val = "".html_safe + v
          if klass.columns_hash[k].type != :integer
            query += "#{k} ilike '%#{val}%'"
            p << "%#{v}%"
          else
            query += "#{k} = #{val}"
            p << v
          end
        end
      end
    end
    # debugger
    @existing = klass.where(query)
    render :partial => 'find_existing.html.erb', :layout => false
  end

  def search_inline
    # debugger
    # klass = Object.const_get params[:parent]
    # pr = klass.find params[:parent_id]
    # col = self.active_scaffold_config.columns[params['column']]
    # o = col.association.klass.find params[:id]
    # @col = col
    render :partial => 'search_form.html.erb', :locals => {:klass => params[:klass].to_s.camelcase}
    # render :partial => '/cdi_accessions/search_form' #, :locals => {:object => o, :parent_record => pr, :column => col}
    # render :active_scaffold => params['column'], :constraints => {col.association.foreign_key => params[:parent_id]}
  end
  
end
