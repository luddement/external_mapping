module ExternalMapping
  class Syncer
    def self.build(external_source, mapped, params={})
      unless ExternalMapping.sources.keys.include?(external_source.to_sym)
        raise ArgumentError.new("External source is not defined. Define it in intitializers/external_mapping.rb")
      end

      mapped_type = mapped.class == Class ? mapped : mapped.class.name.constantize.base_class
      klass = "#{external_source.to_s.camelize}#{mapped_type.name}Sync".safe_constantize

      if klass.present?
        klass.new(mapped, params)
      else
        OpenStruct.new(:'can_sync?' => false)
      end
    end
  end
end
