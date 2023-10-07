require 'test_helper'

class TokujoSalePatronPolicyTest < ActiveSupport::TestCase
  def test_new
    policy = TokujoSalePatronPolicy.new(nil, nil)
    assert policy.new?
  end

  def test_create
    policy = TokujoSalePatronPolicy.new(nil, nil)
    assert policy.create?
  end
end
