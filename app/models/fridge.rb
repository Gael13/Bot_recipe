class Fridge < ApplicationRecord
  has_many :ingredient_fridges
  has_many :ingredients, :through => :ingredient_fridges
end
