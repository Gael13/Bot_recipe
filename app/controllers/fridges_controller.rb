class FridgesController < ApplicationController
  before_action :set_fridge, only: %i[ show edit update destroy add_ingredient remove_ingredient recipes]
  before_action :set_ingredients_fridge, only: %i[ show recipes ]

  # GET /fridges or /fridges.json
  def index
    @fridges = Fridge.all
  end

  # GET /fridges/1 or /fridges/1.json
  def show
    @ingredients = Ingredient.all
  end

  # GET /fridges/new
  def new
    @fridge = Fridge.new
  end

  # GET /fridges/1/edit
  def edit
  end

  # POST /fridges or /fridges.json
  def create
    @fridge = Fridge.new(fridge_params)

    respond_to do |format|
      if @fridge.save
        format.html { redirect_to @fridge, notice: "Fridge was successfully created." }
        format.json { render :show, status: :created, location: @fridge }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fridge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fridges/1 or /fridges/1.json
  def update
    respond_to do |format|
      if @fridge.update(fridge_params)
        format.html { redirect_to @fridge, notice: "Fridge was successfully updated." }
        format.json { render :show, status: :ok, location: @fridge }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fridge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fridges/1 or /fridges/1.json
  def destroy
    @fridge.destroy
    respond_to do |format|
      format.html { redirect_to fridges_url, notice: "Fridge was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_ingredient
   @ingredient_fridge = IngredientFridge.find_or_create_by(
                          fridge_id: params[:id], 
                          ingredient_id: params[:ingredient_id]
                        )

    respond_to do |format|
      if @ingredient_fridge.save
        format.html { redirect_to @fridge, notice: 'Ingredient was successfully added to the fridge' }
        format.json { render :show, status: :created, location: @fridge }
      else
        format.html { render :new }
        format.json { render json: @ingredient_fridge.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove_ingredient
    @ingredient_fridge = IngredientFridge.find(params[:ingredient_fridge_id])
    @ingredient_fridge.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to @fridge }
    end
  end

  def recipes
    @recipe_generator = RecipeGenerator.new(@ingredients_fridge)
    @recipe_generator.perform

    @recipes = @recipe_generator.match_recipes
    @errors = @recipe_generator.errors

    respond_to do |format|
      format.json { render json: @errors.blank? ? @recipes : @errors, 
                           status: @errors.blank? ? 200 : 400 
                  }
      format.html 
    end
  end
  
  # TODO add a launch recipe action for recipe saving, remove ingredients from fridge...
  #def launch_recipe
    #@recipe = OpenStruct.new(data: params[:recipe])
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fridge
      @fridge = Fridge.find(params[:id])
    end

    def set_ingredients_fridge
      @ingredients_fridge = IngredientFridge.where(fridge_id: @fridge.id)
    end

    # Only allow a list of trusted parameters through.
    def fridge_params
      params.require(:fridge).permit(:title)
    end
end
