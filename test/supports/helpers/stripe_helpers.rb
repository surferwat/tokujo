require "yaml"
require "json"

module StripeHelpers
  def self.construct_webhook_request(vcr_file_name, event_name)
    current_time = Time.now.to_i
    pulled_data = YAML.load_stream(File.read("test/supports/fixtures/vcr_cassettes/#{vcr_file_name}.yml"))
    body = JSON.parse(pulled_data[0]['http_interactions'][0]['response']['body']['string'])
    body["created"] = current_time

    # REFERENCE: https://stripe.com/docs/api/events/object
    request_body = {
      id: "evt_XXXXXXXXXXXXXXXXXX",
      object: "event",
      api_version: "2022-11-15",
      created: current_time,
      data: {
        object: body
      },
      livemode: false,
      pending_webhooks: 0,
      request: {
        id: "req_XXXXXXXXXXXX",
        idempotency_key: "XXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXX"
      },
      type: event_name
    }  
    return JSON.dump(request_body)
  end
end