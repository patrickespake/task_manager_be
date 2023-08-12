# Task Manager Backend (Rails)

Welcome to the backend repository for the Task Manager application. This Rails application is designed to offer comprehensive task management capabilities, from creating and updating tasks to advanced filtering and analytics.

This is the backend repository. A Rails application that interacts with a Postgres database. The project is dockerized for ease of development and deployment.

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

## Contributing to Task Manager BE

To contribute to Task Manager BE, follow these steps:

1. Create a new branch: `git checkout -b <branch_name>`.
2. Make your changes and commit them: `git commit -m '<commit_message>'`
3. Push to the original branch: `git push origin <project_name>/<location>`
4. Create the pull request.

## Contact

If you want to contact me, you can reach me at `patrickespake@gmail.com`.