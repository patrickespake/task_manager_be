# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'factories' do
    it 'has a valid factory' do
      expect(build(:task)).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(100) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:priority) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(incomplete: 0, completed: 1) }
    it { should define_enum_for(:priority).with_values(low: 0, medium: 1, high: 2) }
  end

  describe 'scopes' do
    let!(:task1) { create(:task, status: 'incomplete', priority: 'low') }
    let!(:task2) { create(:task, status: 'completed', priority: 'medium') }
    let!(:task3) { create(:task, status: 'incomplete', priority: 'high') }

    context 'status scopes' do
      it 'returns incomplete tasks' do
        expect(Task.incomplete).to match_array([task1, task3])
      end

      it 'returns completed tasks' do
        expect(Task.completed).to match_array([task2])
      end
    end

    context 'priority scopes' do
      it 'returns low priority tasks' do
        expect(Task.low_priority).to match_array([task1])
      end

      it 'returns medium priority tasks' do
        expect(Task.medium_priority).to match_array([task2])
      end

      it 'returns high priority tasks' do
        expect(Task.high_priority).to match_array([task3])
      end
    end
  end
end
