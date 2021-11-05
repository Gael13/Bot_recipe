FROM ruby:2.7.4

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client npm
RUN npm i -g yarn && yarn

RUN mkdir /bot_recipe
WORKDIR /bot_recipe
COPY Gemfile /bot_recipe/Gemfile
COPY Gemfile.lock /bot_recipe/Gemfile.lock
RUN bundle install
COPY . /bot_recipe

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]