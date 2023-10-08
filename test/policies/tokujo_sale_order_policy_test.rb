require 'test_helper'

class TokujoSaleOrderPolicyTest < ActiveSupport::TestCase
  def test_index
    policy = TokujoSaleOrderPolicy.new(nil, nil)
    assert policy.index?
  end

  def test_new
    policy = TokujoSaleOrderPolicy.new(nil, nil)
    assert policy.new?
  end

  def test_create
    policy = TokujoSaleOrderPolicy.new(nil, nil)
    assert policy.create?
  end
end
