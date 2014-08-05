require 'external_mapping/engine'

require 'external_mapping/has_external_mapping'
require 'external_mapping/mapper'
require 'external_mapping/syncer'
require 'external_mapping/map'

if defined?(Sidekiq)
  require 'external_mapping/sync_worker'
end

module ExternalMapping
  mattr_accessor :sources, :worker, :sync_after_save

  def self.config(&block)
    yield(self)
  end
end
