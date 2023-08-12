# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ErrorSerializer do
  describe '#serialized_json' do
    let(:user) { User.new }
    subject(:serialized_errors) { described_class.new(user).serialized_json }

    context 'when there are model errors' do
      before { user.valid? }

      it 'serializes the model errors' do
        expect(serialized_errors[:errors]).to include(hash_including(
          source: { pointer: '/data/attributes/name' },
          detail: "can't be blank",
        ))
      end
    end

    context 'when there are custom errors' do
      subject(:serialized_errors) do
        described_class.new(nil, custom_errors: [{ source: '/custom_path', detail: 'Custom Error' }]).serialized_json
      end

      it 'serializes the custom errors' do
        expect(serialized_errors[:errors]).to include(hash_including(
          source: { pointer: '/custom_path' },
          detail: 'Custom Error',
        ))
      end
    end

    context 'when there are associated model errors' do
      # let(:associated_model) { AssociatedModel.new }

      # before do
      #   user.associated_models << associated_model
      #   associated_model.valid?
      # end

      xit 'serializes the associated model errors' do
        pending('Will be implemented in future pull requests.')
        # expect(
        #   serialized_errors[:errors],
        # ).to include(hash_including(source: { pointer: '/data/attributes/associated_models[0].attribute_name' }))
      end
    end
  end
end
