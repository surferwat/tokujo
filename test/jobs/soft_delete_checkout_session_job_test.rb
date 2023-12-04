require "test_helper"

class SoftDeleteCheckoutSessionJobTest < ActiveJob::TestCase
  test "should assert job is performed" do
    checkout_session = checkout_sessions(:checkout_session_three)
    assert_performed_jobs 0
    perform_enqueued_jobs do
      SoftDeleteCheckoutSessionJob.perform_later(checkout_session)
    end
    assert_performed_jobs 1
  end
end
