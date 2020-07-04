FROM ruby:2.7.1-buster

RUN mkdir /app
COPY . /app/
WORKDIR /app

RUN BUNDLER_WITHOUT="development test" bundle install

ENV OPEN_WEATHER_API_KEY ${OPEN_WEATHER_API_KEY}
ENV HOME_LAT ${HOME_LAT}
ENV HOME_LON ${HOME_LON}
ENV HOME_ID ${HOME_ID}

EXPOSE 4567

CMD ["bundle", "exec", "ruby", "app.rb", "-p", "4567", "-o", "0.0.0.0"]
