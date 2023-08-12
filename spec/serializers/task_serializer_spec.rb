# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:task) { create(:task, user:) }
  let(:options) { { include: %i[user versions] } }
  let(:serializer) { described_class.new(task, options) }
  let(:serialized_hash) { serializer.serializable_hash }
  let(:serialized_json) { serialized_hash.to_json }
  let(:serialized_attributes) { JSON.parse(serialized_json)['data']['attributes'] }
  let(:serialized_relationships) { JSON.parse(serialized_json)['data']['relationships'] }
  let(:included) { JSON.parse(serialized_json)['included'] }

  it 'contains expected attributes' do
    expect(serialized_attributes.keys).to match_array(%w[
                                                        title description status due_date priority created_at
                                                        updated_at
                                                      ])
  end

  %w[title description status due_date priority created_at updated_at].each do |attribute|
    describe attribute do
      it "serializes the #{attribute}" do
        expect(serialized_attributes[attribute]).to eq(task.public_send(attribute).as_json)
      end
    end
  end

  describe 'user relationship' do
    it 'contains the user id' do
      expect(serialized_relationships['user']['data']['id']).to eq(user.id.to_s)
    end

    it 'includes user details in the included section' do
      included_user = included.detect { |inc| inc['type'] == 'user' }
      expect(included_user['attributes']['name']).to eq(user.name)
      expect(included_user['attributes']['email']).to eq(user.email)
    end
  end

  describe 'versions relationship' do
    it 'contains versions ids' do
      version_ids = task.versions.map(&:id).map(&:to_s)
      serialized_version_ids = serialized_relationships['versions']['data'].map { |version_data| version_data['id'] }
      expect(serialized_version_ids).to match_array(version_ids)
    end

    it 'includes versions details in the included section' do
      included_versions = included.select { |inc| inc['type'] == 'version' }
      expect(included_versions.size).to eq(task.versions.size)
    end
  end
end
