FROM ruby:2.6.3

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client npm
RUN npm i -g yarn && yarn

RUN mkdir /cook_bot
WORKDIR /cook_bot
COPY Gemfile /cook_bot/Gemfile
COPY Gemfile.lock /cook_bot/Gemfile.lock
RUN bundle install
COPY . /cook_bot

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]