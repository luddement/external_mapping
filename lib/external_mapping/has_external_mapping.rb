module ExternalMapping
  module HasExternalMapping
    extend ActiveSupport::Concern

    module ActiveRecord
      def has_external_mapping
        include HasExternalMapping
      end
    end

    included do
      if ExternalMapping::sync_after_save == true
        after_save :external_sync!
      end
    end

    def external_sync!
      if ExternalMapping.worker == :sidekiq
        external_mapping_mappers.each do |mapper|
          ExternalMapping::SyncWorker.perform_async(mapper.external_source, self.class.base_class.name, self.id, self.external_params)
        end
      else
        external_mapping_mappers.each(&:sync!)
      end
      true
    end

    def external_synced?
      external_mapping_mappers.any(&:has_mapping?)
    end

    def external_params
      {}
    end

    def external_mapping(external_source)
      external_mapping_mappers.find do |mapper|
        mapper.external_source.to_sym == external_source.to_sym
      end.mapping
    end

    private

    def external_mapping_mappers
      @external_mapping_mappers ||= begin
        ExternalMapping.sources.keys.map do |external_source|
          ExternalMapping::Mapper.new(external_source, self, external_params)
        end
      end
    end
  end
end
