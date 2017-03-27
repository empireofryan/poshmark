class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @items = []
    @items << Item.new
  end

  def edit
    @item = Item.find(:all)
  end

  def update
    @item = Item.find(params[:item][:id])
    @item.update(item_params)
  end

  def multiple_item_info
    params[:item].each do |param|
      Item.find_by_id(param[:id]).update(param.permit!)
    end
    flash[:notice] = "Item successfully updated"
    redirect_to items_path
  end

  def create
    @item = Item.create(item_params)


     redirect_to items_path(@item)
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:id, :name, :avatar,
      :price_painted, :price_plated, :model, :item_length)
  end

end
