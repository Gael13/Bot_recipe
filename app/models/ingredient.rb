class Ingredient < ApplicationRecord
  has_many :ingredient_fridges
  has_many :fridges, :through => :ingredient_fridges
end
