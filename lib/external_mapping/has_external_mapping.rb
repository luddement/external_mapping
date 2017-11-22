module ExternalMapping
  module HasExternalMapping
    extend ActiveSupport::Concern

    module ActiveRecord
      def has_external_mapping(attrs={})
        class << self; attr_reader :external_params; end
        class << self; attr_reader :external_sync_after_save; end
        @external_params = attrs[:external_params] || ExternalMapping.default_external_params || { }
        @external_sync_after_save = attrs.key?(:sync_after_save) ? attrs[:sync_after_save] : true

        include HasExternalMapping
      end
    end

    included do
      has_many :external_maps, as: :mapped, class_name: 'ExternalMapping::Map'
      has_many :external_errors, through: :external_maps, class_name: 'ExternalMapping::Error'
      attr_accessor :skip_external_sync_after_save

      if ExternalMapping::sync_after_save && self.external_sync_after_save
        after_save :external_sync_after_save!
        after_destroy :destroy_mapping!
      end
    end

    def external_sync_after_save!
      unless self.skip_external_sync_after_save
        if ExternalMapping.worker == :sidekiq
          external_mapping_mappers.each do |mapper|
            ExternalMapping::SyncWorker.perform_async(mapper.external_source, self.class.base_class.name, self.id, self.external_params)
          end
        else
          external_sync!
        end
      end
      true
    end

    def external_sync!
      external_mapping_mappers.each(&:sync!)
    end

    def destroy_mapping!
      external_mapping_mappers.each(&:destroy_mapping!)
    end

    def external_synced?
      external_mapping_mappers.any?(&:has_mapping?)
    end

    def external_mapping(external_source)
      external_mapping_mappers.find do |mapper|
        mapper.external_source.to_sym == external_source.to_sym
      end.mapping
    end

    def external_params
      if self.class.base_class.external_params.kind_of?(Proc)
        self.instance_exec(&self.class.base_class.external_params)
      else
        self.class.external_params
      end
    end

    private

    def external_mapping_mappers
      @external_mapping_mappers ||= begin
        ExternalMapping.sources.keys.map do |external_source|
          ExternalMapping::Mapper.new(external_source, self, self.external_params)
        end
      end
    end
  end
end
