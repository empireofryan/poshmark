class QueriesController < ApplicationController
  def index
    @queries = Query.all
  end

  def new
    @query = Query.new
  end

  def create
    new_query = params.require(:query).permit(:search)
    query = Query.create(new_query)
    %x[rake hydra:run]
    redirect_to items_path
  end

  def show
    id = params[:id]
    @query = Query.find(id)
  end
end
