require 'test_helper'

class BusinessInformationPolicyTest < ActiveSupport::TestCase
  def test_index
    policy = BusinessInformationPolicy.new(nil, nil)
    assert policy.index?
  end
end
