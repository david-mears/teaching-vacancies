module AbTestable
  extend ActiveSupport::Concern

  included do
    helper_method :ab_tests
  end

  def ab_tests
    @ab_tests ||= ABTestSelector.new(Rails.configuration.ab_tests, user_identifier: ab_user_identifier)
  end

private

  def ab_user_identifier
    IPAddr.new(request.remote_ip).to_i
  end
end
