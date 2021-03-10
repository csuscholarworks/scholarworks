WillowSword.setup do |config|
  # The title used by the sword server, in the service document
  config.title = 'Hyrax Sword V2 server'
  # If you do not want to use collections in Sword, it will use this as a default collection
  config.default_collection = {id: 'default', title: ['Default collection']}
  # The name of the model for retreiving collections (based on Hyrax integration)
  config.collection_models = [ 'Collection' ]
  # The work models supported by Sword (based on Hyrax integration)
  config.work_models = [ 'Thesis' ]
  # The fileset model supported by Sword (based on Hyrax integration)
  config.file_set_models = ['FileSet']
  # Remove all parameters that are not part of the model's permitted attributes
  config.allow_only_permitted_attributes = false
  # Default visibility for works
  # config.default_visibility = 'open'
  # Metadata filename in payload
  config.metadata_filename = 'mets.xml'
  # XML crosswalk for creating a work
  config.xw_from_xml_for_work = WillowSword::CrosswalkFromDspace
  # XML crosswalk for creating a fileset
  config.xw_from_xml_for_fileset = WillowSword::CrosswalkFromDspace
  # XML crosswalk when requesting a work
  config.xw_to_xml_for_work = WillowSword::CrosswalkWorkToDc
  # XML crosswalk when requesting a fileet
  config.xw_to_xml_for_fileset = WillowSword::CrosswalkFilesetToDc
  # Authorize Sword requests using Api-key header
  config.authorize_request = false
  # Customize attribute transformation
  config.before_work_transform_attributes = lambda { |params, attributes|
    attributes[:admin_set_id] = params[:admin_set_id] if params[:admin_set_id].present?
  }
end
