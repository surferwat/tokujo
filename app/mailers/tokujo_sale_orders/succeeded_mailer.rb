class TokujoSaleOrders::SucceededMailer < ApplicationMailer
  default from: "ablejo #{ENV["RAILS_CUSTOMER_SUPPORT_EMAIL"]}"
  layout "mailer"

  def succeeded_email
    order = params[:order]
    tokujo = params[:tokujo]
    user = params[:user]
    user_patron = params[:user_patron]

    # Set instance variables for use in email
    @username = user.username
    @card_action_message = tokujo.payment_collection_timing == "delayed" ? "Your card has been set up. We will charge your card as soon as the tokujo closes." : "Your card has been charged."
    @order_id = order.id
    @tokujo_headline = tokujo.headline
    @tokujo_description = tokujo.menu_item.description
    @price = Money.new(tokujo.menu_item.price_base, tokujo.menu_item.price_currency).format
    @size = order.size
    @total_price_with_tax = Money.new(order.size.to_i * tokujo.menu_item.price_with_tax_base, tokujo.menu_item.price_currency).format

    # Send mail
    mail(to: user_patron.email, subject: "Order #{order.id}")
  end
end
