require 'test_helper'

class TokujoSaleOrders::SucceededMailerTest < ActionMailer::TestCase
  test "should send succeeded email" do
    order = orders(:order_one)
    user_patron = user_patrons(:user_patron_one)
    tokujo = tokujos(:tokujo_one)
    user = users(:user_one)

    assert_difference "ActiveJob::Base.queue_adapter.enqueued_jobs.size", 1 do
      TokujoSaleOrders::SucceededMailer.with(order: order, user_patron: user_patron, tokujo: tokujo, user: user).succeeded_email.deliver_later
    end

    perform_enqueued_jobs

    delivered_email = ActionMailer::Base.deliveries.last

    assert_equal "ablejo #{ENV["RAILS_CUSTOMER_SUPPORT_EMAIL"]}", delivered_email.from
    assert_equal [user_patron.email], delivered_email.to
    assert_equal "Order #{order.id}", delivered_email.subject
    assert_includes delivered_email.text_part.decoded, <<~EOL
      Thank you for placing your order with user_one.
      Your card has been set up. We will charge your card as soon as the tokujo closes.
    
      Order summary
      Order ID: 959957393
      Tokujo: catchy headline
      Description: Menu item one description
      Price: <span>$</span>
      <span>
          <span>10000.00</span>
      </span>
      Order size: 1
      Total Price (incl. tax): <span>$</span>
      <span>
          <span>0.00</span>
              <span>&nbsp(incl. tax)</span>
      </span>
      EOL
  end
end