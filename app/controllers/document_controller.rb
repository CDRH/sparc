class DocumentController < ApplicationController

  def index
    # filter out units with no documents
    @units = Unit.includes(:documents).where.not(documents: { id: nil }).sorted

    @units_no_docs = Unit.includes(:documents).where(documents: { id: nil }).sorted
  end

  def type
    @type = params["type"]
    type_name = get_doc_type_name(@type)
    res = Document.joins(:document_type).where("document_types.name = ?", type_name)
    @result_num = res.size
    @res = res.paginate(page: params[:page], per_page: 20)
  end

  def unit
    @unit = params["unit"]
    if params["type"].present?
      @type = params["type"]
    else
      @type = DocumentType.joins(:units)
                .where(units: {unit_no: @unit}).sorted.first
                .name.parameterize("_")
    end

    type_name = get_doc_type_name(@type)
    res = Document.joins(:document_type, :units)
            .where("units.unit_no = ?", @unit)
            .where("document_types.name = ?", type_name)
            .sorted
    @result_num_docs = res.size
    @res = res.paginate(page: params[:page], per_page: 20)

    # generate the color coded document type buttons
    possible_types = DocumentType.joins(:units)
                      .where("units.unit_no = ?", @unit).uniq
    @group_colors = possible_types.sorted.group_by(&:color)
  end

end
