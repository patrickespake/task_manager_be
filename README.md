# Task Manager Backend (Rails)

Welcome to the backend repository for the Task Manager application. This Rails application is designed to offer comprehensive task management capabilities, from creating and updating tasks to advanced filtering and analytics.

## Important Note

This project does not handle CRUD operations for users. To utilize the API, you should run the `rails db:seed` command. This will create an OAuth2 application with Doorkeeper and display the `client_id` and `client_secret` in the terminal. Additionally, a user will be created with an email and password, which you can use to log into the API.

This is the backend repository: a Rails application that interacts with a Postgres database. The project is dockerized for ease of development and deployment.

## Overview

The application provides the following core features:

- CRUD operations for task management.
- Advanced filters for tasks based on status, priority, and due date.
- Pagination and search functionalities.
- SQL analytics to derive insights on user tasks.
- Adherence to Rails best practices and performance optimizations.

## Kanban Management

To better manage the development process and track ongoing activities, I'm using a Kanban board. You can access and review our task breakdown and progress on our Trello board:

[Task Manager BE Trello Board](https://trello.com/invite/b/cKWPtv9S/ATTI769cdbcf830a1bf657b1815d6c40c6a84BC0FE17/task-manager-be)

## Prerequisites

Before you begin, ensure you have met the following requirements:

- You have installed Docker and Docker Compose. If not, you can download them from [here](https://www.docker.com/products/docker-desktop).

## Project Setup

First, you will need to clone the project repository:

```
git clone git@github.com:patrickespake/task_manager_be.git
cd task_manager_be
```

Then, you need to copy the `.env.development` file to `.env`:

```
cp .env.development .env
```

Now, edit the `.env` file with your database credentials and other environment variables.


## Running the Project

With Docker and Docker Compose installed, and the `.env.development` file properly configured, you can start the services using the following command:

```
docker-compose up
```

This command will start all the services defined in the `docker-compose.yml` file, which are `rails` and `postgres`.

The `rails` service is the Rails server, which is available at `http://localhost:3000`.

In order to prepare the Rails app, ensure that the database is set up. This can be done by running the following commands:

```
docker-compose exec rails bin/rails db:create
docker-compose exec rails bin/rails db:migrate
docker-compose exec rails bin/rails db:seed
```

These commands will create the necessary database tables defined in the db/schema.rb file in your Rails application, and add initial data after the database is created.

## Stopping the Project

To stop the running services, you can use the following command:

```
docker-compose down
```

This command will stop and remove all the running containers.

## Running Tests and Coverage

To run the tests inside the Docker container, you can use the following command:

```
docker-compose exec rails rspec
```

This command will run all the RSpec tests in the project.

After running the tests with RSpec, `SimpleCov` will generate a coverage report in the `coverage/` directory at the root of your project. Open the `index.html` file in your web browser to view the report.

## Running RuboCop

RuboCop is a static code analyzer and formatter for Ruby. I use it to enforce a consistent code style in the project. To run RuboCop, you can use the following command:

```bash
docker-compose exec rails rubocop
```

## API Documentation

The API documentation is available at [http://localhost:3000/api-docs/index.html](http://localhost:3000/api-docs/index.html). The documentation is generated using Swagger with the help of the `rswag-api` and `rswag-ui` gems. By writing RSpec tests, the API documentation is simultaneously generated.

## Testing the API with Postman

A Postman collection is available for testing the API endpoints. You can access and use it through the following link: [https://www.postman.com/patrickespake/workspace/my-workspace/collection/5866023-a40c3e9d-48b5-4c1e-970a-cd862dc4385f?action=share&creator=5866023](https://www.postman.com/patrickespake/workspace/my-workspace/collection/5866023-a40c3e9d-48b5-4c1e-970a-cd862dc4385f?action=share&creator=5866023)

## Potential Improvements and Performance Bottlenecks

As the creator of this application, I've identified several potential improvements and areas where performance bottlenecks might arise, especially as data scales:

1. **Database Optimization:** With the increase in data, database queries can become slower. It might be necessary to introduce optimizations such as indexing frequently queried columns, especially in the tasks table.

2. **Caching:** Implement caching mechanisms, like Redis, to cache frequent and costly operations, thereby reducing database load and improving response times.

3. **Rate Limiting:** To protect the API from potential abuse or accidental heavy loads, introducing a rate limiting mechanism can be beneficial.

4. **Background Jobs:** Some operations can be moved to background processes, like sending notifications or generating reports, to improve response times and offload tasks from the main application thread.

5. **Eager Loading:** To reduce the number of database queries, we might need to implement eager loading on associated records.

6. **Enhanced Search:** As data grows, the current search functionality might become slower. Integrating a dedicated search engine like Elasticsearch can improve search capabilities and speed.

7. **Code Refactor:** Some concerns/modules have grown and can be broken down further to adhere more strictly to the Single Responsibility Principle.

8. **Monitoring and Logging:** To better understand bottlenecks and issues in real-time, integrating tools like New Relic or Datadog can help monitor performance and catch problems early.

9. **Documentation Update:** As new features are added, ensuring that API documentation is up-to-date and comprehensive becomes essential. Regular reviews of the documentation against the actual API will help maintain clarity for all developers.

## Contributing to Task Manager BE

To contribute to Task Manager BE, follow these steps:

1. Create a new branch: `git checkout -b <branch_name>`.
2. Make your changes and commit them: `git commit -m '<commit_message>'`
3. Push to the original branch: `git push origin <project_name>/<location>`
4. Create the pull request.

## Contact

If you want to contact me, you can reach me at `patrickespake@gmail.com`.