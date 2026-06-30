FROM ruby:4.0.5

ARG WORKING_DIR

ENV WORKING_DIR=${WORKING_DIR}

WORKDIR ${WORKING_DIR}

COPY app/Gemfile app/Gemfile.lock ./

RUN bundle install
