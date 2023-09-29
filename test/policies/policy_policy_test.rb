require 'test_helper'

class PolicyPolicyTest < ActiveSupport::TestCase
  def test_index
    policy = PolicyPolicy.new(nil, nil)
    assert policy.index?
  end
end
