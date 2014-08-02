require 'rails_helper'
require 'external_mapping/syncer'

module ExternalMapping
  describe ExternalMapping::Syncer do
    describe '#new' do
      before do

      end

      it 'should instantiate sync class for external source and mapped class' do
        class ::Dummy; end;
        class ::OtherDummySync; end;

        :dummy.to_s.camelize
        expect(Syncer.new(:dummy, Dummy)).to be_an_instance_of OtherDummySync
      end
    end
  end
end

