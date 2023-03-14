class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
  end

  def create
    charge = perform_stripe_charge
    order  = create_order(charge)

    if order.valid?
      empty_cart!
      redirect_to order, notice: 'Your Order has been placed.'
    else
      redirect_to cart_path, flash: { error: order.errors.full_messages.first }
    end

  rescue Stripe::CardError => e
    redirect_to cart_path, flash: { error: e.message }
  end

  private

  def empty_cart!
    # empty hash means no products in cart :)
    update_cart({})
  end

  def perform_stripe_charge
    Stripe::Charge.create(
      source:      params[:stripeToken],
      amount:      cart_subtotal_cents,
      description: "Khurram Virani's Jungle Order",
      currency:    'cad'
    )
  end

  def create_order(stripe_charge)
    order = Order.new(
      email: params[:stripeEmail],
      total_cents: cart_subtotal_cents,
      stripe_charge_id: stripe_charge.id, # returned by stripe
    )

    enhanced_cart.each do |entry|
      product = entry[:product]
      quantity = entry[:quantity]
      order.line_items.new(
        product: product,
        quantity: quantity,
        item_price: product.price,
        total_price: product.price * quantity
      )
    end
    order.save!
    order
  end

  def enhanced_order
    product_id_array = Array.new
    product_quantity_array = Array.new
    LineItem.where(order_id: params[:id]).each {|order| product_id_array << order.product_id }
    LineItem.where(order_id: params[:id]).each {|order| product_quantity_array << order.quantity }
    puts product_id_array
    puts product_quantity_array

    @enhanced_order ||= Product.where(id: product_id_array).map.with_index {|product, idx| { product:product, quantity: product_quantity_array[idx]} }
  end
  helper_method :enhanced_order

  def order_subtotal_cents
    enhanced_order.map {|entry| entry[:product].price_cents * entry[:quantity]}.sum
  end
  helper_method :order_subtotal_cents

end
