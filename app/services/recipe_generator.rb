class RecipeGenerator
  attr_reader :errors, :match_recipes

  def initialize(ingredient_fridges)
    @ingredient_fridges = ingredient_fridges
    @errors = Hash.new(0)
    @errors[:no_ingredients] = 'Fridge is empty' if @ingredient_fridges.blank?
    @errors[:no_recipe] = 'No recipe found' if recipes.blank?
    @match_recipes = []
  end

  def perform
    recipes_with_missing_ingredient = []
    return unless @errors.blank?

    recipes.each do |recipe|
      next if recipe['name'].nil?

      available_ingredients = find_available_ingredients(recipe)
      next if available_ingredients.size == 0

      if recipe['ingredients'].size == available_ingredients.size
        @match_recipes << recipe
      elsif recipe['ingredients'].size - available_ingredients.size == 1
        recipe['ingredient_missing'] = recipe['ingredients'] - available_ingredients
        recipes_with_missing_ingredient << recipe
      end

      break if @match_recipes.size == 10
    end

    check_if_no_recipe(recipes_with_missing_ingredient) if @match_recipes.blank?
  end

  private

  def find_available_ingredients(recipe)
    ingredients = []

    @ingredient_fridges.flat_map do |ingredient_fridge|
      next if no_ingredients?(ingredient_fridge)

      matched_ingredients =
        find_ingredients(recipe['ingredients'], ingredient_fridge.ingredient.title)

      ingredients.push(*matched_ingredients)
    end

    ingredients.uniq!
    ingredients
  end

  def find_ingredients(recipe_ingredients, ingredient_name)
    recipe_ingredients.select do |ingredient|
      ingredient.match?(/#{ingredient_name}/)
    end
  end

  def no_ingredients?(ingredient_fridge)
    ingredient_fridge.ingredient.nil?
  end

  def recipes
    @recipes ||= RecipeQuery.new.call
  end

  def check_if_no_recipe(missing_ingredient)
    unless missing_ingredient.blank?
      @match_recipes = missing_ingredient
    else
      @errors[:no_recipe] = 'No recipe found'
    end
  end

end
