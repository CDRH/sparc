class CreateDocumentTables < ActiveRecord::Migration[5.0]
  def change
    create_table :document_metadata do |t|
      t.string :name
      t.string :country
      t.string :region
      t.string :modern_name
      t.string :location_id
      t.string :location_id_scheme
      t.string :geolocation
      t.string :elevation
      t.string :earliest_date
      t.string :latest_date
      t.string :records_archive
      t.string :persistent_name
      t.string :complex_title
      t.string :terminus_ante_quem
      t.string :terminus_post_quem
      # using period instead of convention "occupation"
      # because this is using the ArcsCore Schema
      # https://github.com/matrix-msu/ARCSCore/blob/master/ARCS_1_ProjectSchema.csv
      t.string :period
      t.string :archaeological_culture
      t.string :brief_description
      t.string :permitting_heritage
      t.timestamps
    end

    create_table :document_binders do |t|
      t.string :resource_id
      t.string :title
      t.string :subtitle
      t.string :creator
      t.string :creator_role
      t.string :earliest_date
      t.string :latest_date
      t.string :dimensions
      t.string :language
      t.string :description
      t.string :condition
      t.string :rights
      t.string :rights_holder
      t.string :access_level
      t.string :repository
      t.string :accession_no
      t.timestamps
      # Note: pages will not be a row in the database
      # but will be calculated from the associated documents
    end

    create_table :documents do |t|
      t.string :format
      t.string :page_id
      t.string :scan_no
      t.string :image_upload
      t.string :scan_specifications
      t.string :scan_equipment
      t.string :scan_date
      t.string :scan_creator
      t.string :scan_creator_status
      t.string :rights
      t.string :rank
      t.timestamps
    end

    create_table :document_types do |t|
      t.string :code
      t.string :name
      t.string :color
      t.string :rank
    end

    create_join_table :documents, :units do |t|
      t.references :document, index: true, foreign_key: true
      t.references :unit, index: true, foreign_key: true
    end

    add_reference :documents, :document_binder
    add_reference :documents, :document_type
  end
end
