require 'rails_helper'

module ExternalMapping
  describe Mapper do
    let(:mapped) { Mapped.new }
    subject { Mapper.new(:dummy, Mapped.new) }

    describe '.sync!' do
      it 'creates a mapping if it do not exist' do
        allow_any_instance_of(DummyMappedSync).to receive(:create!).and_return(123)

        expect {
          subject.sync!
        }.to change { ExternalMapping::Map.count }.by(1)

        expect(ExternalMapping::Map.last.external_id).to eq 123
      end

      it 'it updates a mapping if it already exist' do
        allow_any_instance_of(DummyMappedSync).to receive(:create!).and_return(123)
        subject.create!

        allow_any_instance_of(DummyMappedSync).to receive(:update!)
        expect_any_instance_of(ExternalMapping::Map).to receive(:touch).with(no_args())

        expect {
          subject.sync!
        }.to_not change { ExternalMapping::Map.count }
      end

      it 'does not sync if syncer cannot sync' do
        expect_any_instance_of(DummyMappedSync).to_not receive(:create!)
        expect_any_instance_of(DummyMappedSync).to_not receive(:update!)

        allow_any_instance_of(DummyMappedSync).to receive(:can_sync?).and_return(false)

        expect {
          subject.sync!
        }.to_not change { ExternalMapping::Map.count }
      end
    end
  end
end
