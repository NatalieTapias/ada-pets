class PetsController < ApplicationController
  def index
    pets = Pet.all.as_json(only: [:name, :age, :human, :id])
    render json: pets, status: :ok
  end

  def show
    pet = Pet.find_by(id: params[:id]).as_json(only: [:name, :age, :human, :id])
    if pet
      render json: pet, status: :ok
      return
    else
      render json: { "errors" => ["not found"] }, status: :not_found
      return
    end
  end


  private

    def pet_params
      params.require(:pet).permit(:name, :age, :human, :id)
    end
end