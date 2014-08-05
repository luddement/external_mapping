require 'rails_helper'

module ExternalMapping
  describe Syncer do
    describe '#new' do
      it 'should instantiate sync class for external source and mapped class' do
        [Mapped, Mapped.new].each do |mapped|
          expect(Syncer.new(:dummy, mapped)).to be_an_instance_of DummyMappedSync
        end
      end

      it 'should raise exception when source is not defined' do
        allow(ExternalMapping).to receive(:sources).and_return({})

        expect {
          Syncer.new(:dummy, Mapped)
        }.to raise_error(ArgumentError)
      end
    end
  end
end

