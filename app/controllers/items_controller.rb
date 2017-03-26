class ItemsController < ApplicationController
  def index
    @items = Item.all
    # @item = Item.new(params[:item])
    # if @item.save
    #   # success
    # else
    #   # error handling
    # end
  end

  def omg
    my_input = params['my_input']
    #do whatever you want with my_input
  end
end
