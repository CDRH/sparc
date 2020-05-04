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

  def present?(parameter)
    parameter = parameter.reject(&:empty?) if parameter.class == Array
    parameter.present?
  end

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
  
end
