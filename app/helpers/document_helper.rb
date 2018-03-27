module DocumentHelper

  def get_data_uri
    if params[:manifest].present?
      params[:manifest]
    else
      if !@first_doc_type.nil?
        documents_unit_path(params.merge({:format => :json, :type => @first_doc_type}).permit(:unit, :type, :format))
      else
        ""
      end
    end
  end

  def get_manifests
    documents_unit_path(params.merge({:format => :json}).permit(:unit, :type))
  end
end
