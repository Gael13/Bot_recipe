# bundle exec ruby -Itest test/services/recipe_generator_test.rb

require 'test_helper'

class RecipeGeneratorTest < ActiveSupport::TestCase

  def setup
    ingredients = {'Jambon' => '2 tranches', 'Fromage' => '500g', 'pâte brisée' => '1',  'Moutarde' => '',
             'tranche de raclette' => '', 'tomate' => '1', 'Herbes de Provence' => '',
               'sel' => '', 'gambas crues fraîches' => '400g', 'calamar' => '200g',
               'nouilles chinoises aux oeufs' => '400g', 'épinards frais' => '300g',
               'germes de soja' => '100g', 'carotte' => '1', 'champignon noir déshydratés' => '30g',
               'soja' => '2 cuillères à soupe', 'huile de tournesol' => '6 cuillères à soupe',
                'gousse(s) d\'ail' => '2', 'morceau de gingembre' => '1'}

    fridge = Fridge.create!(title: 'Frigo')
    i = 0

    ingredients.each do |ingredient, quantity|
      i += 1
      instance_variable_set("@ingredient_#{i}",  Ingredient.create!(title: ingredient))
      instance_variable_set("@ingredient_fridge_#{i}", IngredientFridge.create!(ingredient_id: instance_variable_get("@ingredient_#{i}").id, fridge_id: fridge.id, quantity: quantity))
    end
  end

  def test_no_recipe_match
    ingredient_fridges = [] 

    recipe_generator = generator(ingredient_fridges)

    assert_equal 'Fridge is empty', recipe_generator.errors[:no_ingredients]

    # add two ingredients to fridge
    ingredient_fridges << @ingredient_fridge_1
    ingredient_fridges << @ingredient_fridge_2

    recipe_generator = generator(ingredient_fridges)
    recipe_generator.perform

    assert_equal 'No recipe found', recipe_generator.errors[:no_recipe]
  end

  def test_no_recipe_match_with_one_missing_ingredient   
    ingredient_fridges = [] 
    ingredient_fridges << @ingredient_fridge_1
    ingredient_fridges << @ingredient_fridge_2
    ingredient_fridges << @ingredient_fridge_3
    ingredient_fridges << @ingredient_fridge_4
    ingredient_fridges << @ingredient_fridge_5
    ingredient_fridges << @ingredient_fridge_6

    missing_ingredient = [{"author"=>"anna_16547315", "name"=>"Tarte à la raclette et au jambon", "ingredient_missing"=>["Herbes de Provence"]}]

    recipe_generator = generator(ingredient_fridges)
    recipe_generator.perform

    recipe = recipe_generator.match_recipes.select { |r| r["author"] == "anna_16547315"}.first

    assert_equal missing_ingredient.first['author'], recipe['author']
    assert_equal missing_ingredient.first['name'], recipe['name']
    assert_equal missing_ingredient.first['ingredient_missing'], recipe['ingredient_missing']


    # add other recipe ingredients to fridge with still a missing ingredient
    ingredient_fridges << @ingredient_fridge_9
    ingredient_fridges << @ingredient_fridge_10
    ingredient_fridges << @ingredient_fridge_11
    ingredient_fridges << @ingredient_fridge_12
    ingredient_fridges << @ingredient_fridge_13
    ingredient_fridges << @ingredient_fridge_14
    ingredient_fridges << @ingredient_fridge_15
    ingredient_fridges << @ingredient_fridge_16
    ingredient_fridges << @ingredient_fridge_17
    ingredient_fridges << @ingredient_fridge_18

    missing_ingredient = [{"author"=>"anna_16547315",  "name"=>"Tarte à la raclette et au jambon", 
                           "ingredient_missing"=>["Herbes de Provence"]},
                           {"author"=>"romina_15823121", "name"=>"Wok de nouilles sautées aux gambas et épinards",
                           "ingredient_missing"=>["1morceau de gingembre"]}]
    
    recipe_generator = generator(ingredient_fridges)
    recipe_generator.perform

    recipe = recipe_generator.match_recipes.select { |r| r["author"] == "romina_15823121"}.first

    assert_equal missing_ingredient.last['author'], recipe['author']
    assert_equal missing_ingredient.last['name'], recipe['name']
    assert_equal missing_ingredient.last['ingredient_missing'], recipe['ingredient_missing']
  end

  def test_recipe_match
    ingredient_fridges = [] 
    ingredient_fridges << @ingredient_fridge_1
    ingredient_fridges << @ingredient_fridge_2
    ingredient_fridges << @ingredient_fridge_3
    ingredient_fridges << @ingredient_fridge_4
    ingredient_fridges << @ingredient_fridge_5
    ingredient_fridges << @ingredient_fridge_6
    ingredient_fridges << @ingredient_fridge_7

    recipe_sample = [{"author"=>"anna_16547315", "name"=>"Tarte à la raclette et au jambon"}]

    recipe_generator = generator(ingredient_fridges)
    recipe_generator.perform

    recipe = recipe_generator.match_recipes.select { |r| r["author"] == "anna_16547315"}.first

    assert_equal recipe_sample.first['author'], recipe['author']
    assert_equal recipe_sample.first['name'], recipe['name']


    # add other recipe ingredients to fridge
    ingredient_fridges << @ingredient_fridge_9
    ingredient_fridges << @ingredient_fridge_10
    ingredient_fridges << @ingredient_fridge_11
    ingredient_fridges << @ingredient_fridge_12
    ingredient_fridges << @ingredient_fridge_13
    ingredient_fridges << @ingredient_fridge_14
    ingredient_fridges << @ingredient_fridge_15
    ingredient_fridges << @ingredient_fridge_16
    ingredient_fridges << @ingredient_fridge_17
    ingredient_fridges << @ingredient_fridge_18
    ingredient_fridges << @ingredient_fridge_19

    recipe_sample = [{"author"=>"anna_16547315", "name"=>"Tarte à la raclette et au jambon"},
              {"author"=>"romina_15823121", "name"=>"Wok de nouilles sautées aux gambas et épinards"}]

    recipe_generator = generator(ingredient_fridges)
    recipe_generator.perform

    recipe = recipe_generator.match_recipes.select { |r| r["author"] == "romina_15823121"}.first

    assert_equal recipe_sample.last['author'], recipe['author']
    assert_equal recipe_sample.last['name'], recipe['name']
  end

  def generator(inputs)
    RecipeGenerator.new(inputs)
  end

end
