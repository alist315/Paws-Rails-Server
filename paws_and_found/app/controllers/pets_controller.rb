class PetsController < ApplicationController
  # index route
  def index
    render json: Pet.all
  end

  #show route
  def show
    render json: Pet.find(params["id"])
  end

  # create route
  def create
    render json: Pet.create(params["pet"])
  end

  # delete route
  def delete
    render json: Pet.delete(params["id"])
  end

  # update route
  def update
    render json: Pet.update(params["id"], params["pet"])
  end
end
