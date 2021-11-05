class RecipeQuery

  # filter recipe authors
  WHITELISTED_AUTHORS = [
    'romina_15823121',
    'anna_16547315'
  ].freeze

  RECIPE_PATH = File.join(Rails.root, 'public', 'recipes.json')

  def call
    return [] unless recipes_json_file_exists?

    raw_recipes = File.read(RECIPE_PATH)

    JSON.parse(raw_recipes).select { |recipe| WHITELISTED_AUTHORS.include?(recipe['author']) }
    #JSON.parse(raw_recipes)
  end

  def recipes_json_file_exists?
    File.exist?(RECIPE_PATH)
  end
end
