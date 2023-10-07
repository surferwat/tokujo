require 'test_helper'

class TokujoSalePolicyTest < ActiveSupport::TestCase
  def test_show
    policy = TokujoSalePolicy.new(nil, nil)
    assert policy.show?
  end
end
