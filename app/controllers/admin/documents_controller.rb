class Admin::DocumentsController < ApplicationController

  active_scaffold :document do |conf|
    conf.columns = [
      :units,
      :format,
      :document_binder,
      :document_type,
      :page_id,
      :scan_no,
      :image_upload,
      :scan_specifications,
      :scan_equipment,
      :scan_date,
      :scan_creator,
      :scan_creator_status,
      :rights,
      :document_binder
    ]
    conf.columns[:units].form_ui = :record_select
    conf.columns[:document_binder].form_ui = :select
    conf.columns[:document_type].form_ui = :select
    conf.actions.swap :search, :field_search
  end

end
