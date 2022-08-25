class OrdersController < ApplicationController
  before_action :logged_in_user, only: %i(new create)
  before_action :current_cart, :load_product_in_cart
  before_action :check_product_quantity, only: %i(new create)

  def new
    @order = current_user.orders.build
    @product = Product.find_by id: params[:id]
  end

  def create
    @order = current_user.orders.new order_params
    if @order.valid?
      create_transaction
    else
      flash.now[:danger] = t ".order_fail"
      render :new
    end
  end

  private
  def order_params
    params.require(:order).permit Order::ORDER_ATTRS
  end

  def create_order_detail
    @products.each do |item|
      product_id = item.id.to_i
      @order.order_details.create!(
        product_id: product_id,
        quantity: @carts[product_id.to_s],
        price: item.price
      )
    end
  end

  def create_transaction
    ActiveRecord::Base.transaction do
      @order.save!
      create_order_detail

      clear_carts
      redirect_to root_path
      flash[:success] = t ".success_checkout"
    end
  rescue StandardError
    flash[:danger] = t ".danger_checkout"
    redirect_to carts_path
  end
end