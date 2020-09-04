FROM ruby:2.7.1-buster

RUN mkdir /app
COPY . /app/
WORKDIR /app

RUN BUNDLER_WITHOUT="development test" bundle install

EXPOSE 4567

CMD ["bundle", "exec", "ruby", "app.rb", "-p", "4567", "-o", "0.0.0.0"]
