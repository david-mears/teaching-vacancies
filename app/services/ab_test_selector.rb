class ABTestSelector
  ##
  # Create a new ABTestSelector
  #
  # @param [Hash{Symbol=>Hash{Symbol=>Integer}}] tests A hash of tests to variants with weights
  # @param [ActionDispatch::Request] request the Rails request object
  def initialize(tests, request:)
    @tests = tests
    @ip_number = IPAddr.new(request.remote_ip).to_i
  end

  ##
  # Picks variants for all tests based on a weighted distribution over the request's IP address
  #
  # This allows us to be reasonably consistent when targeting a specific user session while
  # preserving user privacy and not requiring the use of cookies.
  #
  # @return [Hash{Symbol=>Symbol}] A hash of all tests to their selected variant
  def selected_variants
    @selected_variants ||= @tests.transform_values do |variants|
      index = @ip_number % variants.values.sum
      candidates = variants.flat_map { |variant_name, weight| [variant_name] * weight }

      candidates[index].to_sym
    end
  end

  ##
  # Returns the selected variant for a given test
  #
  # @param [Symbol] test
  #
  # @raise [ArgumentError] if there is no test with that name
  # @return [Symbol] the selected variant
  def variant_for(test)
    selected_variants[test] || raise(ArgumentError, "No such test: #{test}")
  end

  ##
  # Determines whether the current variant for a test matches that provided
  #
  # @param [Symbol] test
  # @param [Symbol] variant
  #
  # @raise [ArgumentError] if there is no test with that name
  # @return [Boolean] whether the current variant for the test and the one given match
  def variant?(test, variant)
    variant_for(test) == variant
  end
end
