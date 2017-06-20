class DocumentMetadata < ApplicationRecord
  # not adding an association because the first row
  # applies to all documents and document binders
  # corresponds to https://github.com/matrix-msu/ARCSCore/blob/master/ARCS_1_ProjectSchema.csv
end
