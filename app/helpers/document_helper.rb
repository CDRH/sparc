module DocumentHelper

  def get_manifests
    documents_unit_path(
      params.merge({ format: :json }).permit(:unit, :type)
    )
  end

end
