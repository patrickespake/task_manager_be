# frozen_string_literal: true

module TaskSummaryQuery
  extend self

  def call
    User.connection.execute(<<-SQL)
      SELECT#{' '}
          users.name AS user_name,
          CASE
              WHEN tasks.priority = 0 THEN 'low'
              WHEN tasks.priority = 1 THEN 'medium'
              WHEN tasks.priority = 2 THEN 'high'
              ELSE 'unknown'
          END AS priority_level,
          SUM(CASE WHEN tasks.status = 0 THEN 1 ELSE 0 END) AS tasks_incomplete,
          SUM(CASE WHEN tasks.status = 1 THEN 1 ELSE 0 END) AS tasks_completed
      FROM#{' '}
          users
      JOIN#{' '}
          tasks ON users.id = tasks.user_id
      GROUP BY#{' '}
          users.name,
          tasks.priority
      ORDER BY
          users.name,
          tasks.priority;
    SQL
  end
end
