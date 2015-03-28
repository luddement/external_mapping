ActiveRecord::Base.extend(ExternalMapping::HasExternalMapping::ActiveRecord)
ActionController::Base.extend(ExternalMapping::HasExternalSync::ActiveRecord)
