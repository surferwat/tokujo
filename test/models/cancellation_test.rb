require "test_helper"

class CancellationTest < ActiveSupport::TestCase
  def setup
    @cancellation = cancellations(:cancellation_one)
  end

  # Valid attributes
  test "should be valid" do
    assert @cancellation.valid?
  end

  test "should validate presence of required attributes" do
    assert_presence_of_attributes(@cancellation, [:user_id, :user_email, :user_created_at, :user_updated_at, :user_stripe_customer_id])
  end

  private
  
  def assert_presence_of_attributes(record, attributes)
    attributes.each do |attribute|
      record.send("#{attribute}=", nil)
      assert_not record.valid?
      assert_includes record.errors[attribute], "can't be blank"
    end
  end
end
