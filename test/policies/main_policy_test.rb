require 'test_helper'

class MainPolicyTest < ActiveSupport::TestCase
  def test_index
    policy = MainPolicy.new(nil, nil)
    assert policy.index?
  end
end
