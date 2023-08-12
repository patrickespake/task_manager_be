# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :title, null: false, limit: 100
      t.text :description
      t.integer :status, null: false, default: 0
      t.date :due_date
      t.integer :priority, null: false, default: 1

      t.timestamps
    end
  end
end
