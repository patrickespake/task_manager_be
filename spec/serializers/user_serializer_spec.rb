# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:serializer) { described_class.new(user) }
  let(:serialized_hash) { serializer.serializable_hash }
  let(:serialized_json) { serialized_hash.to_json }
  let(:serialized_attributes) { JSON.parse(serialized_json)['data']['attributes'] }

  it 'contains expected attributes' do
    expect(serialized_attributes.keys).to match_array(%w[name email created_at updated_at])
  end

  describe 'name' do
    it 'serializes the name' do
      expect(serialized_attributes['name']).to eq(user.name)
    end
  end

  describe 'email' do
    it 'serializes the email' do
      expect(serialized_attributes['email']).to eq(user.email)
    end
  end

  describe 'created_at' do
    it 'serializes the created_at' do
      expect(serialized_attributes['created_at']).to eq(user.created_at.as_json)
    end
  end

  describe 'updated_at' do
    it 'serializes the updated_at' do
      expect(serialized_attributes['updated_at']).to eq(user.updated_at.as_json)
    end
  end
end
