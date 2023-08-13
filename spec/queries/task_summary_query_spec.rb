# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskSummaryQuery do
  describe '.call' do
    let!(:john) { create(:user, name: 'John Doe') }
    let!(:jane) { create(:user, name: 'Jane Smith') }
    let!(:bob) { create(:user, name: 'Bob Brown') }
    let!(:alice) { create(:user, name: 'Alice Green') }

    before do
      # Tasks for John
      create_list(:task, 3, user: john, status: 'completed', priority: 'low')
      create_list(:task, 2, user: john, status: 'incomplete', priority: 'low')
      create_list(:task, 4, user: john, status: 'completed', priority: 'medium')
      create_list(:task, 1, user: john, status: 'incomplete', priority: 'medium')

      # Tasks for Jane
      create_list(:task, 2, user: jane, status: 'completed', priority: 'high')
      create_list(:task, 1, user: jane, status: 'incomplete', priority: 'medium')

      # Tasks for Bob
      create_list(:task, 3, user: bob, status: 'incomplete', priority: 'low')

      # Tasks for Alice
      create_list(:task, 1, user: alice, status: 'completed', priority: 'high')
      create_list(:task, 2, user: alice, status: 'completed', priority: 'medium')
    end

    it 'returns the correct task summary for all users' do
      result = TaskSummaryQuery.call.to_a

      expect(result).to match_array([
                                      {
                                        'user_name' => 'John Doe',
                                        'priority_level' => 'low',
                                        'tasks_incomplete' => 2,
                                        'tasks_completed' => 3,
                                      },
                                      {
                                        'user_name' => 'John Doe',
                                        'priority_level' => 'medium',
                                        'tasks_incomplete' => 1,
                                        'tasks_completed' => 4,
                                      },
                                      {
                                        'user_name' => 'Jane Smith',
                                        'priority_level' => 'high',
                                        'tasks_incomplete' => 0,
                                        'tasks_completed' => 2,
                                      },
                                      {
                                        'user_name' => 'Jane Smith',
                                        'priority_level' => 'medium',
                                        'tasks_incomplete' => 1,
                                        'tasks_completed' => 0,
                                      },
                                      {
                                        'user_name' => 'Bob Brown',
                                        'priority_level' => 'low',
                                        'tasks_incomplete' => 3,
                                        'tasks_completed' => 0,
                                      },
                                      {
                                        'user_name' => 'Alice Green',
                                        'priority_level' => 'high',
                                        'tasks_incomplete' => 0,
                                        'tasks_completed' => 1,
                                      },
                                      {
                                        'user_name' => 'Alice Green',
                                        'priority_level' => 'medium',
                                        'tasks_incomplete' => 0,
                                        'tasks_completed' => 2,
                                      },
                                    ])
    end
  end
end
