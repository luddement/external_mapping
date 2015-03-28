module ExternalMapping
  module HasExternalSync
    extend ActiveSupport::Concern

    module ActiveRecord
      def has_external_sync(external_mapping)
        class << self; attr_reader :external_mapping; end
        @external_mapping = external_mapping

        include HasExternalSync
      end
    end

    included do
    end

    def external_sync
      mapping = self.instance_variable_get("@#{self.class.external_mapping}")
      mapping.external_sync!
      redirect_to :back
    end
  end
end
