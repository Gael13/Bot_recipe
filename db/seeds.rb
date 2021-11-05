# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Ingredient.delete_all
Fridge.delete_all
IngredientFridge.delete_all

ingredients = {'Jambon' => '2 tranches', 'Fromage' => '500g', 'pâte brisée' => '1',  'Moutarde' => '',
	           'tranche de raclette' => '', 'tomate' => '1', 'Herbes de Provence' => '',
               'sel' => '', 'gambas crues fraîches' => '400g', 'calamar' => '200g',
               'nouilles chinoises aux oeufs' => '400g', 'épinards frais' => '300g',
               'germes de soja' => '100g', 'carotte' => '1', 'champignon noir déshydratés' => '30g',
               'soja' => '2 cuillères à soupe', 'huile de tournesol' => '6 cuillères à soupe',
                'gousse(s) d\'ail' => '2', 'morceau de gingembre' => '1'}

fridge =  Fridge.create!(title: 'Frigo')

ingredients.each do |ingredient, quantity|
  i = Ingredient.create!(title: ingredient)
  IngredientFridge.create!(ingredient_id: i.id, fridge_id: fridge.id, quantity: quantity)
end