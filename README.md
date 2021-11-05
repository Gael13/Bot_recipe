#Project

A prototype for suggesting recipes according to what we have in the fridge.
A user can buy ingredients from the supermarket (add ingredients) and remove ingredients from the fridge.
A user can ask for recipes suggestions, in case no recipe matchs we also suggest recipes with one ingredient missing.


#Init project
docker-compose up

docker-compose run web rails db:create

docker-compose run web rails db:migrate

docker-compose run web rails db:seed

#Launch tests
docker-compose run web bundle exec rails test


#Improvements

The views are quite simple for the moment, a cleaner user experience muist be implemented
Add pagination to recipes
Create a launch_recipe action with a persistent model Recipe (to save our favorites and avoid having recipes we just made)
Add an authentication and roles implementation with cancancan (to have our own fridge)
Continue React implementation
An Api to call (or scrap data) to Marmiton for fresh recipes
An Api to the supermarket for a food delivery
