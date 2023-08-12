# frozen_string_literal: true

# spec/serializers/version_serializer_spec.rb

require 'rails_helper'

RSpec.describe VersionSerializer, type: :serializer do
  let(:version) { create(:task).versions.first }
  let(:serializer) { described_class.new(version) }
  let(:serialized_hash) { serializer.serializable_hash }
  let(:serialized_json) { serialized_hash.to_json }
  let(:serialized_attributes) { JSON.parse(serialized_json)['data']['attributes'] }

  it 'contains expected attributes' do
    expect(serialized_attributes.keys).to match_array(%w[event changeset created_at])
  end

  describe 'event' do
    it 'serializes the event' do
      expect(serialized_attributes['event']).to eq(version.event)
    end
  end

  describe 'changeset' do
    it 'serializes the changeset' do
      expect(serialized_attributes['changeset']).to eq(version.changeset.as_json)
    end
  end

  describe 'created_at' do
    it 'serializes the created_at' do
      expect(serialized_attributes['created_at']).to eq(version.created_at.as_json)
    end
  end
end
