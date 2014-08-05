module ExternalMapping
  class SyncWorker
    include Sidekiq::Worker

    def perform(external_source, mapped_type, mapped_id, params={})
      Mapper.new(external_source, mapped_type.constantize.find(mapped_id), params.symbolize_keys).sync!
    end
  end
end
