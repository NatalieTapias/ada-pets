class PetsController < ApplicationController
  def index
    pets = Pet.all
    render :json => pets.as_json(only: [:name, :age, :human, :id]), status: :ok
  end



  private

    def pet_params
      params.require(:pet).permit(:name, :age, :human)
    end
end
