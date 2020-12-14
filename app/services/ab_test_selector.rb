class ABTestSelector
  ##
  # Create a new ABTestSelector
  #
  # @param [Hash<Symbol,Array<String>] tests A hash of tests and possible variants
  # @param [ActionDispatch::Request] request the Rails request object
  def initialize(tests, request:)
    @tests = tests
    @ip_number = IPAddr.new(request.remote_ip).to_i
  end

  ##
  # Picks and memoises variants for a request based on equal distribution over
  # the request's IP address.
  #
  # @return [Hash<Symbol,Symbol>]
  def selected_variants
    @selected_variants ||= @tests.transform_values do |variants|
      index = @ip_number % variants.size
      variants[index].to_sym
    end
  end
end
