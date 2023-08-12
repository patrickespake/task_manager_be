# Start from a small, trusted base image with the version pinned down
FROM ruby:3.2.2-alpine AS base

# Install system dependencies required both at runtime and build time
# Install dependencies:
# - postgresql15-client: Postgres SQL client, to allow Rails to interact with Postgres
# - libpq-dev: required by postgres
# - gcompat: needed while compiling nokogiri
RUN apk add -q --no-cache \
    libpq-dev \
    gcompat \
    build-base \
    postgresql15-client \
    tzdata \
    curl \
    bash

RUN apk add --no-cache --virtual .build-deps alpine-sdk git postgresql-dev \
    && gem install bundler:2.4.12

ARG RAILS_ENV=production
ENV RAILS_ENV ${RAILS_ENV}

ARG BUNDLE_WITHOUT=test:development
ENV BUNDLE_WITHOUT ${BUNDLE_WITHOUT}

# This stage will be responsible for installing gems
FROM base AS dependencies

# Install system dependencies required to build some Ruby gems (pg)
RUN apk add --update build-base

# Copy Gemfiles
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install \
    && apk del .build-deps

# We're back at the base stage
FROM base

# Create a non-root user to run the app and own app-specific files
RUN adduser -D app

# Switch to this user
USER app

# We'll install the app in this directory
WORKDIR /app

# Copy over gems from the dependencies stage
COPY --chown=app --from=dependencies /usr/local/bundle/ /usr/local/bundle/

# Finally, copy over the code
# This is where the .dockerignore file comes into play
# Note that we have to use `--chown` here
COPY --chown=app . ./

# Add a script to be executed every time the container starts.
COPY --chown=app entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose port 3000 in the Docker image to enable networking
EXPOSE 3000

# The main command to run when the container starts.
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
