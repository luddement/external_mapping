require 'rails_helper'

describe MappedHasExternalMapping do
  describe '.external_sync_after_save!' do
    it 'calls sync on mapper by default' do
      expect_any_instance_of(ExternalMapping::Mapper).to receive(:sync!)

      subject.external_sync_after_save!
    end

    it 'sync in a worker if sidekiq is enabled' do
      class ExternalMapping::SyncWorker; end;
      allow(ExternalMapping).to receive(:worker).and_return(:sidekiq)

      allow(subject).to receive(:id).and_return(123)
      allow(subject).to receive(:external_params).and_return({ this: 'is', my: 'hash' })

      allow(ExternalMapping::SyncWorker).to receive(:perform_async)
      expect(ExternalMapping::SyncWorker).to receive(:perform_async).with(:dummy, MappedHasExternalMapping.name, 123, hash_including(this: 'is', my: 'hash'))

      subject.external_sync_after_save!
    end

    it 'passes sync params' do
      allow(subject).to receive(:external_params).and_return({ this: 'is', my: 'hash' })

      expect(ExternalMapping::Mapper).to receive(:new).with(:dummy, subject, hash_including(this: 'is', my: 'hash')).and_call_original
      expect_any_instance_of(ExternalMapping::Mapper).to receive(:sync!)

      subject.external_sync_after_save!
    end

    it 'does not sync when sync_after_save is false' do
      allow(subject).to receive(:external_params).and_return({ this: 'is', my: 'hash' })
      #allow(subject).to receive(:skip_external_sync_after_save).and_return(true)

      expect(ExternalMapping::Mapper).to_not receive(:new)
      expect_any_instance_of(ExternalMapping::Mapper).to_not receive(:sync!)

      subject.skip_external_sync_after_save = true
      subject.external_sync_after_save!
    end
  end
end
