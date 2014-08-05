module ExternalMapping
  class Syncer
    def self.new(external_source, mapped, params={})
      unless ExternalMapping.sources.keys.include?(external_source.to_sym)
        raise ArgumentError.new("External source is not defined. Define it in intitializers/external_mapping.rb")
      end

      mapped_type = mapped.class == Class ? mapped : mapped.class.name.constantize.base_class
      "#{external_source.to_s.camelize}#{mapped_type.name}Sync".constantize.new(mapped, params)
    end
  end
end
